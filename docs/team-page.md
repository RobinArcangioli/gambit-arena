# UI-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la page Équipe : Mako/Anne en Idle,
deux places vides, sélection et retours. Validation globale sans détail supplémentaire.
APK normal 0.1.0-ui002 (45), SHA-256
`88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 45 bancs / 2 816 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure de performance. Clôture par commit unique et sauvegarde
restaurée/vérifiée ; prochain GO : UI-003, fiches de personnage en valeurs de référence.
Les fiches et les gambits hors combat ne sont pas encore implémentés. GAMEPLAY-003 reste
annulée. Les mentions de recette ci-dessous décrivent les états historiques.

# Page Équipe — UI-002

## Comportement livré

Accueil → Équipe ouvre scenes/app/team_page.tscn sur l'image team.png fournie. Quatre cartes
forment une grille 2 × 2 : Mako, Anne, Vide, Vide. Deux modèles cadrés avec caméra orthographique
jouent uniquement Idle. Les cartes occupées partagent le thème night_gold.tres : surface bleu
nuit translucide, contour or, sélection ambre. Les cases vides sont désactivées et n'ont aucun
SubViewport, caméra ou personnage. Fond plein écran et contenu placé dans la zone sûre.

Toucher une carte, son nom ou le modèle sélectionne mako/anne. Une seule carte est sélectionnée,
le libellé « Sélection : … » confirme le choix. AppRoot garde selected_hero_id et émet hero_selected
avec le même identifiant. La sélection survit aux allers-retours pendant cette session ; elle
ne change ni la composition ni les règles sauvegardées. Les fiches ne sont pas encore livrées :
UI-003 utilisera cette identité et les valeurs de référence. UI-004 ajoutera l'accès aux gambits.
Le bouton ‹ Accueil, Échap et Retour Android reviennent à l'accueil ; Retour sur l'accueil reste
sur l'accueil. L'arène conserve sa création neuve et son tirage aléatoire.

## Isolation

team_roster.gd définit l'ordre visuel et référence les profils/présentations existants sans
copier les statistiques. hero_portrait.gd réutilise CharacterView : monde 3D propre et transparent,
lumière/caméra locales, avance visuelle explicite. Aucun acteur de simulation, exécuteur, moteur
de combat, déplacement ou horloge autonome. Aucun changement à CharacterView ni aux animations.
Le gabarit d'ombre vient de GroundCrowd.RADIUS ; modèles et rayons du combat restent identiques.

TeamPage avance les deux aperçus seulement quand elle est visible et active. Le garde existant
d'AppRoot coupe cartes, bouton Retour et mises à jour des SubViewports dès perte de focus/pause.
À la reprise, le premier delta est jeté puis borné à 1/30 s, sans rattrapage de l'absence. Au retour
accueil, les mises à jour sont coupées avant détachement et queue_free de la page entière.

## Vérification exécutée

Godot 4.7.2, rendu Compatibility. 45 scènes de tests, 2 816 contrôles, zéro échec, aucune ligne
ERROR/WARNING dans leurs journaux. Deux nouveaux bancs : team_page_tests (61), team_layout_tests
(37). Celui de navigation existant conserve ses 80 contrôles ; l'attente du bouton Équipe passe
de désactivé à actif, changement intentionnel de UI-002. Les autres bancs restent inchangés.

Couverture : identité et sélection exclusive, deux mondes seulement, cases vides, véritable
clip Idle et horloge explicite, focus/pause/reprise, premier delta, destruction des mondes,
20 cycles, zéro orphelin, aucune partie sur Équipe, ordre Anne/Mako du combat conservé. Injection
doigt + souris émulée au viewport réel sur 540 × 960, 540 × 1170 et 360 × 640 : zones sûres,
cartes non superposées, tap au centre du modèle, cases vides et bouton Retour.
Captures GPU PC inspectées ; aperçu animé et fermeture sans orphelin. Le pilote NVIDIA hôte
émet des messages de chargement puis utilise correctement le GPU AMD Mesa pour ce rendu.

APK 0.1.0-ui002, code 45, 41 212 724 octets, SHA-256 :
`88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Galaxy A16 SM-A165F : installation -r réussie ; ouverture Équipe, Mako puis Anne, tap des deux
cases vides, Retour Android puis Retour sur accueil, sélection retenue à la réouverture,
Idle à deux instants, Home système/reprise et bouton Accueil. Captures et log natifs joints à
la livraison ; inspection distincte des tests synthétiques. Aucune nouvelle mesure FPS.
Téléphone laissé sur Équipe, Anne sélectionnée. Recette utilisateur encore attendue.

## Recette utilisateur

F5, puis Équipe : observer les deux Idle et toucher chacun des deux héros. Vérifier le surlignage,
le bon nom et l'absence d'action des deux cases vides. Revenir par ‹ Accueil puis réouvrir ;
essayer Retour Android et la mise en arrière-plan/reprise. F6 des scènes de tests ci-dessus
reste disponible, F8 entre les bancs. Les fiches et les gambits hors combat arrivent ensuite.
