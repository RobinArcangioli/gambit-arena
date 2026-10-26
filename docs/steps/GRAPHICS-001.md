# GRAPHICS-001 — Première arène interchangeable

GO reçu après validation de la roadmap graphique. Base : STEP-028, commit
`580ce641390f30667133cec0a580ee3d64f0c51a`. Étape validée par le propriétaire :
« Ok step validée. Go next. » Validation globale, sans détail supplémentaire attribué aux tests.
Le GO suivant autorise GRAPHICS-002 après le checkpoint et la sauvegarde de cette étape.

## Livrable

- Resource de présentation, contrat ArenaView et deux scènes : référence procédurale et
  Colisée solaire fourni par le propriétaire. Changer la ressource suffit à remplacer le fond.
- Façade ArenaFloor compatible avec les anciens labs ; overlay logique indépendant.
- Main choisit le Colisée. Les scènes historiques utilisent la référence par défaut.
- Galerie F6 indépendante du combat avec sélection des deux fonds, repères logiques,
  grille fournie et cinq positions de mannequins.
- Calage à échelle uniforme et recadrage ; caméra, limites et règles inchangées. Voir
  [arena-presentation.md](../arena-presentation.md) pour les repères et la différence de pente.
- Nouvel APK Debug `graphics-001-debug.apk`, version `0.1.0-graphics001`, code 29.

SHA-256 de l'APK exporté et installé :
`2b04193bde71b223471ba46486f0ee6e277202c147b8fc01593b11449f500180`.
L'empreinte du `base.apk` installé a été relue via ADB et comparée au fichier local.

Cette étape isole les arènes. Les acteurs restent les mannequins existants ; leur séparation
complète et les animations sont les étapes GRAPHICS-003 à GRAPHICS-006. Les sept autres fonds
restent dans l'archive source fournie, avant leur intégration dans GRAPHICS-002.

## Vérifications réalisées

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility, sur le poste Ubuntu existant.
Les 26 bancs ont été exécutés en headless : 1 649 contrôles, zéro échec, aucun avertissement
ou erreur Godot relevé dans les logs de cette campagne. Le nouveau banc apporte 23 contrôles,
dont 900 ticks comparés sur trois configurations du fond. Le harnais temporaire n'est pas
un runner global livré dans le projet.

Vérification en fenêtre X11/AMD Mesa : sept contrôles supplémentaires via viewport réel,
zéro échec. Clics des sélecteurs, superposition des grilles, Main sur Colisée, pause et
viewport court. Captures galerie, référence, calibration, Main et petit viewport inspectées.
Les messages du pilote NVIDIA indisponible au démarrage précèdent l'utilisation effective
du pilote AMD ; ils ne sont pas des avertissements GDScript.

Export Debug signé avec templates 4.7.2. Une première tentative dans le bac à sable a signalé
les accès ADB/paramètres éditeur restreints ; l'export a été relancé avec les accès requis.
Le projet conserve le même `project.godot`, UID de Main, code des exécuteurs, simulation,
déplacement, ciblage et garde Android. Aucun gain de performance n'est revendiqué ici.

Installation effective sur Galaxy A16 SM-A165F Android 16 ; lancement par l'activité publique
`com.godot.game.GodotAppLauncher`. Capture réelle après chargement : Colisée et quatre acteurs
en situation de combat, HUD séparé du fond. Mali-G57 MC2 / Compatibility, écran 1080 × 2340.
L'écran était éveillé et `low_power=0` à la lecture ; aucun réglage système n'a été modifié
pour cet essai. Ce contrôle d'affichage n'est pas une campagne de performance ni une recette
tactile/cycle de vie utilisateur complète. La toute première capture au démarrage était noire
avant le chargement ; la capture une fois le jeu chargé est conservée comme preuve utile.

## Recette utilisateur

1. F6 : `arena_presentation_tests`, puis les régressions ciblage, immobilité, exécuteur,
   tactile, cycle de vie et performance ; F8 entre scènes. Attendu OK sans nouveau warning.
2. F6 : `scenes/debug/graphics_lab.tscn`. Alterner Reference/Colisee, afficher les deux
   grilles, parcourir les cinq placements. Valider le cadrage et les pieds sans exiger que
   les lignes décoratives correspondent aux unités logiques.
3. F5 : jouer sur Colisée ; vérifier trois vagues, compétences, gambits, pause et Rejouer.
4. Sur Android : vérifier fond dans sa zone, pas d'image sur le HUD, swipe/appui court,
   pause, Accueil/verrouillage et reprise explicite. Valider particulièrement la lisibilité
   du terrain et le recadrage haut/bas.

Après validation : consigner le retour, produire la livraison de validation, puis commit et
sauvegarde vérifiée avant GRAPHICS-002.
