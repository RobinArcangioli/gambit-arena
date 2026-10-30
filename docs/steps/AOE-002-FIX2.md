# AOE-002-FIX2 — Impact sur les disques au sol

## État

Correctif demandé le 30 octobre 2026, base AOE-002-FIX1 `a8a32e0`.
78 scènes / 5 841 contrôles consolidés réussis. Capture GPU du scénario de bordure
et du contact exact vérifiée. Deux APK v88 installés et validés sur Galaxy A16 :
« Oui, AOE-002-FIX2 validée ». Gambits, équipe et réglages conservés, vérifiés par
empreinte avant/après installation. Clôture documentaire uniquement ; code et APK
identiques à la recette validée. Commit local et sauvegarde restaurée/vérifiée.
Aucun push automatique.

## Défaut et correction

L’impact traitait chaque ennemi comme un point : son centre devait appartenir au
cercle de rayon 1,4. Cela épargnait un ennemi dont le corps logique chevauchait la
zone, dès lors que son centre se trouvait à l’extérieur.

La règle est maintenant l’intersection de deux disques fermés : distance entre
centres ≤ rayon AOE + rayon physique. Tous les acteurs actuels utilisent le rayon
GroundCrowd.RADIUS = 0,35, également transmis à leur ombre de gabarit. Météore garde
son rayon de 1,4 ; un centre à 1,75 est touché, un disque séparé ne l’est pas.
Une petite tolérance numérique conserve le contact exact dans toutes les directions.

AreaSkills expose la couverture des centres et la fonction de chevauchement.
- AreaProjectiles utilise cette intersection sur les positions actuelles à l’impact.
- PartyExecutor utilise la même règle lors des contrôles de zone vide pendant le cast.
- Orders fournit au solveur exact le rayon de couverture des centres, soit 1,75 pour
  Météore, afin que « Groupe de 3 ou plus » maximise les ennemis réellement touchables.
  Le disque minimum recentre le groupe de centres ; il peut dépasser 1,4 sans changer
  le rayon de la compétence, car les gabarits de bordure intersectent encore l’AOE.

Le solveur de points reste inchangé et testé séparément. Pas de cercle visuel agrandi,
pas de modification des déplacements, des collisions, des modèles ou des effets.
Les cibles restent vivantes et ennemies ; paiement, recharge, point figé, vol,
annulation avant lancement et impact unique gardent leurs protections.

## Vérifications

68 contrôles nouveaux : chevauchement, tangence et séparation dans 16 directions,
40 PV sur quatre corps de bordure, alliés exclus, statistiques et événements uniques,
aucun dégât avant impact, déplacements pendant la chute, contrôle à 0,5 s cohérent,
groupe de trois centres espacés jusqu’à 3,5 et mêmes victimes à l’impact.
Le laboratoire réel est aussi testé : trois hits de bordure et un contact exact,
puis absence de nœuds orphelins après destruction.

Le premier passage a exposé une ancienne fixture dont les six ennemis restaient
regroupables avec leurs gabarits ; elle a été remplacée par six points réellement
séparés (hexagone de rayon 3,6). Le nouveau laboratoire utilise les PV réels des
squelettes (60), sans tentative d’écriture sur des propriétés de santé en lecture
seule. Les deux bancs concernés ont été relancés : 70/70 et 68/68. Les 76 autres
résultats restent valides. Total consolidé : 78 scènes / 5 841 contrôles.

Les captures GPU emploient une conduite du temps synthétique dans le runner afin
de ne pas être interrompues par les notifications de focus du bureau ; aucun
contournement de pause n’est ajouté au jeu ni au laboratoire.
Aucun nouveau relevé FPS. Validation Android obtenue sur les scénarios de bordure.

## Laboratoire Android

scenes/debug/meteor_hitbox_lab.tscn, sans sauvegardes joueur :
- Bords fixes : deux centres à 1,60 et un à 1,75 touchés, les autres séparés.
- Entre / sort : un ennemi quitte la zone, un autre y entre ; décision à l’impact.
- Contact exact : seul l’ennemi tangent à 1,75 reçoit 40 dégâts et maintient le cast.

Les petits cercles or sous les ennemis montrent leurs disques logiques de rayon
0,35. Le cercle AOE reste celui du jeu (1,4), optionnel. Présentation Météore validée
conservée. tools/export_meteor_hitbox_lab.py exporte l’application de laboratoire
séparée org.gambitarena.prototype.aoelab en v88 ; le jeu garde sa scène principale.

## APK validés

- aoe-002-fix2-debug.apk : `d979ad4e33c5ba3c64ca694474cb090a4289aeb0ea81e1f1b369e981b804400f`
- aoe-002-fix2-lab-debug.apk : `9cad0bfde13a5873e861917139b8ed457aaccc7bc48b4e31889c1a3f81772f8c`
