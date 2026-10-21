# STEP-002 — Préparer la chaîne Android sous Linux

## Identification

- Phase : 1 — Initialisation.
- Statut : Validée, commit en attente.
- Dépendance : STEP-001, commit 6583515.
- Godot : 4.7.2 standard.
- Complexité : moyenne.
- Validation utilisateur : reçue le 21 octobre 2026, « Step validée. ».

## Objectif et périmètre

Préparer les outils Android, les templates, la connexion USB et le preset
portrait. Aucun gameplay ni APK livré dans cette étape.

## Décisions techniques

- Réutiliser Android Studio et le SDK utilisateur existants.
- Ajouter les versions documentées sans supprimer les anciennes.
- Conserver JDK 21, accepté selon la documentation mais non encore vérifié
  par un export réel dans cet environnement.
- Templates APK standards, sans Gradle personnalisé ; cible ARM64.
- Référence portrait initiale 540 × 960.
- Import ETC2/ASTC activé à la demande de Godot pendant la préparation.

## Fichiers

- project.godot : résolution, orientation, import ETC2/ASTC.
- export_presets.cfg : nouveau preset Android Debug.
- docs/android.md : versions, préparation, USB et limites.
- README.md : accès à la procédure Android.
- ARCHITECTURE.md : configuration réelle.
- ROADMAP.md : statut courant et clôture de STEP-001.
- PROJECT_STATUS.md : reprise du travail.
- docs/steps/STEP-002.md : présente fiche.

Les SDK, templates, clés de signature et paramètres locaux de l'éditeur
ne sont pas des fichiers source à ajouter au dépôt.

## Mise en place et comportement

Voir [la procédure Android](../android.md) pour les composants,
chemins et manipulations exactes.
La scène principale reste un Node2D vide. Aucun gameplay n'est ajouté.
Les deux chemins SDK/JDK sont renseignés ; ADB est passé de unauthorized
à device. Le preset est créé, sans génération d'APK.

## Vérifications techniques

Sorties transmises par l'utilisateur :

- Commit de départ 6583515 et branche main propre avant modifications.
- Inventaire SDK contenant les composants demandés.
- ADB : device ; modèle SM-A165F ; Android 16.
- Diff du projet conforme aux réglages portrait.
- Extrait du preset : ARM64, signature, paquet et version conformes.
- git diff --check silencieux avant cette livraison de validation.
- Diff --stat : quatre documents racine et project.godot modifiés.

Confirmations utilisateur : templates installés, chemins renseignés,
lancement F5 et arrêt F8 réussis sous Linux.

Non exécuté : export APK, installation, lancement Android, clone propre.
Aucun résultat UI distinct transmis pour Runnable et les messages du preset ;
la validation globale utilisateur est consignée sans inventer ce résultat.
L'assistant n'a pas exécuté les tests sur le poste de développement.

## Recette manuelle reproductible

1. Ouvrir le gestionnaire Godot : vérifier les templates installés.
2. Ouvrir le preset Android Debug : contrôler les valeurs documentées,
   Runnable / Exécutable et les éventuels messages de validation.
3. Brancher le téléphone autorisé : vérifier device avec ADB.
4. Lire modèle et version Android avec les commandes de docs/android.md.
5. Lancer puis arrêter sous Linux avec F5 et F8.
6. Relire les documents et vérifier le diff Git.

Résultats effectivement reçus : voir la section précédente.
La dernière vérification Git après application reste à exécuter avant commit.

## Acceptation et limites

- [x] Prérequis installés et versions relevées.
- [x] Templates installés selon le gestionnaire Godot.
- [x] Chemins SDK/JDK renseignés.
- [x] Téléphone détecté et autorisé.
- [x] Configuration portrait et preset créés.
- [x] Lancement Linux sans régression signalée.
- [x] Mise à jour des quatre documents appliquée ; contrôle Git transmis.
- [x] Validation explicite de STEP-002 reçue.

Réserves documentées : export et signature non testés ; contrôle UI du
preset sans résultat détaillé distinct ; annexe détaillée de ROADMAP.md
vide dans le fichier reçu, registre des 30 étapes conservé.

Problèmes rencontrés : autorisation USB initialement absente (résolue),
activation ETC2/ASTC nécessaire, téléchargement Android CLI pendant l'inventaire.
Aucun autre problème signalé.

## Traçabilité

Message autorisé :
`build: [STEP-002] configurer la chaine export Android`

Commit : non encore créé ou confirmé. Aucun hash anticipé.
Dernier commit antérieur connu : 6583515 (STEP-001).

Prochaine action : appliquer la livraison, inspecter les fichiers préparés,
créer le commit puis vérifier son hash et l'état du dépôt.
Ne pas commencer STEP-003 sans clôture Git et feu vert explicite.
