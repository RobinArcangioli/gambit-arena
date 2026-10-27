# BUFFS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le socle des buffs et du temps personnel.
Attaques, incantations, récupération, recharges, déplacements et modèles utilisent le
pas propre à chaque acteur ; mana, durée des buffs et effets autonomes gardent le temps
normal. Laboratoire isolé conservé ; aucune nouvelle compétence dans le jeu à cette étape.
56 bancs / 3 719 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour la clôture, sans relancer les tests : code, scènes, configuration,
assets et APK demeurent identiques à la livraison validée. Gambits Android conservés.
APK normal 0.1.0-buffs001 (55), SHA-256
`5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK laboratoire 0.1.0-buffs001-lab (55), SHA-256
`5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : BUFFS-002,
Booster dans les compétences de Mako et les gambits, puis GRAPHICS-010 et UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-001 — États de buffs et temps personnel — en recette

GO du propriétaire reçu après GAMBITS-003 clôturée (`6b52725`, 716 fichiers vérifiés).
Socle de buffs implémenté, uniquement activable dans le laboratoire isolé à cette étape.
Le combat produit reste à ×1,00 par défaut, avec ses compétences et gambits existants.
Le sort Booster de Mako sera intégré dans BUFFS-002, la montre dans GRAPHICS-010.

## Deux horloges

Le coordinateur accepte une seule fois le delta normal via GameClock, plafonné à 1/30 s.
Il prépare ensuite tous les pas personnels avant toute résolution d'action. Un buff reçu
pendant une résolution prend effet au prochain pas accepté, sans accélérer rétroactivement
un pas déjà préparé ni dépendre de l'ordre Anne/Mako pour l'application de son temps.
L'impact demeure quantifié au pas du combat ; l'expiration, elle, sépare exactement les
portions accélérée et normale à l'intérieur du pas. Une action en cours garde son identifiant
et sa progression quand son acteur reçoit ou perd un buff.

Le facteur ×1,30 multiplie le delta accepté, pas les durées de référence. Un cast de 1,5 s
prend environ 1,154 s, un cast de 2 s environ 1,538 s ; les actions, récupération et recharges
utilisent le même temps personnel. La mana régénère toujours de 5 par seconde de combat.
Les 60 s de buff, les vagues et le budget de recherche de chemins utilisent le temps normal.
Pause / arrière-plan ne fournissent aucun delta et ne consomment aucun de ces temps.
Aucun Engine.time_scale, changement de statistiques de base ou nouveau paiement de mana.

## Séparation des responsabilités

- `scripts/buffs/buff_definition.gd` crée des définitions immuables de valeurs : ID stable,
  durée, multiplicateur de temps et politique `reject_active`. Pas de référence à une scène,
  un personnage, une capacité ou une sauvegarde.
- `buff_state.gd` copie les valeurs validées dans l'état de combat du participant. Même ID
  actif refusé, sans cumul ni renouvellement. Après expiration, réapplication possible.
  Plusieurs IDs distincts composent leurs multiplicateurs dans un ordre stable. Les
  instantanés sont des copies détachées ; les ressources de référence ne sont jamais modifiées.
- PartyUnit porte cet état, son temps personnel et le pas accepté. PartySimulation prépare
  les pas de tous les acteurs avant les exécuteurs ; les instantanés de ciblage exposent
  seulement les valeurs des buffs. Aucun état temporaire sérialisé dans les gambits v3.
- PartyExecutor sépare delta d'action/recharge et delta de régénération. Son adaptateur
  d'appel direct conserve les laboratoires historiques. Le paiement à la résolution et
  l'annulation sans débit restent ceux de GAMBITS-002.
- Le solveur de foule reçoit une distance maximale par acteur, calculée à partir de sa
  vitesse de référence et de son pas personnel : aucun second plafond à 1,2 unité/s.
  Balayage des disques, rayon, terrain, déchevauchement et budget global des chemins sont
  conservés. Les déplacements et leurs plafonds se basent sur la même quantité de temps.
