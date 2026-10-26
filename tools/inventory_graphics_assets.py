#!/usr/bin/env python3
"""Inventory the supplied graphical source files without rewriting them."""
import hashlib
import json
import pathlib
import struct

root = pathlib.Path(__file__).resolve().parents[1]

def entry(path):
    data = path.read_bytes()
    row = {'path': str(path.relative_to(root)), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}
    imports = pathlib.Path(str(path) + '.import')
    if imports.exists():
        row['import_sha256'] = hashlib.sha256(imports.read_bytes()).hexdigest()
        row['import_settings'] = [line for line in imports.read_text().split('[params]', 1)[-1].splitlines() if '=' in line]
    if path.suffix == '.png':
        row['width'], row['height'] = struct.unpack('>II', data[16:24])
    if path.suffix == '.glb':
        assert data[:4] == b'glTF'
        size = struct.unpack_from('<I', data, 12)[0]
        document = json.loads(data[20:20 + size])
        row['gltf_asset'] = document.get('asset', {})
        row['animations'] = [animation.get('name') for animation in document.get('animations', [])]
        row['joints'] = [len(skin['joints']) for skin in document.get('skins', [])]
        row['meshes'] = len(document.get('meshes', []))
        row['materials'] = len(document.get('materials', []))
        row['textures'] = len(document.get('textures', []))
        primitives = [primitive for mesh in document.get('meshes', []) for primitive in mesh.get('primitives', [])]
        row['surfaces'] = len(primitives)
        row['vertices'] = sum(document['accessors'][primitive['attributes']['POSITION']]['count'] for primitive in primitives)
        row['triangles'] = sum(document['accessors'][primitive.get('indices', primitive['attributes']['POSITION'])]['count'] // 3 for primitive in primitives if primitive.get('mode', 4) == 4)
    return row

paths = sorted(path for path in (root / 'assets/art').rglob('*') if path.suffix in ['.png', '.glb', '.json'])
report = {
    'schema': 1,
    'godot_import_version': '4.7.2.stable',
    'arenas': {'archive': 'arenes_isometriques_540x960.zip', 'archive_sha256': '950ca806036b9ee425578099e73ff253936d627c05d2e2549eca173876d9d969', 'author': 'not provided', 'license': 'not provided', 'version': 'user supplied 2026-10-26', 'provenance': 'assets/art/arenas/PROVENANCE.md'},
    'models': {'archive': 'Pirate kit-glb.zip', 'archive_sha256': '9e312bdd2c41a9c3ffd76d9716334e3249cfffea1fa13aecda1ef9809385246c', 'author': 'not established by supplied files', 'license': 'not provided', 'version': 'user supplied 2026-10-26', 'provenance': 'assets/art/characters/pirates/PROVENANCE.md'},
    'project_effects': {'heal': 'GRAPHICS-005', 'lightning': 'GRAPHICS-006', 'external_textures': 0, 'source': 'scripts/presentation and shaders/presentation', 'license': 'project code; no third-party license inferred'},
    'files': [entry(path) for path in paths],
}
output = root / 'docs/data/graphics-assets.json'
output.parent.mkdir(parents=True, exist_ok=True)
output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')
print(output, len(paths), 'files')
for row in report['files']:
    if row['path'].endswith('.glb'):
        print(row['path'], row['triangles'], 'triangles,', row['vertices'], 'vertices,', row['surfaces'], 'surfaces')
