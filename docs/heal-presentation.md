# GRAPHICS-009 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le soin vert fluo à deux anneaux tournants.
APK normal 0.1.0-graphics009 (43), SHA-256
`fc84f63d53b40a9246b3d7466a32833026545ef8c4968b668fbe16881be16fc9`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 41 bancs / 2 574 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette suivantes retracent les états historiques.

# Effet de soin — GRAPHICS-009

Le geste Duck existant suit toujours l'incantation de 1,5 s. L'effet de réussite apparaît
uniquement sur `resolve`, `skill=heal`, `healing>0`, après le soin réel. Le nombre flottant
indique la valeur effectivement rendue. Engagement, annulation, PV pleins, cible morte ou
hors de portée ne produisent pas de réussite. CombatPresenter et ces règles sont inchangés.

## Apparence et temps

Deux anneaux blanc/vert clair translucides entourent le corps de la cible, avec un glow
vert fluo. Leurs rayons sont différents et leurs centres sont identiques, à 0,72 unité
au-dessus de l'origine de l'effet. Leurs plans tournent sur deux axes non colinéaires,
en sens opposés ; une simple rotation invisible dans le plan du cercle ne suffirait pas.
Les deux centres restent fixes dans l'effet : les anneaux ne gravitent pas autour de points
séparés. L'ensemble suit la cible vivante via les instantanés du présentateur existant.

Durée totale : 1,0 s. Apparition douce sur 0,06 s, puis fondu de 0,36 à 1,0 s. Les anneaux,
le glow, la valeur numérique et son contour sont entièrement transparents à la fin.
La courte montée du nombre ne déplace pas les centres des anneaux. Les quatre anciens
signes « + » sont retirés pour laisser lire les cercles.

Le temps reste fourni par `advance_visual(dt)` : aucun Tween, timer autonome ou TIME shader.
Pause, menus, arrière-plan et rejet du premier tick de retour conservent leur comportement.
Mort de la cible, Rejouer et désactivation du présentateur nettoient immédiatement l'effet.
Maximum huit effets simultanés, avec éviction du plus ancien. Pas de référence à une cible
logique dans l'effet et aucune écriture de PV, mana, portée, ciblage ou déplacement.

## Style remplaçable

`resources/presentation/effects/heal.tres` et HealEffectDefinition portent la scène, la durée,
le vert du glow, les deux couleurs/opacités de cœur, le rayon extérieur (0,62), le rapport
intérieur (0,72), la hauteur commune (0,72), les axes et les nombres de tours (1,1 / -1,35).
La hauteur du nombre reste 1,55. CharacterDefinition.heal_effect_origin reste le décalage
par modèle, transmis par le présentateur. Ces tailles sont purement décoratives et ne
changent pas le diamètre physique de 0,70 ni les disques d'ombre validés dans GRAPHICS-008.

Le contrat de scène reste `setup(profile, healed)` puis `advance_visual(dt)`. Remplacer la
scène ou modifier le profil change le graphisme sans changer les règles du soin.

## Rendu Compatibility

Deux TorusMesh de cœur, deux coques de glow adouci, un QuadMesh de lueur orienté vers la
caméra et un Label3D. Chaque tore utilise 64 × 8 segments. Le shader de glow est additif,
non éclairé, sans écriture de profondeur ; l'occlusion par les personnages reste active.
Le glow est composé localement pour fonctionner en Compatibility sur Android ; il ne
requiert pas d'activer un bloom global. Aucune lumière dynamique, texture, particule ni
asset externe. Les axes sont déterministes, sans RNG et indépendants du framerate.

## Recette

F6 : `scenes/debug/heal_lab.tscn`, bouton « Soin (demo) » : Duck puis effet exemple +30 sur
Anne, sans modifier de PV/mana. F8 puis F5 pour le combat réel. Anne peut soigner Mako ou
elle-même ; manuel et gambit utilisent le même effet sur la cible réellement soignée.
Vérifier les deux rotations, le glow et le fondu complet, puis pause/reprise et Rejouer.
Le soin conserve coût 20, cooldown 4 s, montant 30, portée 4 et incantation 1,5 s.
Voir steps/GRAPHICS-009.md pour les résultats, l'APK et les limites des captures.
