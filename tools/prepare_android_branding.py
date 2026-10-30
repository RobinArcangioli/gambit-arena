#!/usr/bin/env python3
"""Prepare stock Godot Android templates with a true black native launch background.

Non-Gradle exports ignore splash_screen/background_color. Patch only two existing
ResTable_map colour values; Godot still performs the normal APK export/signing.
No game code, permissions, resource layout or original installed template is changed.
"""
from pathlib import Path
import argparse, hashlib, json, re, struct, subprocess, zipfile


def main():
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument('--templates', type=Path, default=Path.home()/'.local/share/godot/export_templates/4.7.2.stable')
    args.add_argument('--aapt2', type=Path, default=Path.home()/'Android/Sdk/build-tools/36.0.0/aapt2')
    options = args.parse_args()
    root = Path(__file__).resolve().parents[1]
    destination = root/'.godot/branding'
    destination.mkdir(parents=True, exist_ok=True)
    results = []
    for build in ['debug', 'release']:
        source = options.templates/f'android_{build}.apk'
        dump = subprocess.run([str(options.aapt2), 'dump', 'resources', str(source)], capture_output=True, text=True, check=True).stdout
        def resource_id(name):
            match = re.search(r'resource (0x[0-9a-f]+) '+re.escape(name)+r'\b', dump)
            if match is None: raise RuntimeError('Missing resource '+name)
            return int(match[1], 16)
        custom = resource_id('attr/windowSplashScreenBackground')
        background = resource_id('mipmap/icon_background')
        with zipfile.ZipFile(source) as original:
            table = bytearray(original.read('resources.arsc'))
            offsets = []
            for name, value_type, value in [(custom, 0x02, 0x01010031), (0x0101062c, 0x01, background)]:
                pattern = struct.pack('<IHBBI', name, 8, 0, value_type, value)
                found = [match.start() for match in re.finditer(re.escape(pattern), bytes(table))]
                if len(found) != 1: raise RuntimeError(f'Expected one splash role, got {len(found)} for {name:#x}')
                position = found[0]
                table[position+7] = 0x1c  # TYPE_INT_COLOR_ARGB8
                struct.pack_into('<I', table, position+8, 0xff000000)
                offsets.append(position)
            target = destination/f'android_black_{build}.apk'
            temporary = target.with_suffix('.tmp')
            with zipfile.ZipFile(temporary, 'w') as output:
                for entry in original.infolist():
                    output.writestr(entry, bytes(table) if entry.filename == 'resources.arsc' else original.read(entry.filename))
            temporary.replace(target)
        results.append({'build':build,'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'patched_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'colour_offsets':offsets})
    (destination/'manifest.json').write_text(json.dumps(results,indent=2))
    print('Black Android launch templates prepared (debug/release).')

if __name__ == '__main__':main()
