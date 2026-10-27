#!/usr/bin/env python3
"""Export the neon bars lab from an isolated copy; leave Main untouched."""
import argparse
import pathlib
import re
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--godot', default=shutil.which('godot') or 'godot')
parser.add_argument('--output', required=True)
args = parser.parse_args()
source = pathlib.Path(__file__).resolve().parents[1]
output = pathlib.Path(args.output).resolve()
with tempfile.TemporaryDirectory(prefix='gambit-bars-export-') as name:
    project = pathlib.Path(name) / 'project'
    shutil.copytree(source, project, ignore=shutil.ignore_patterns('.git', '.godot', '.agents', '.codex', '.aws', '__pycache__'))
    config = project / 'project.godot'
    config.write_text(re.sub(r'^run/main_scene="[^"]*"$', 'run/main_scene="res://scenes/debug/neon_bars_lab.tscn"', config.read_text(), flags=re.MULTILINE))
    preset = project / 'export_presets.cfg'
    settings = re.sub(r'^version/name="[^"]*"$', 'version/name="0.1.0-graphics011-lab"', preset.read_text(), flags=re.MULTILINE)
    preset.write_text(settings)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--editor', '--import', '--quit'], check=True)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--export-debug', 'Android Debug', str(output)], check=True)
print(output)
