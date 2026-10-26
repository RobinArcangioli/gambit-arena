# Qualification graphique — GRAPHICS-007

Le laboratoire `scenes/debug/graphics_qualification_lab.tscn` est une composition de debug
séparée de Main. F6 permet de lancer la matrice et les mesures ou la démonstration des trois
remplacements. F8/F5 revient au vrai jeu. Les règles du laboratoire restent en mémoire ;
les sauvegardes de gambits du propriétaire ne sont pas réécrites.

## Matrice visuelle

Huit arènes x deux variantes de squelette x trois phases = 48 captures sur Galaxy A16.
Anne et Mako sont présents ensemble dans chaque cas. Les phases montrent les attaques,
le soin et Foudre réellement résolus puis la mort du squelette. Les personnages, barres,
clips et effets suivent les mêmes profils et événements que Main. Le squelette A est sans
crâne dans sa source ; ce point déjà accepté reste visible et documenté.

Les captures figent volontairement l'instant de chaque action pour permettre l'inspection.
Elles ne constituent pas une mesure de fluidité. Les PNG natifs sont joints à la livraison
sous verification/android ; l'inspection et les mesures sont consignées ci-dessous.

## Protocole des mesures

Le collecteur borné de STEP-028 est réutilisé, avec sa statistique d'intervalles monotones
entre callbacks `_process`. La fixture est le Main actuel et PartySimulation, avec ses deux
héros, ses sorts et ses vagues ; la vieille fixture historique à un héros n'est pas utilisée
pour attribuer le coût des graphismes actuels. Le plafond d'ennemis est fixé à deux ou six.
Les combats sont cycliques, avec remise à zéro au résultat terminal, afin de garder une
activité réelle et répétable pendant chaque mesure. Les pics incluent ces reconstructions.

Les callbacks de Main sont pilotés à leurs cadences normales : physique moteur à 60 Hz et
processus d'affichage indépendant. Un premier passage diagnostique à un tick par frame
rendue a été exclu, puis la campagne finale a été entièrement relancée avec cette cadence.
Ses résultats ne sont pas mélangés à la campagne finale.

Quatre variantes, avec même UI, caméra et viewport :

- `logic` : logique et HUD, sans décor, modèles ni effets.
- `decor` : ajoute le fond d'arène.
- `models` : ajoute les modèles et tous les clips, avec les effets optionnels désactivés.
- `full` : ajoute le soin et Foudre dans leur version validée.

Chaque variante comporte 5 s de chauffe puis 20 s de capture. Après les huit couples
(effectif/variante), la paire full/models à six ennemis est répétée dans l'ordre inverse.
Le téléphone est branché en USB, avec économie d'énergie désactivée (valeur lue, sans
changement du réglage). Aucune vidéo de l'écran n'est enregistrée pendant les mesures.
Le laboratoire maintient l'écran allumé pendant cette exécution.

La mesure CPU `main_step` englobe le callback physique de Main (simulation, présentation,
HUD et éventuels resets). Le temps de simulation seul n'est pas annoncé séparément.
Le build mesuré est identifié par son SHA ; le panneau du laboratoire livré a ensuite reçu
un fond opaque pour sa lisibilité (un quad UI), sans changer le jeu ni la collecte.
Les draw calls, primitives et mémoires proviennent des moniteurs Godot globaux ; les
ressources artistiques préchargées sont communes aux variantes. Ils ne décrivent pas
uniquement le personnage ou le sort. La télémétrie est échantillonnée une fois par seconde :
un effet très bref peut ne pas apparaître dans ses maxima. Une valeur mémoire nulle d'un
moniteur ne prouve pas l'absence de mémoire GPU utilisée.

## Reproduction Android

`python3 tools/export_graphics_qualification.py --godot /chemin/vers/godot --output /tmp/graphics-007-qualification-debug.apk`
crée une copie temporaire du projet, change uniquement son point d'entrée pour le
laboratoire autorun et exporte le code Android 38. Les sources et le Main du projet ne
sont pas modifiés. Installer cet APK avec `adb install -r`, lancer et laisser le téléphone
au premier plan environ cinq minutes. Le rapport est `user://graphics007/report.json`.
Une mise en arrière-plan interrompt la campagne ; le rapport le signale explicitement.
Récupérer le dossier avec ADB/run-as de l'APK Debug, puis exécuter :

`python3 tools/summarize_graphics_qualification.py report.json --output summary.json`

L'outil vérifie les 48 cas, les dix captures complètes et le nettoyage des effets avant
la synthèse. Après la qualification, réinstaller l'APK normal GRAPHICS-007 (code 39) ;
il démarre Main, conserve les données et n'exécute pas le laboratoire automatiquement.

## Résultats matériels — Galaxy A16

Galaxy SM-A165F / Android 16, Mali-G57 MC2, renderer Compatibility, viewport 3D
`(516, 540)`. APK mesuré : `0.1.0-graphics007-qualification` (38), SHA-256
`9fa1e8e10369d3397c4bfed873268553004eb84a54598b4d55db41a0af96441a`.
Dix captures complètes, aucune interruption. Rapport brut joint dans la livraison, SHA-256
`5d2b538c05e3a35d5e1c012f7557f358fb654487d648e3c56485c33ccfeaee23` ; synthèse versionnée :
[data/graphics007-galaxy-summary.json](data/graphics007-galaxy-summary.json).