- CombatPresenter transmet le pas personnel aux modèles passifs. Les clips d'attaque et
  d'incantation restent synchronisés à l'exécuteur réel ; aucun second speed_scale.
  Idle, marche et réactions suivent ce même temps. Au décès, le taux est copié dans
  l'événement de présentation, puis les buffs logiques sont effacés immédiatement.
  Les vues de mort gardent ce taux pour le clip et leur retrait, sans garder l'acteur vivant.
  Soin, foudre et futurs effets autonomes reçoivent le delta normal du combat.

Mort, remplacement d'état, abandon et Rejouer nettoient les buffs ; une nouvelle partie
ne les récupère jamais. Une nouvelle vague ne modifie pas les buffs des héros survivants.
Le catalogue de capacités, les profils, l'éditeur, le format v3 et Main restent inchangés.

## Laboratoire de recette

F6 : `scenes/debug/personal_time_lab.tscn`, F8 pour fermer. Aucun accès aux réglages réels :
chemin isolé `user://buffs001_isolated_lab.json`, défauts de laboratoire en mémoire.

1. Les deux héros sont au repos, sans apparition automatique d'ennemis. Leur temps personnel
   correspond au temps de combat et leur mana vaut 60. Le bouton Pause produit est conservé.
2. Appuyer sur **Mako ×1,30**, puis **Soin comparé**. Le laboratoire donne temporairement
   les mêmes sorts aux deux acteurs, les blesse de 35 PV et règle leur mana à 30 pour
   permettre une comparaison. Les deux casts ont la même référence de 1,5 s.
3. Observer Mako plus rapide, ses barres et sa recharge plus avancées. La mana des deux
   monte au même rythme, puis chacun paie 20 à sa propre résolution. Les pourcentages
   affichés sont ceux des vrais exécuteurs. La durée du buff décroît en temps normal.
4. Tester **Anne ×1,30**, **Retirer**, puis **Squelette** pour le mouvement et l'attaque
   réels ; ces contrôles ne modifient aucune sauvegarde ou compétence du jeu normal.
5. Pause gèle le temps, les buffs, mana et modèles. Retour Android / arrière-plan conserve
   une pause explicite. **Repartir** crée un combat neuf, sans buff ni compétence de fixture.

Exporter le laboratoire avec `python3 tools/export_personal_time_lab.py --godot <binaire>
--output <chemin.apk>` ; le helper utilise une copie temporaire et laisse Main intact.
Il utilise le même package que le jeu, à installer temporairement avant de remettre l'APK
normal. Version normale 0.1.0-buffs001 (55), version lab 0.1.0-buffs001-lab (55).

## Vérification effectuée

56 scènes / 3 719 contrôles réussis, zéro erreur ou avertissement moteur. Nouveau banc
`scenes/tests/personal_time_tests.tscn` : 75 contrôles. Durée de 60 s à 30/60/120/144 Hz,
frontières d'expiration, non-cumul, snapshots détachés, pause, mana, incantations, paiement,
recharges, attaque et récupération, application pendant une résolution, mouvement direct
et routé, collisions, limites du terrain, décès, abandon, reset et vues de mort. Le vrai
coordinateur est aussi avancé pendant 60 s : Mako cumule 78 s personnelles, Anne 60 s.
Le passage d'une vague conserve le même état par héros : aucun réinitialisateur de buff
n'est branché sur WaveSchedule. Les tests historiques de vagues restent réussis.

Aperçu GPU PC piloté : à 0,50 s de combat, casts 0,65 s / 0,50 s, mana identique,
aucun nœud orphelin. Ce n'est pas une validation manuelle du propriétaire.
Recette tactile Galaxy A16 : accélération et soin comparé, mana identique, deux captures
successives de pause identiques, retour au premier plan encore en pause. APK normal remis,
empreinte installée vérifiée, configuration originale identique octet pour octet. Aucune
mesure FPS nouvelle ; rapports et captures dans la livraison complète.

APK normal SHA-256 : `5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK lab SHA-256 : `5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
Validation utilisateur, commit unique et sauvegarde restaurée attendus avant BUFFS-002.
