#!/usr/bin/env bash
# Run explicitly with bash after a successful commit; no background task.
set -euo pipefail
project_root=$(git rev-parse --show-toplevel)
cd "$project_root"
git rev-parse --verify HEAD >/dev/null
if [ -n "$(git status --porcelain --untracked-files=all)" ]; then
    printf '%s\n' 'Sauvegarde interrompue : commiter les changements et fichiers non suivis avant de continuer.' >&2
    exit 1
fi
backup_commit=$(git rev-parse HEAD)
backup_short=$(git rev-parse --short=12 HEAD)
backup_root="${1:-$HOME/gambit-arena-backups}"
mkdir -p "$backup_root"
backup_stamp=$(date +%Y%m%d-%H%M%S)
backup_path="$backup_root/gambit-arena-${backup_stamp}-${backup_short}.tar.gz"
if [ -e "$backup_path" ]; then
    printf '%s\n' 'Une sauvegarde portant ce nom existe déjà ; relancer dans une seconde.' >&2
    exit 1
fi
backup_tmp=$(mktemp -d "$backup_root/.prepare-XXXXXXXX")
trap 'rm -rf -- "$backup_tmp"' EXIT
mkdir "$backup_tmp/gambit-arena"
git archive HEAD | tar -xf - -C "$backup_tmp/gambit-arena"
git bundle create "$backup_tmp/history.bundle" --all
git bundle verify "$backup_tmp/history.bundle"
{
    printf 'Projet : Gambit Arena\nCommit : %s\nDate : %s\n' "$backup_commit" "$backup_stamp"
    printf 'Sources : gambit-arena/ ; historique : history.bundle\n'
    printf 'Restauration : git clone history.bundle gambit-arena-restaure\n'
    printf 'Verifier le commit et git status avant ouverture dans Godot.\n'
} > "$backup_tmp/BACKUP_INFO.txt"
tar -czf "$backup_tmp/complete.tar.gz" -C "$backup_tmp" gambit-arena history.bundle BACKUP_INFO.txt
# Hard link publishes atomically and refuses to overwrite an existing archive.
ln "$backup_tmp/complete.tar.gz" "$backup_path"
printf 'Sauvegarde creee : %s\n' "$backup_path"