| Ennemis | Variante | Cadence moyenne | Frame p95 ms | CPU Main moyen / p95 ms | Draw calls médiane / max |
|---:|---|---:|---:|---:|---:|
| 2 | logic | 90.0 | 15.90 | 2.15 / 2.85 | 32 / 32 |
| 2 | decor | 90.0 | 15.96 | 2.14 / 2.85 | 33 / 33 |
| 2 | models | 90.0 | 15.64 | 3.84 / 4.77 | 41 / 43 |
| 2 | full | 89.7 | 15.75 | 3.77 / 4.70 | 43 / 54 |
| 6 | logic | 90.0 | 16.75 | 3.29 / 4.14 | 32 / 32 |
| 6 | decor | 90.0 | 16.24 | 3.23 / 3.94 | 33 / 33 |
| 6 | models | 88.6 | 17.19 | 4.89 / 6.80 | 49 / 51 |
| 6 | full | 88.1 | 17.55 | 4.99 / 6.98 | 51 / 62 |
| 6 | full (bis) | 89.2 | 17.38 | 4.66 / 6.73 | 50 / 62 |
| 6 | models (bis) | 89.3 | 17.44 | 5.01 / 6.80 | 49 / 51 |

La cadence observée est proche du plafond de rafraîchissement de 90 Hz. Ce plafond masque
la réserve de rendu : ces moyennes ne mesurent ni le temps GPU ni la présentation effective
de chaque image. À six ennemis, le CPU moyen passe d'environ 3,23 ms avec décor à 4,89 ms
avec modèles ; les effets ajoutent quelques appels de dessin et leur coût CPU est faible
face aux variations entre passages. Le passage inverse ne justifie pas une attribution
plus précise ni l'affirmation qu'un effet serait gratuit.

Les pointes sont importantes : à six ennemis, CPU maximal 109–121 ms et intervalle maximal
123–137 ms. Elles incluent la reconstruction périodique du fixture et sa réapplication des
profils de vue, avec création des rigs ; elles ne décrivent pas un coût continu du sort.
Conserver cette réserve et vérifier Rejouer dans la recette réelle. Le CPU p95 reste
6,73–6,98 ms pour les variantes complètes à six ennemis. Pas de nouveau seuil FPS imposé.

Les compteurs globaux échantillonnés culminent vers 38 248 primitives, 62 draw calls,
59,83 MiB de mémoire vidéo et 45,47 MiB de textures. Ils couvrent le HUD et les ressources
préchargées/visitées lors de la matrice. Ils ne remplacent pas le budget source avant LOD.
Le GPU ne rapporte pas de changement de texture important avec les effets procéduraux.

Après chaque capture : aucun effet de soin, préparation ou frappe restant, et zéro nœud
orphelin. Le nombre de nœuds après nettoyage revient à 184 dans tous les cas avec modèles.
La mémoire statique des nettoyages répétés progresse d'environ 132 KiB par rapport retenu
(environ 0,13 MiB entre les deux passages full/6), avec les dix rapports et leurs tableaux
conservés par le collecteur. Cette croissance est bornée par le nombre de captures ; elle
ne démontre pas une fuite de vues. Le pic statique final observé est d'environ 77,38 MiB.
La vérification des orphelins et les traces ne constituent pas une étude de fuite sur des heures.

L'économie d'énergie est restée désactivée. Batterie lue à 97 %, 28,4 °C avant le premier
passage diagnostique, puis 100 %, 29,2 °C à la fin de la campagne finale, en USB. Ce ne sont
pas des températures contrôlées constantes. Aucun réglage d'énergie n'a été modifié.

## Inspection visuelle et réserves

Les 48 captures natives ont été inspectées via quatre planches de contact, jointes à la
livraison avec les PNG originaux. Les huit calages restent cohérents, les barres sont
lisibles, les deux héros et les deux squelettes gardent leurs clips. Foudre et son glow
restent visibles sur les fonds sombres et clairs. Le halo vert de soin est plus discret
sur les thèmes verts/clairs ; le montant +30 et la remontée des PV le complètent.
Le squelette A reste sans tête dans le modèle source, comme déjà accepté.

Les trois remplacements sont démontrés sur PC, avec comparaison des valeurs de jeu et
600 ticks par composition. Voir graphics-replacement-recipes.md. Les sources et limites de
provenance sont détaillées dans graphics-assets-and-budgets.md. Les auteurs/licences des
fonds et du Pirate Kit restent à préciser avant diffusion publique des assets fournis.

Les budgets sont fixés pour ce contenu et ces effectifs. L'ancienne fixture à vingt ennemis
reste informative et n'a pas été refaite : elle ne correspond pas au périmètre demandé.
L'étape reste en recette utilisateur ; STEP-029 et STEP-030 ne sont pas exécutées ici.
