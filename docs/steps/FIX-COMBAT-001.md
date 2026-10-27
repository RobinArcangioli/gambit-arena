# FIX-COMBAT-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le reciblage après annulation d'une
incantation et les squelettes sans mana ni barre bleue. Les 60 bancs / 4 054 contrôles
et les 24 contrôles natifs sur Galaxy A16 avaient déjà réussi ; gambits conservés.
Clôture documentaire uniquement : code, scènes, profils, shader, configuration et
les deux APK restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-fix-combat001` (60), SHA-256
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030. Aucun push automatique.
Les états précédents ci-dessous sont historiques.

# FIX-COMBAT-001 — Annulation de sort et mana des squelettes

Statut : en recette, validation utilisateur attendue. Base : GRAPHICS-012 clôturée,
`ea1a3e44fd9902bbe182a163bb17d5e71eb5ba9c`. Demande directe du propriétaire :
recibler immédiatement après mort de la cible pendant l'incantation ; squelettes sans mana.

## Corrections

L'exécuteur réservait la recharge à l'engagement et ne la libérait pas lors d'une
annulation. Le gambit Foudre était donc ignoré après la mort de sa cible. `cancel()`
remet à zéro uniquement la recharge de l'action active encore non résolue. La simulation
peut réévaluer les gambits au prochain pas accepté et incanter Foudre sur l'ennemi
vivant suivant. Pas de récupération résiduelle, pas de débit de mana pour le sort annulé.
La même règle couvre Soin et les autres préparations interrompues. Une annulation
répétée ne touche pas une autre recharge ; un ancien identifiant d'impact ne peut pas
résoudre le nouveau sort. Après résolution, recharge et récupération habituelles sont
conservées, même si le sort tue sa cible. Aucun changement de cadence des sorts réussis.

Le profil de squelette fixe explicitement `mana_capacity = 0` et
`mana_regeneration = 0`. Le rendu des barres prend l'existence de mana dans les valeurs
reçues, sans connaître le type d'acteur : une capacité nulle masque la ligne bleue.
La hauteur du dessin suit le nombre de lignes effectivement visibles ; une éventuelle
incantation sans mana se place juste après les PV. PV / mana / sort restent dans leur
ordre habituel pour les héros, avec les styles et dimensions validés.
Le laboratoire des néons n'invente plus de mana ou de Booster pour les squelettes.

## Vérifications effectuées

- Banc reproduisant le défaut avant correction : 24 contrôles, 16 échecs attendus ;
  puis 24 contrôles, 0 échec après correction.
- Suite complète : 60 scènes, 4 054 contrôles, 0 échec, erreur ou avertissement moteur.
- Régression : décès de cible pendant Foudre, nouvelle cible dès le pas suivant,
  aucun débit anticipé, ancien impact rejeté, annulation répétée, recharge indépendante
  conservée, impact létal réussi non remboursé, Soin d'Anne reciblable sur elle-même.
- Squelettes : capacité/régénération/mana nulles, aucune apparition de mana avec le temps,
  ligne bleue absente dans le shader ; mana des deux héros toujours à capacité 60.
- GPU Godot : barres flottantes de largeur 29,4, panneaux de largeur 171, deux barres
  de mana héros et aucune pour les deux squelettes ; aucun nœud orphelin.
- Galaxy A16 : les mêmes 24 contrôles passent dans un APK de tests isolé ; APK normal
  réinstallé, combat et rendu vérifiés, deux captures de pause identiques octet pour octet.
  Versions et SHA des deux APK installés vérifiés. Aucun changement des gambits sauvés,
  aucune erreur dans les journaux natifs. Aucun nouveau benchmark de performances.
- L'import initial sandboxé n'a pas pu enregistrer les réglages Godot ; import relancé
  hors sandbox avec succès. La suite et les exports finaux sont exempts d'erreurs moteur.

## Recette utilisateur

F6 : `scenes/tests/cast_cancellation_tests.tscn` doit indiquer
`OK : 24 controles, 0 echecs`. F8 avant F5. F5 conserve l'accueil normal.
Pour le rendu : `scenes/debug/neon_bars_lab.tscn`, F6, squelettes avec PV seuls.
En combat Android, faire tuer par Anne la cible de Foudre en préparation : Mako
incante sur l'ennemi suivant immédiatement s'il est éligible et à portée. Le temps de
la nouvelle incantation et les contraintes ordinaires de mana/portée restent applicables.
Valider aussi les attaques, Soin, Booster et la pause. Aucune modification automatique
de la configuration joueur pour provoquer cette situation.

APK normal `0.1.0-fix-combat001` (60), installé :
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
APK de tests `0.1.0-fix-combat001-tests` (60) :
`67681f504dd347a7b1dd985b694010d517cb8a34a2e90c15f5a0322fbea1c86a`.
Export reproductible des tests sans modifier Main :
`python3 tools/export_cast_cancellation_tests.py --godot /chemin/godot --output /chemin/tests.apk`.

Livraison complète sans `.git/.godot`, historique séparé à la base `ea1a3e4`, deux APK,
manifestes et preuves vérifiés après extraction. Les modifications de ce correctif ne
figurent pas encore dans le bundle historique. Commit et sauvegarde de clôture attendent
la validation de l'étape. Aucun push automatique. Après clôture : UI-005.
