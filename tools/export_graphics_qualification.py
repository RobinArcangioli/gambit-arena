#!/usr/bin/env python3
"""Build the diagnostic Android entry point in a temporary copy, preserving Main."""
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
with tempfile.TemporaryDirectory(prefix='gambit-graphics007-export-') as name:
    project = pathlib.Path(name) / 'project'
    shutil.copytree(source, project, ignore=shutil.ignore_patterns('.git', '.godot', '.agents', '.codex', '.aws', '__pycache__'))
    config = project / 'project.godot'
    text = re.sub(r'^run/main_scene="[^"]*"$', 'run/main_scene="res://scenes/debug/graphics_qualification_autorun.tscn"', config.read_text(), flags=re.MULTILINE)
    config.write_text(text)
    preset = project / 'export_presets.cfg'
    text = re.sub(r'^version/code=\d+$', 'version/code=38', preset.read_text(), flags=re.MULTILINE)
    text = re.sub(r'^version/name="[^"]*"$', 'version/name="0.1.0-graphics007-qualification"', text, flags=re.MULTILINE)
    preset.write_text(text)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--editor', '--import', '--quit'], check=True)
    subprocess.run([args.godot, '--headless', '--path', str(project), '--export-debug', 'Android Debug', str(output)], check=True)
print(output)
