#!/usr/bin/env python3
"""Run STEP-028's fixed protocol on one explicitly selected Debug device.

No unlock, device-setting changes, log clearing, or package-data clearing.
Requires the Debug APK to be installed; --apk identifies it, it is not installed here.
"""
import argparse
import hashlib
import json
from pathlib import Path
import re
import shlex
import subprocess
import time

PACKAGE = "org.gambitarena.prototype"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adb", default="adb")
    parser.add_argument("--serial", required=True)
    parser.add_argument("--apk", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--repeats", type=int, default=3, choices=range(1, 4))
    parser.add_argument("--scenario", choices=["normal", "saturated20", "resets10"],
                        help="Un seul scenario pour une investigation ciblee ; campagne complete par defaut.")
    parser.add_argument("--note", default="", help="Conditions externes, 240 caracteres max.")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    apk_sha = hashlib.sha256(args.apk.read_bytes()).hexdigest()

    def adb(*command, check=True, binary=False):
        result = subprocess.run([args.adb, "-s", args.serial, *command],
                                capture_output=True, text=not binary, timeout=20)
        if check and result.returncode:
            raise RuntimeError(f"ADB {command[0]}: {result.stderr}")
        return result.stdout if result.returncode == 0 else ""

    def shell(command, **kwargs):
        return adb("shell", command, **kwargs).strip()

    def conditions():
        # Fixed, bounded subset; battery temperature is not CPU/GPU temperature.
        battery = shell("dumpsys battery").split("BatteryInfoBackUp")[0]
        keep = [row.strip() for row in battery.splitlines()
                if re.match(r"\s*(level|temperature|USB powered|AC powered|status|voltage):", row)]
        return {"battery": keep,
                "brightness": shell("settings get system screen_brightness"),
                "brightness_mode": shell("settings get system screen_brightness_mode"),
                "screen_timeout_ms": shell("settings get system screen_off_timeout"),
                "power_save": shell("settings get global low_power"),
                "power_state": [row.strip() for row in shell("dumpsys power").splitlines()
                                if "mWakefulness=" in row or "mIsPowered=" in row]}

    device = {"model": shell("getprop ro.product.model"),
              "android": shell("getprop ro.build.version.release"),
              "build": shell("getprop ro.build.fingerprint")}
    component = shell(f"cmd package resolve-activity --brief {PACKAGE}").splitlines()[-1]
    if not component.startswith(PACKAGE + "/"):
        raise RuntimeError("Activite Android introuvable")
    # Verify installed binary identity, instead of trusting a version label alone.
    installed_path = shell(f"pm path {PACKAGE}").splitlines()[0].removeprefix("package:")
    installed_sha = hashlib.sha256(adb("exec-out", "cat", installed_path, binary=True)).hexdigest()
    if installed_sha != apk_sha:
        raise RuntimeError("Le SHA de l'APK installe differe du fichier fourni")
    manifest = {"apk_sha256": apk_sha, "apk_name": args.apk.name, "device": device,
                "note": args.note[:240], "protocol": "step028-v1 / warm30 capture60",
                "repeats": args.repeats, "runs": []}
    (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2))
    if args.scenario:
        choices = [(args.scenario, repeat) for repeat in range(1, args.repeats + 1)]
    else:
        choices = [(choice, repeat) for repeat in range(1, args.repeats + 1)
                   for choice in ("normal", "saturated20")]
        choices.append(("resets10", 1))
    for choice, repeat in choices:
        before = conditions()
        if not any("Awake" in state for state in before["power_state"]):
            raise RuntimeError("Ecran en veille : deverrouiller le telephone avant de continuer")
        name = f"{choice}-{repeat}"
        shell(f"am force-stop {PACKAGE}")
        slot_text = shell(f"run-as {PACKAGE} cat files/performance/next-slot.txt", check=False)
        slot = int(slot_text) % 12 if slot_text.isdigit() else 0
        request = shlex.quote(f"printf '%s\\n' {choice} > files/performance-request.txt")
        shell(f"run-as {PACKAGE} sh -c {request}")
        shell(f"am start -W -n {component}")
        pid = shell(f"pidof {PACKAGE}")
        print(f"{name}: chauffe 30 s, capture 60 s", flush=True)
        deadline = time.monotonic() + 115
        raw = ""
        while time.monotonic() < deadline:
            time.sleep(3)
            next_text = shell(f"run-as {PACKAGE} cat files/performance/next-slot.txt", check=False)
            if next_text.isdigit() and int(next_text) % 12 != slot:
                raw = shell(f"run-as {PACKAGE} cat files/performance/capture-{slot:02d}.json")
                break
        after = conditions()
        if not raw:
            raise RuntimeError(f"{name}: aucun export sous 115 s ; verifier focus/verrouillage/log Godot")
        capture = json.loads(raw)
        if capture["metadata"]["scenario"] != choice:
            raise RuntimeError("Le scenario exporte differe de la demande")
        envelope = {"apk_sha256": apk_sha, "device": device, "note": args.note[:240],
                    "before": before, "after": after, "capture": capture}
        (args.output / (name + ".json")).write_text(json.dumps(envelope))
        if re.fullmatch(r"\d+", pid):
            log = adb("logcat", "-d", "-t", "1000", "--pid=" + pid, "godot:V", "*:S")
            (args.output / (name + ".log")).write_text(log)
        summary = capture["summary"]
        row = {"name": name, "phase": capture["phase"], "reason": capture["reason"],
               "mean_fps": summary["mean_fps"], "frames": summary["frame_interval"]}
        manifest["runs"].append(row)
        (args.output / "manifest.json").write_text(json.dumps(manifest, indent=2))
        print(json.dumps(row), flush=True)
        if capture["phase"] != "complete":
            raise RuntimeError(f"{name}: capture interrompue, aucune conclusion de budget")


if __name__ == "__main__":
    main()
