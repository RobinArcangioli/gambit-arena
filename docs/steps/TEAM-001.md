# TEAM-001 — Nassau, Booster et composition à quatre places

Statut : validée sur Galaxy A16 le 30 octobre 2026 : « Oui, étape validée ».
Base : MATERIALS-001, 7493296cce1f589096012ff6ad5e761497638a1a.

## Héros et présentation

Nassau : 160 PV, 60 PM, attaque 14, défense 4, vitesse 1,2, régénération 5 PM/s.
Compétences : Attaque et Booster. Mako garde Attaque/Foudre et Anne Attaque/Soin.
Le GLB Pirate Captain et le PNG Nassau fournis sont copiés à l’identique ; provenance
et SHA sous assets/art/characters/pirates/nassau-provenance.json. L’atlas embarqué
est extrait par Godot. Nassau possède les clips Idle, Walk, Sword, Duck, HitReact,
Death ; il reçoit le profil Peint contrasté, le gabarit, les ombres et les effets existants.

La page Équipe garde strictement le style approuvé des cartes occupées : illustration
dans son cadre fin rectangulaire or, miniature Idle décalée en bas à droite. Aucun
panneau arrondi supplémentaire. La carte Vide reçoit le même cadre, aux dimensions
de l’illustration, sur bleu nuit translucide. Les panneaux de combat gardent leur style.
Le propriétaire a validé cette correction dans Godot après rejet de la première
proposition qui avait ajouté un cadre extérieur aux cartes occupées.
Nassau est ensuite abaissé d’environ 8 px dans son cadre Idle à 540×960, sans zoom :
team_idle_vertical_bias=0,04 contre 0,10 pour les autres héros. Ce réglage appartient
à la définition artistique. Les cadrages 2D de Mako/Anne et leurs modèles restent identiques.

## Composition et formation

party_roster regroupe le catalogue logique et les quatre places par défaut :
Mako, Anne, Nassau, Vide. team_composition stocke les quatre identifiants en JSON v1,
avec validation des doublons, des héros connus et de la présence des trois héros.
Sauvegarde atomique et publication seulement après succès. Aucun déplacement de
carte disponible à cette étape : l’interface par appui long appartient à TEAM-002.
Les catalogues artistiques restent séparés des profils de jeu.

L’application charge la composition et la transmet à Équipe et au lancement du
combat. La simulation et les quatre panneaux utilisent ce même instantané.
Les héros apparaissent sur quatre places fixes, horizontalement à l’écran, au bas
de l’octogone ; une place vide conserve son trou. Espacement physique 1,1 et marge
de gabarit conservée. Allié suit ces indices : Nassau buffe Mako, Anne, puis lui-même
dans la composition initiale, en sautant les membres déjà buffés. Les positions et
états restent conservés entre vagues, ainsi que le tri des statistiques par dégâts.

## Migration des gambits

Schéma courant v4, même fichier joueur party_rules_v2.json. La lecture du v3 convertit
les deux héros vers trois, transfère toutes les lignes Booster de Mako vers Nassau,
conserve leur ordre relatif, leur critère et leur activation. Les autres lignes
Mako/Anne restent identiques. Si des lignes sont transférées, elles remplacent le
Booster par défaut de Nassau ; une Attaque est ajoutée seulement si place disponible.
Cent lignes Booster sont transférées intégralement, sans dépassement ni troncature.
Sans ancienne ligne Booster, Nassau reçoit Allié → Booster puis son attaque de repli.

La première lecture v3 par le store protège les octets dans .v3.bak, puis écrit le
v4 atomiquement. Une sauvegarde conflictuelle ou une erreur bloque la conversion.
La migration est idempotente. Le décodeur pur ne modifie jamais les fichiers.
Le v2 historique garde sa lecture en mémoire et sa copie .v2.bak à la première édition.
L’accueil bloque l’entrée dans Équipe/Combat si les données sont illisibles ou si
la préparation échoue, plutôt que de démarrer silencieusement avec des valeurs par défaut.

## Vérifications

72 scènes / 5 344 contrôles réussis après correction des cartes. Après le dernier
ajustement vertical, le banc TEAM-001 réussit 87 contrôles (84 précédemment).
Il vérifie migration, sauvegardes, limite 100, ordre des buffs, formation, trous,
cartes et fiches, instances et animations réelles à 540×960, 540×1170 et 360×640.
Les anciens bancs ont été adaptés aux trois héros et au transfert de capacité ;
les laboratoires ciblés de mécanique Booster conservent une fixture de deux acteurs
Nassau/Anne, tandis que le banc TEAM-001 couvre la séquence réelle de trois héros.
Captures GPU Équipe/Formation/Combat. Aucun nouveau relevé FPS.

Android : version 83 installée sur Galaxy A16. Migration réelle vérifiée : une ligne
Booster déplacée exactement, autres gambits Anne/Mako inchangés ; copie .v3.bak
identique aux octets d’origine, réglages de combat inchangés, composition conforme.
APK team-001-debug.apk, 0.1.0-team001 (83).
SHA-256 : b6f7670d04f043072c897be5c1275f89cb1ea940ffd83a1d9a8055747f88e9ea.
Clôture documentaire uniquement, sans modification du code, des ressources ou de l’APK
validés. Aucun nouveau test ni relevé FPS. Commit local et sauvegarde complète restaurée
et vérifiée. Aucun push automatique.
Prochaine étape au prochain GO : TEAM-002, appui long et échange des cartes.

## Laboratoire

scenes/debug/nassau_team_lab.tscn : Équipe, Formation figée et Combat réel.
Pas de lecture ni écriture des sauvegardes du joueur.
