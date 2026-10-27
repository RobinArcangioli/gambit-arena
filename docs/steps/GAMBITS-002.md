# GAMBITS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la refonte intégrée et sa passe stylistique.
APK 0.1.0-gambits002 (49), SHA-256
`8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 53 bancs / 3 497 contrôles réussis ne sont pas
relancés. Les essais Android couvrent les listes, l'autosauvegarde, 100 ordres et la reprise.
Téléphone rendu à l'accueil avec les ordres d'origine migrés, dont Anne 80 % → 70 % ;
copie v2 protégée conservée. Aucun nouveau benchmark FPS.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# GAMBITS-002 — en recette — 27 octobre 2026

Le jeu F5 utilise désormais le catalogue de dix critères de ciblage fixes et les capacités
indépendantes. Éditeur partagé entre fiche et combat, 0–100 ordres par héros, sauvegarde
immédiate de chaque changement, sans Appliquer/Annuler. Ligne unique : activation verte /
croix rouge, chevrons, critère, capacité, corbeille. Ajouter et compteur sous la liste.
Passe stylistique réalisée : bleu nuit, bordures or, menus ivoire/orange, sur le fond fourni.

53 bancs / 3 497 contrôles réussis sans erreur ni avertissement moteur. Recette visuelle GPU
PC et gestes Android documentés dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits002 (49), SHA-256 `8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Base clôturée : GAMBITS-001 `307030fc500dbdf076adaee95b984edfbf3b6d16`, sauvegarde
`gambit-arena-20261027-081032-307030fc500d.tar.gz`, restaurée et vérifiée (678 fichiers).
Cette étape attend la validation utilisateur avant commit et sauvegarde de clôture.
Ensuite : UI-005, qualification intégrée prolongée Android, puis STEP-029/030.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

## Comportement livré

Le composant `scripts/gambits/orders_editor.gd` sert les deux écrans. Les capacités sont
limitées au catalogue propre au héros, mais aucun critère n'impose une équipe : Soin sur
ennemi, Foudre sur allié et attaque sur soi sont permis. Allié inclut soi ; pourcentage
strict, priorité au plus faible pourcentage ; les critères extrêmes ennemis utilisent les
PV actuels absolus. La mémoire de cible offensive ne remplace pas le critère d'un héros.
Les ordres vides/inactifs n'ont pas d'attaque implicite. Les commandes manuelles gardent
leur sélection habituelle ; une action déjà engagée conserve sa cible et ses garde-fous.
Incantations 1,5 / 2 s, paiement à la résolution, annulation sans paiement et animations
inchangés. Aucune modification des modèles, gabarits, navigation, effets ou équilibrage.

Chaque changement est écrit atomiquement avant publication à la simulation. En cas d'échec,
la ligne reprend le dernier état enregistré et un message explique l'échec. Les identités
locales des lignes empêchent un ancien callback de modifier une autre ligne supprimée.
Les deux héros restent indépendants ; le stockage relit le fichier avant chaque écriture.
Retour conserve les changements et revient à la même fiche ; Équipe ne sélectionne rien.
Les menus ferment avant la navigation Retour et sont fermés lors de la perte de focus.

Le chemin historique `user://party_rules_v2.json` est conservé, mais l'enveloppe écrite est
version 3. Une lecture v2 résout la migration en mémoire sans écrire ; au premier changement
la copie `.v2.bak` est protégée puis les deux listes migrées sont écrites. Anne 80 % → 70 %.
Un seuil absent est remplacé par le seuil inférieur disponible. Les ordres non représentables
sont désactivés, avec un message de révision et leur original dans la copie protégée.
Une sauvegarde illisible n'est jamais remplacée par des valeurs par défaut lors d'un clic.

## Architecture et compatibilité

La page produit `arena_page.gd` active `orders_enabled` avant de composer le combat.
`PartySimulation` utilise alors Orders et l'exécuteur autorise toutes les cibles vivantes.
Les laboratoires historiques (`scenes/main.tscn`, scènes party/ et anciens bancs) restent
explicitement en mode v2 pour préserver leurs contrats et leurs recettes de diagnostic.
Leur éditeur historique n'est jamais présenté dans le parcours produit F5 / APK.
Pour tester la nouvelle interface en F6 : `scenes/app/app_root.tscn` ; pour ses bancs :
`scenes/tests/gambits_page_tests.tscn`, `gambits_layout_tests.tscn` et `orders_combat_tests.tscn`.
F8 entre les bancs. Le laboratoire isolé GAMBITS-001 reste disponible.

Le thème de l'éditeur est dérivé de `resources/ui/night_gold.tres` par `AppTheme.editor_theme`.
Menus déroulants internes, sans thème natif divergent ; chevrons, coche, croix et corbeille
vectoriels. Contrôles sur une seule ligne, texte complet dans les menus. Variante compacte
pour les fenêtres étroites ; fond toujours présent derrière les commandes.

## Vérifications

53 scènes / 3 497 contrôles, tous réussis. Les bancs de navigation et de page ont été adaptés
au nouveau contrat ; les anciens contrôles de cycle de vie, reprise, retours, indépendance
des héros et libération des acteurs sont maintenus. Tests des associations croisées réelles,
des durées/paiements/annulations, du ciblage qui prime sur la mémoire offensive, de 0/100
ordres et de l'échec d'écriture. Gestes doigt + souris émulée injectés dans de vrais viewports
540×960, 540×1170 et 360×640 avec listes de 100 lignes. Reprise sans ancien tap déclenché,
défilement sans modification, dernier ordre et ajout accessibles. Captures GPU PC relues.
Les contrôles automatisés ne constituent pas une validation manuelle PC par le propriétaire.

APK final exporté/signé/vérifié par Godot, installé sur Galaxy A16. Recette native et état
final du téléphone consignés dans `verification/gambits002-android-report.json` de l'archive.
Les données privées d'origine du téléphone sont exclues de l'archive de livraison.

## Recette propriétaire

Ouvrir Équipe → Anne/Mako → Gambits. Vérifier les menus et la lisibilité, modifier critère
et capacité, monter/descendre, désactiver, ajouter/supprimer, puis revenir et rouvrir.
Vérifier le même éditeur dans Arène → Gambits et le chargement du réglage au combat suivant.
Tester un soin d'ennemi, une foudre d'allié ou de soi et le retour à vos ordres préférés.
Tester une liste vide, une liste longue et pause/reprise. Valider l'étape avant commit.
