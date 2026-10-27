# UI-004 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les gambits hors combat et le correctif
Équipe : cartes en accès direct, sans sélection persistante. Validation globale sans
précisions supplémentaires. APK normal 0.1.0-ui004 (47), SHA-256
`527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 49 bancs / 3 028 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure FPS. Les réglages Android initiaux restent conservés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. UI-005, recette intégrée du
parcours complet PC/Android, attend le prochain GO ; puis STEP-029 et STEP-030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# Gambits hors combat — UI-004

## Parcours et édition

F5 → Équipe → Mako/Anne → Gambits. Le bouton de la fiche est désormais actif. Une page dédiée
sur le fond team.png fourni reprend le thème night_gold.tres ; aucun combat n'est instancié.
Trois cartes suivent la priorité de haut en bas. Chacune permet activation, remontée/descente,
choix de la compétence et de sa cible associée, condition Toujours ou PV < seuil, et ajustement
du seuil par -10/-1/+1/+10 entre 0 et 100. Seuil strict, désactivé/inutilisé avec Toujours.
Mako a Attaque/Foudre sur ennemi ; Anne a Attaque sur ennemi et Soin sur allié, elle comprise.
Les choix sont exactement ceux acceptés par PartyRules ; aucun nouveau type de règle.

Appliquer valide puis enregistre les trois règles et retourne à la même fiche. Annuler,
‹ Fiche, Échap ou Retour Android jettent le brouillon et retournent aussi à la même fiche.
Appliquer et Annuler restent en bas, hors de la zone défilante ; l'en-tête Retour reste fixe.
Un glissement ne déclenche pas les boutons traversés. Le garde existant bloque l'édition
et l'enregistrement en arrière-plan ; un relâchement périmé ne peut pas appliquer un brouillon.

## Isolation et sauvegarde partagée

gambits_page.gd réutilise la coque HeroPage (fond, thème, panneaux, zones sûres et routeur
tactile) en remplaçant le contenu par les trois cartes. Aucune simulation ou présentation
3D supplémentaire. Fiche et équipe restent cachées/inactives derrière l'éditeur. AppRoot
possède cette nouvelle route et détruit la page au retour, ou toute la pile au retour accueil.
Le retour Android est toujours dédupliqué et avance d'un niveau : gambits → fiche → équipe
→ accueil. Les deux aperçus Idle d'équipe restent arrêtés tant que cette route est cachée.

gambits_draft.gd prend une copie profonde des trois règles. Il réutilise, sans modification,
PartyRules.defaults, valid_rule, load_configuration et save_configuration. Le chemin reste
user://party_rules_v2.json, format version 2, deux héros et trois règles par héros. La sauvegarde
canonique écrit le fichier temporaire puis le renomme. Avant Appliquer, l'adaptateur recharge
la configuration et remplace seulement les règles du héros courant : des changements plus
récents de l'autre héros ne sont pas perdus. Les brouillons n'écrivent pas avant Appliquer.
Fichier absent : valeurs par défaut ; fichier existant invalide : enregistrement bloqué avec
message, sans écrasement silencieux. Échec d'écriture : brouillon conservé et message visible
en tête de page, sans retour à la fiche. Aucun format historique ou règle de combat modifié.

La prochaine entrée en arène utilise le même chargeur et lit donc les règles enregistrées.
L'éditeur en combat reste inchangé : ses modifications sont relues à la prochaine ouverture
de la page Gambits hors combat. Les règles de l'autre héros restent toujours présentes.

## Correctif Équipe demandé après UI-003

TeamPage n'a plus de selected_id, de feedback « Sélection : … » ou « Choisissez un héros »,
ni de boutons en mode bascule. Les cartes sont de simples accès à une fiche. Le focus des
cartes est relâché au retour, aucun surlignage ambre ne persiste. Survol, appui et focus
clavier usuels restent possibles pendant l'interaction. L'identifiant conservé par AppRoot
sert uniquement au routage ; Équipe ne l'utilise plus pour représenter une sélection.
Les deux places vides restent désactivées et sans modèle. Grille, gabarits et Idle inchangés.

## Vérification exécutée

Godot 4.7.2 Compatibility : 49 scènes, 3 028 contrôles, zéro échec et aucune ligne ERROR/WARNING
dans leurs journaux. Nouveaux bancs gambits_page_tests (47) et gambits_layout_tests (61).
Les bancs Équipe et Fiches précédents sont adaptés aux cartes sans sélection et au bouton
Gambits fonctionnel, sans supprimer leurs autres contrôles.

Couverture : copies détachées, préservation de l'autre héros y compris après écriture plus
récente, compétences autorisées, bornes et seuil ignoré avec Toujours, ordre, activation,
Appliquer/Annuler/Retour Android, reprise de la bonne route, arène qui recharge, éditeur en
combat qui sauvegarde et page menu qui relit, dix cycles complets et zéro orphelin, nouvelle
application relisant le fichier, configuration invalide préservée et échec d'écriture gardant
le brouillon. Injection au viewport réel des événements doigt + souris émulée sur 540 × 960,
540 × 1170 et 360 × 640 : ouverture du bon héros, zones sûres, absence de débordement horizontal,
+1 sans doublon, glissement sans action involontaire, dernière règle accessible, commandes
fixes, vieux relâchement après reprise et retour équipe sans carte sélectionnée/focalisée.

Rendu GPU PC piloté par script avec focus explicite du pilote de recette : haut/bas des deux
éditeurs et retours Équipe inspectés, zéro orphelin à la fermeture. Le pilote NVIDIA hôte
signale son chargement puis le rendu utilise AMD Mesa ; ce n'est pas une recette manuelle PC.
APK 0.1.0-ui004 (47), 41 260 482 octets, SHA-256 :
`527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Galaxy A16 : ouverture Anne (seuil utilisateur 80 %), brouillon +1, sauvegarde à 81 %,
réouverture, activation puis Annuler sans écriture, glissement, Home système/reprise, retours
par niveaux, Mako/Foudre et réordre annulé, persistance après arrêt/relance. À la fin, le
fichier original est rétabli octet pour octet et l'application relancée : Anne retrouve 80 %.
Captures et rapport natifs joints, journal du processus final sans erreur. Téléphone laissé
sur les gambits d'Anne. Aucun nouveau FPS mesuré. Recette utilisateur encore attendue.

## Recette utilisateur

F5 → Équipe : aucune carte sélectionnée. Ouvrir une fiche, Gambits, modifier une règle,
réordonner, Appliquer ; réouvrir et vérifier la persistance puis Annuler une autre modification.
Vérifier que l'autre héros n'a pas changé et qu'un nouveau combat reprend les réglages.
Retour fiche/équipe : aucune sélection persistante. Essayer Retour Android, défilement et
mise en arrière-plan/reprise. F6 : scenes/tests/gambits_page_tests.tscn et
scenes/tests/gambits_layout_tests.tscn, F8 entre les bancs. UI-005 reste la recette intégrée.
