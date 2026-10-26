#!/usr/bin/env python3
"""Build the diagnostic Android entry point in a temporary copy, preserving Main."""
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
with tempfile.TemporaryDirectory(prefix='gambit-graphics007-export-') as name:
    project = pathlib.Path(name) / 'project'
    shutil.copytree(source, project, ignore=shutil.ignore_patterns('.git', '.godot', '.agents', '.codex', '.aws', '__pycache__'))
    config = project / 'project.godot'
    text = config.read_text().replace('run/main_scene="uid://do6vxhog253vu"', 'run/main_scene="res://scenes/debug/graphics_qualification_autorun.tscn"')
    config.write_text(text)
    preset = project / 'export_presets.cfg'
    text = preset.read_text().replace('version/code=37', 'version/code=38').replace('version/code=39', 'version/code=38')
    text = text.replace('version/name="0.1.0-graphics006"', 'version/name="0.1.0-graphics007-qualification"').replace('version/name="0.1.0-graphics007"', 'version/name="0.1.0-graphics007-qualification"')
    preset.write_text(text)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--editor', '--import', '--quit'], check=True)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--export-debug', 'Android Debug', str(output)], check=True)
print(output)
