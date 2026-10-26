#!/usr/bin/env python3
"""Export the navigation lab from an isolated copy; leave Main untouched."""
import argparse
import pathlib
import shutil
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--godot', default=shutil.which('godot') or 'godot')
parser.add_argument('--output', required=True)
args = parser.parse_args()
source = pathlib.Path(__file__).resolve().parents[1]
output = pathlib.Path(args.output).resolve()
with tempfile.TemporaryDirectory(prefix='gambit-navigation-export-') as name:
    project = pathlib.Path(name) / 'project'
    shutil.copytree(source, project, ignore=shutil.ignore_patterns('.git', '.godot', '.agents', '.codex', '.aws', '__pycache__'))
    config = project / 'project.godot'
    config.write_text(config.read_text().replace('run/main_scene="uid://do6vxhog253vu"', 'run/main_scene="res://scenes/debug/local_navigation_autorun.tscn"'))
    preset = project / 'export_presets.cfg'
    preset.write_text(preset.read_text().replace('version/code=41', 'version/code=40').replace('version/name="0.1.0-gameplay002"', 'version/name="0.1.0-gameplay002-lab"'))
    subprocess.run([args.godot, '--headless', '--path', str(project), '--editor', '--import', '--quit'], check=True)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--export-debug', 'Android Debug', str(output)], check=True)
print(output)
