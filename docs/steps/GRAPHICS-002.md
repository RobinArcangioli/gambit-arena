# GRAPHICS-002 — Catalogue des huit arènes

GO reçu avec validation de GRAPHICS-001. Base : `f5a790d38ed12cd3ccc3bac85162308986a5f894`,
commit local de GRAPHICS-001, après sauvegarde restaurée et comparée (354 fichiers).
La validation de la première étape est globale : « Ok step validée. Go next. »

## Livrable validé

Validation explicite du propriétaire reçue le 26 octobre 2026 : « Step validée. J'attends
ton commit et je te donnerai des modèles 3D à exploiter pour les personnages/ennemis. »
Retour global, sans ajouter de détail par banc ou de mesure non communiqué. La clôture
consiste à commiter cette version puis vérifier sa sauvegarde. GRAPHICS-003 attend les
modèles annoncés avant toute intégration.

Les sept fonds restants rejoignent le Colisée : Sanctuaire polaire, Forteresse volcanique,
Temple sylvestre, Arcane bleu sombre, Chaos vert toxique, Lumière angélique et Pirates fantômes.
Chaque fond est une scène de présentation et une Resource distincte, avec le même calage
uniforme et la même caméra validés dans GRAPHICS-001. Sources PNG inchangées ; inventaire
et empreintes dans `assets/art/arenas/PROVENANCE.md`.

Catalogue d'identifiants stables, huit petites vignettes et repli vers le terrain de référence.
Sélecteur commun à Main (**GAMBIT / Mesures → Choisir l'arène**) et à la galerie F6
(`scenes/debug/graphics_lab.tscn`, bouton Arènes...). Terrain de référence disponible en plus
des huit décors. Liste tactile défilante et bouton de fermeture toujours accessible.

Ouvrir, choisir ou fermer conserve la pause ; la reprise reste explicite. Changer le fond
ne recrée pas les acteurs et ne change ni leurs états ni les gambits. Rejouer conserve le fond
choisi dans cette session. Le lancement suivant utilise toujours le profil Colisée de Main.
Pas de persistance ni changement des zones jouables, collisions, vagues, coûts ou compétences.

## Vérifications exécutées

- Godot/templates 4.7.2.stable.official.ed1daf0bf, Compatibility, poste Ubuntu existant.
- 27 bancs headless : 1 728 contrôles, zéro échec ; aucun warning/erreur Godot dans la campagne.
  Le nouveau banc `arena_catalog_tests` ajoute 79 contrôles : ressources, petites vignettes,
  calage de chaque fond sur deux viewports, snapshot du combat conservé, swipe depuis image,
  dernier bouton atteignable, appui/copie souris, arrière-plan et ancien relâchement, reprise,
  36 changements de fond, Rejouer, destruction sans objets de construction orphelins.
- 14 contrôles en fenêtre X11/AMD : vrais clics de menu, chaque carte, fermeture, galerie,
  petit viewport. Zéro échec. Captures des huit fonds et du sélecteur inspectées.
- Après chauffe par un tour des neuf profils, puis trois tours complets supplémentaires :
  163 nœuds, 61 ressources et zéro orphelin à chaque relevé ; mémoire statique de
  77 576 234 à 77 572 762 octets (échantillons de bureau, pas un benchmark Android).
  Ces relevés ne prouvent pas l'absence de toute fuite sur des sessions arbitraires.
- `project.godot`, règles de combat, exécuteurs, déplacement, ciblage, garde Android et
  script de calage du fond identiques à GRAPHICS-001 ; intégration UI par une couche dérivée.

Les harnais de campagne et de capture sont temporaires et fournis dans les preuves ; ils ne
remplacent pas une recette utilisateur. Les modèles 3D et leurs actions restent les étapes
GRAPHICS-003 à GRAPHICS-006.

## APK

Debug signé, arm64, paquet `org.gambitarena.prototype`, version `0.1.0-graphics002`, code 30.
Fichier `graphics-002-debug.apk`, SHA-256 :
`8a543ae236b227e7c3fc74131fcdac3ce6c3a54f73a6b8a9c8370bde4ed880f5`.

APK installé sur Galaxy A16 SM-A165F Android 16 ; empreinte du `base.apk` relue sur l'appareil
et identique. Lancement par `com.godot.game.GodotAppLauncher`. Les huit décors ont été choisis
par les cartes tactiles ADB, avec captures en 1080 × 2340 et défilement jusqu'aux derniers
profils. Les captures ont été inspectées : décor dans la zone d'arène, personnages visibles,
HUD séparé, pause conservée. Les barres système ont brièvement été visibles sur une capture,
avec adaptation du cadre utile par le layout existant. Aucun réglage système modifié.
Ce contrôle d'affichage et de sélection ne remplace pas la recette manuelle ni une mesure
de fluidité matérielle ; aucune nouvelle conformité FPS n'est revendiquée.

## Recette utilisateur

1. F6 : `arena_catalog_tests`, `arena_presentation_tests`, puis régressions tactile,
   cycle de vie, ciblage, immobilité et compétences ; F8 entre scènes.
2. F6 galerie : parcourir les neuf profils, les cinq placements et les repères ; valider
   le calage et la lisibilité de chaque illustration, en particulier les fonds sombres/clairs.
3. F5/Android : lancer une partie, ouvrir Choisir l'arène, faire un swipe depuis une vignette,
   choisir un autre fond puis Reprendre. Vérifier conservation PV/énergie/cibles et partie.
4. Menu : fermer sans choisir, Accueil/verrouillage pendant un appui ou swipe, retour en
   pause, ancien relâchement sans effet et nouveau geste fonctionnel. Atteindre la référence
   en bas de la liste et vérifier le bouton Fermer en petit viewport.
5. Rejouer conserve l'arène ; relancer l'application retrouve Colisée. Vérifier le HUD
   intact, sans décor sur les boutons, et les huit fonds sur le Galaxy A16.

GRAPHICS-002 est validée par le propriétaire. Les modèles de personnages et ennemis restent
à recevoir avant GRAPHICS-003.
