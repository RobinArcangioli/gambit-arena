#!/usr/bin/env bash
# Rebuild small catalogue thumbnails from the current grid-free arena PNG files.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p assets/art/arenas/previews
for arena_id in colisee_solaire sanctuaire_polaire forteresse_volcanique temple_sylvestre arcane_bleu_sombre chaos_vert_toxique lumiere_angelique pirates_fantomes ville_alexandrie ombres_beherit; do
    convert "assets/art/arenas/$arena_id/$arena_id.png" -resize 108x192 \
        "assets/art/arenas/previews/$arena_id.png"
done
