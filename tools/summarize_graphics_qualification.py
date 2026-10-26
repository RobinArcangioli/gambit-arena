#!/usr/bin/env python3
"""Validate a complete Galaxy qualification report and write a compact JSON summary."""
import argparse
import hashlib
import json
import pathlib
import statistics

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('report', type=pathlib.Path)
parser.add_argument('--output', type=pathlib.Path, required=True)
args = parser.parse_args()
raw = args.report.read_bytes()
data = json.loads(raw)
assert not data['interrupted'], 'Interrupted campaign'
assert len(data['matrix']) == 48, 'Expected eight arenas x two skeletons x three phases'
assert len({(row['arena'], row['skeleton'], row['action']) for row in data['matrix']}) == 48
assert len(data['captures']) == 10, 'Expected eight variants plus a reverse repeated pair'
rows = []
for report in data['captures']:
    assert report['phase'] == 'complete', report.get('reason')
    metadata = report['metadata']
    assert metadata['physics_input'].startswith('normal engine physics'), 'Initial diagnostic cadence must not be mixed with the final campaign'
    summary = report['summary']
    telemetry = report['raw']['telemetry']
    assert telemetry, 'Missing telemetry'
    def peak(name):
        return max(sample.get(name, 0) for sample in telemetry)
    def median(name):
        return statistics.median(sample.get(name, 0) for sample in telemetry)
    row = {'pass': metadata['pass'], 'variant': metadata['variant'], 'enemy_fixture': metadata['enemy_fixture'],
           'viewport': metadata['viewport'], 'fps': summary['mean_fps'], 'frame_p95_ms': summary['frame_interval']['p95_ms'],
           'frame_p99_ms': summary['frame_interval']['p99_ms'], 'frame_max_ms': summary['frame_interval']['max_ms'],
           'main_step_mean_ms': summary['main_step_cpu']['mean_ms'], 'main_step_p95_ms': summary['main_step_cpu']['p95_ms'],
           'main_step_max_ms': summary['main_step_cpu']['max_ms'], 'wall_seconds': summary['wall_seconds'],
           'game_seconds': summary['game_seconds'], 'draw_calls_median': median('draw_calls'), 'draw_calls_peak': peak('draw_calls'),
           'primitives_peak': peak('primitives'), 'static_peak_bytes': peak('static_bytes'), 'video_peak_bytes': peak('video_bytes'),
           'texture_peak_bytes': peak('texture_bytes'), 'nodes_peak': peak('nodes'),
           'sampled_heals_peak': peak('heal_effects'), 'sampled_preparations_peak': peak('lightning_preparations'),
           'sampled_strikes_peak': peak('lightning_strikes'), 'cleanup': report['cleanup']}
    assert row['cleanup']['heal_effects'] == row['cleanup']['lightning_preparations'] == row['cleanup']['lightning_strikes'] == 0
    assert row['cleanup']['orphans'] == 0
    rows.append(row)
result = {'schema': 1, 'raw_report_sha256': hashlib.sha256(raw).hexdigest(), 'matrix_cases': 48,
          'capture_count': 10, 'method': data['captures'][0]['metadata'], 'rows': rows}
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
print('| Ennemis | Variante | FPS moyens | Frame p95 ms | CPU tick moyen / p95 ms | Draw calls median/max |')
print('|---:|---|---:|---:|---:|---:|')
for row in rows:
    print(f"| {row['enemy_fixture']} | {row['variant']} | {row['fps']:.1f} | {row['frame_p95_ms']:.2f} | {row['main_step_mean_ms']:.2f} / {row['main_step_p95_ms']:.2f} | {row['draw_calls_median']:.0f}/{row['draw_calls_peak']:.0f} |")
print('raw sha256', result['raw_report_sha256'])
