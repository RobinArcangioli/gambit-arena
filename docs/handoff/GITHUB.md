# GitHub, commit de passation et restauration

Aucun compte, nom de dépôt ou URL distante n’a été fourni. Aucun push n’a été effectué par
l’assistant. Le bundle ne contient pas la configuration des remotes du poste utilisateur.
Un origin créé lors d’un clone de bundle pointe vers un fichier local : ce n’est pas GitHub.
Ne pas inventer l’URL ou remplacer un remote existant sans le vérifier.

## 1. Appliquer et commiter HANDOFF-001

Fermer Godot. Base attendue : 665c0c8, main propre. Les sources/configuration sont inchangées,
seuls les documents sont ajoutés/actualisés. Ne pas ouvrir une nouvelle étape fonctionnelle.

```bash
cd ~/gambit-arena &&
git status --short --branch &&
git log -1 --format="%h %s"
```

Après vérification de la base et d’un arbre propre :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-handoff-001.tar.gz -C ~ &&
cd ~/gambit-arena &&
git diff --check &&
git add -- HANDOFF.md README.md ARCHITECTURE.md ROADMAP.md PROJECT_STATUS.md   docs/handoff docs/steps/HANDOFF-001.md docs/backup.md &&
git diff --cached --check &&
git diff --cached --stat
```

Vérifier que seuls les documents prévus sont indexés, puis :

```bash
git commit -m "docs: [HANDOFF-001] documenter la passation et la publication GitHub" &&
git log -1 --format="%H %s" &&
git status --short --branch &&
bash tools/create_backup.sh
```

Cette nouvelle sauvegarde inclura le commit de documentation. Le bundle fourni dans
l’archive de passation s’arrête à STEP-027 et n’inclut pas ce futur commit.

## 2. Préparer le dépôt distant

Créer un dépôt GitHub vide, de préférence privé tant que le choix de licence publique
n’est pas arrêté. Ne pas l’initialiser avec README, .gitignore ou LICENSE : le dépôt local
possède déjà son histoire. Copier son URL HTTPS ou SSH. L’authentification GitHub en ligne
de commande doit être opérationnelle (gestionnaire de credentials, GitHub CLI ou SSH).
Ne pas inclure un token dans l’URL ou le coller dans le chat.

Les fichiers suivis de la base inspectée ne comprennent pas d’APK/AAB, keystore/JKS/PEM,
.env ou export_credentials ; les champs de signature/secrets inspectés du preset sont vides.
C’est un contrôle ciblé, pas un audit exhaustif des secrets de tout l’historique. Sur le poste,
examiner le diff indexé : le .gitignore actuel exclut .godot et /android mais ne couvre pas
arbitrairement tous les fichiers privés. Utiliser les chemins explicites ci-dessus.

## 3. Configurer origin sans écraser une destination existante

```bash
cd ~/gambit-arena &&
git remote -v
```

Si aucun origin n’existe, remplacer l’URL d’exemple par celle du dépôt créé :

```bash
git remote add origin https://github.com/VOTRE_COMPTE/gambit-arena.git &&
git remote -v
```

Si origin existe déjà et pointe vers le bon dépôt, ne pas l’ajouter une seconde fois.
S’il pointe vers un ancien dépôt ou un bundle local, vérifier que vous souhaitez le remplacer,
puis seulement utiliser `git remote set-url origin URL_DU_DEPOT_CHOISI`.
L’URL peut être une URL SSH si la clé est déjà configurée. Aucun changement d’URL n’est automatisé ici.

## 4. Push et vérification

Après vérification de la destination :

```bash
git push -u origin main &&
git fetch origin &&
git rev-parse HEAD &&
git rev-parse origin/main &&
git status --short --branch
```

Les deux hashes doivent être identiques et le statut propre. Le push de main envoie son
historique atteignable ; il n’est pas nécessaire d’utiliser --mirror, --all ou --force.
Ne pas créer de tags ou de release sans demande distincte. Les APK et sauvegardes hors
dépôt ne sont pas envoyés par ce push, ce qui est volontaire.
Si le push est refusé parce que le distant contient déjà des commits, s’arrêter et examiner
le remote avec fetch/log ; ne pas forcer ni réinitialiser l’historique pour contourner le refus.
Transmettre le hash du commit documentaire, le statut, le retour de push et la nouvelle sauvegarde.

## Restaurer sur une nouvelle machine sans GitHub

Extraire l’archive de passation dans un dossier de travail, pas au-dessus d’un autre projet.
Le répertoire gambit-arena contient les sources avec HANDOFF-001, mais aucun .git.
Depuis le dossier contenant le bundle et les sources :

```bash
git clone gambit-arena-history-665c0c8.bundle gambit-arena-restaure &&
git -C gambit-arena-restaure fsck --full &&
git -C gambit-arena-restaure log -1 --format="%H %s"
```

Attendu : 665c0c8d86a6400f88c77773295ed06b1a518206. Copier ensuite les sources de passation
au-dessus du clone, sans toucher à son .git :

```bash
cp -a gambit-arena/. gambit-arena-restaure/ &&
git -C gambit-arena-restaure diff --check &&
git -C gambit-arena-restaure status --short
```

Les différences attendues sont uniquement documentaires. Commit ensuite possible selon la
procédure ci-dessus en adaptant le dossier. Ne pas copier cette archive dans un clone plus
récent après de nouvelles étapes : elle contient les sources exactes STEP-027 et écraserait
les fichiers portant les mêmes noms. Préférer alors le dernier dépôt/sauvegarde vérifié.

## Références

Procédure GitHub consultée le 26 octobre 2026 :
https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github

Gestion des remotes :
https://docs.github.com/en/get-started/git-basics/managing-remote-repositories
