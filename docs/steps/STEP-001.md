# STEP-001 — Socle Godot et Git

## Identification

- Phase : 1 — Initialisation.
- Statut : En cours — documentation à relire.
- Dépendances : roadmap validée et démarrage autorisé.
- Version retenue : Godot 4.7.2 standard.
- Complexité : faible.

## Objectif et périmètre

Créer un projet minimal ouvrable sous Linux, une scène principale
lançable et un dépôt Git local avec documentation.

Exclus : gameplay, scripts, portrait Android, SDK/JDK et export APK.

## Décisions techniques

- Projet nommé Gambit Arena.
- Dossier local : /home/arkhane/gambit-arena.
- Scène Node2D minimale, sans script.
- Rendu Compatibility conformément à la roadmap.
- Branche main.
- Git utilisé depuis le terminal, sans plugin Godot.
- Cache .godot/ exclu ; fichiers source et réglages d'import conservés.

## Fichiers

- project.godot : configuration et scène principale par UID.
- scenes/main.tscn : racine Main de type Node2D.
- icon.svg et icon.svg.import : icône et réglages d'import.
- .gitignore, .gitattributes, .editorconfig : fichiers initiaux.
- README.md : ouverture, lancement et état des prérequis.
- ROADMAP.md : registre des étapes et règles de suivi.
- ARCHITECTURE.md : structure réellement livrée.
- PROJECT_STATUS.md : reprise du travail.
- docs/steps/STEP-001.md : présente fiche.

## Mise en place effectuée par l'utilisateur

1. Création du projet dans Godot.
2. Création de Main et enregistrement sous scenes/main.tscn.
3. Sélection de la scène principale au premier F5.
4. Initialisation Git ; branche main confirmée.
5. Inspection des fichiers et de l'exclusion .godot/.
6. Correction du rendu initial Forward Plus vers Compatibility.
7. Correction de config/features vers GL Compatibility.
8. Nouveau lancement confirmé sans erreur.

## Comportement et limites

F5 affiche une vue vide : résultat attendu d'une scène sans élément visuel.
F8 arrête l'exécution. Aucun comportement de jeu n'existe.

Les réglages portrait, la résolution et le déploiement Android restent
à établir dans leurs étapes respectives.

## Vérifications techniques

Observées dans les sorties transmises :

- Git reconnaît le dépôt.
- La branche est main.
- L'UID de la scène correspond à run/main_scene.
- Les deux méthodes de rendu sont gl_compatibility.
- git check-ignore .godot/ retourne .godot/.

Rapportées par l'utilisateur :

- Deux lancements, dont un après réouverture, sans erreur.
- Correction finale du rendu et lancement réussis.

Non exécutées :

- Test automatisé ou import en ligne de commande.
- Export Android et test sur téléphone.
- Vérification depuis un clone propre.
- Commit Git et contrôle de son contenu final.

## Recette manuelle

Précondition : ouvrir le projet avec Godot 4.7.2.

1. Vérifier Compatibility dans l'éditeur.
2. Appuyer sur F5.
3. Attendre l'affichage de la vue vide.
4. Vérifier l'absence d'erreur dans le débogueur.
5. Arrêter avec F8.
6. Fermer et rouvrir le projet, puis relancer.

Résultats utilisateur :
- Ouverture et réouverture : réussies.
- Lancement final sous Compatibility : réussi.

## Critères d'acceptation

- [x] Version de Godot identifiée par l'utilisateur.
- [x] Scène principale enregistrée et lançable.
- [x] Réouverture suivie d'un lancement réussi.
- [x] Rendu Compatibility confirmé par l'utilisateur.
- [x] Branche main observée.
- [x] Cache Godot exclu.
- [ ] Documentation relue et conforme au projet.
- [ ] Contenu du premier commit vérifié.
- [ ] Validation explicite de l'étape complète reçue.

## Traçabilité

Message prévu :
chore: [STEP-001] initialiser le socle Godot et la documentation

Commit : non créé / non confirmé.
Aucun hash n'est attribué à l'avance.

Problème rencontré : rendu Forward Plus à la création.
Correction : passage à Compatibility et métadonnée alignée.
Aucun autre problème signalé.

Action suivante : vérifier les documents et les fichiers à versionner,
puis demander la validation de l'étape complète.
Contenu du premier commit vérifié
