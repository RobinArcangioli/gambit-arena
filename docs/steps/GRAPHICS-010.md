# GRAPHICS-010 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Équilibré : montre dorée
procédurale translucide de 2 s, aiguilles accélérées, suivi de cible et fondu partagé.
Le soin garde son rendu et sa durée de 1 s ; la logique des buffs reste inchangée.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, configuration et deux APK
restent identiques à la livraison validée. Les tests moteur ne sont pas relancés.
Gambits du téléphone conservés ; réglage B vérifié sur le Galaxy et APK normal remis.
APK normal 0.1.0-graphics010 (57), SHA-256
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK essais 0.1.0-graphics010-lab (57), SHA-256
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-010 — Montre procédurale et fondu partagé — en recette

Base clôturée : BUFFS-002 `1d2d66a8a3e6356ae4867b0e1727776bb1b28d27`, 738 fichiers vérifiés.
GO reçu ; le propriétaire choisit **B — Équilibré** dans la fenêtre Godot. Ce choix esthétique
est distinct de la validation finale de l'étape et de la recette Android.

## Résultat et réglages

Une montre dorée sobre et translucide apparaît sur la cible après chaque application réussie
de Booster. Cadran, douze graduations, petite couronne et deux aiguilles sont construits en
meshes ; aucun modèle, bitmap externe ou génération d'image. Le cadran fait face à la caméra
et suit la position de la cible. La montre reste séparée du modèle et des barres de combat.

Profil retenu : rayon 0,47 unité, ancrage à 0,72 unité au-dessus des pieds, opacité générale
0,85. Couleurs or et crème, fond brun très léger ; matériaux transparents non éclairés,
sans halo envahissant ni ombre physique. La géométrie n'ajoute aucun corps ou obstacle.
Deux aiguilles de longueurs différentes, à vitesses initiales 0,10 / 0,30 tour/s et finales
1,40 / 3,50 tours/s. Accélération linéaire sur les premières 0,45 s, puis vitesse constante.
L'angle est l'intégrale analytique de cette vitesse, continue à la fin de l'accélération,
indépendante de la fréquence des images : aucun saut ou second multiplicateur temporel.

La durée visuelle est de 2 s du temps normal du combat. Le temps personnel ×1,30 de la cible
ne l'accélère pas et la durée de 60 s du buff ne la prolonge pas. La pause et l'arrière-plan
figent l'effet ; la reprise explicite repart du même âge. Le mouvement continue de fournir
l'ancrage pendant la courte durée de l'animation. Cible disparue ou morte : retrait immédiat.

## Fondu commun, soin conservé

`effect_fade.gd` et `resources/presentation/effects/common_fade.tres` définissent l'enveloppe
commune : apparition smoothstep de 0 à 6 % de la durée, disparition smoothstep de 36 à 100 %.
Formule : smoothstep(0, 0.06, p) × (1 − smoothstep(0.36, 1, p)). Le profil peut être dupliqué
pour un futur effet ayant d'autres réglages. Les définitions de soin et de montre référencent
ce même profil par défaut ; les états d'animation ne modifient jamais cette ressource.

Le soin conserve sa durée de 1 s, les deux anneaux et leurs axes, le glow vert, la valeur
réelle soignée, ses couleurs et son ancrage. Seule la formule d'opacité est extraite. Les
101 échantillons du nouveau banc sont identiques à la formule antérieure, et tous les tests
historiques du soin passent. Le shader, les scènes, meshes et autres réglages du soin ne
sont pas changés. Les deux effets se terminent dans une transparence complète.

## Séparation et cycle de vie

- `booster_effect_definition.gd` / `effects/booster.tres` portent uniquement scène, dimensions,
  couleurs, transparence, ancrage, durée visuelle, vitesses et accélération. Rien n'y règle
  la durée du buff, le coût ou la vitesse réelle d'une action.
- `booster_effect.gd` crée et échantillonne la montre à partir de ces valeurs et du temps
  accepté. Matériaux privés par instance ; aucune animation autonome ni callback de combat.
- `booster_presenter.gd` reçoit des copies de positions et de vie, et les faits de succès
  `buff_applied` de BUFFS-002. Il exige buff_id/outcome Booster et le bon run, déduplique
  les séquences, borne à huit effets simultanés et ignore toute cible absente ou morte.
- CombatPresenter transmet ces faits et le delta visuel normal. Start/resolve/cancel/end
  ne créent pas de montre ; aucune montre sur échec ou doublon. Aucun faux soin/dégât ou
  retrait de mana n'est utilisé pour l'effet. Les modèles conservent leur temps personnel.
- Mort, disparition, désactivation des VFX, Rejouer, abandon et destruction de la page
  libèrent les instances. Les faits d'une ancienne partie sont rejetés après reset.

Les fichiers de logique PartyUnit/PartySimulation/PartyExecutor, de buffs, critères, ordres,
profils, sauvegarde et navigation sont identiques à la base clôturée. Le laboratoire de
Booster historique ne change que son texte annonçant maintenant la montre livrée.
Main et son UID sont conservés ; aucune modification de la programmation des gambits.

## Laboratoires et recette propriétaire

F6 `scenes/debug/booster_watch_lab.tscn`, F8 pour fermer dans l'éditeur :
A Discret (rayon 0,42 / opacité 0,65), B Équilibré (0,47 / 0,85), C Présent (0,52 / 1).
Choisir un essai, Revoir, ou Comparer A/B/C qui change toutes les 6 s. Le même effet est
rejoué après 2,8 s. Montre sur Mako et soin sur Anne permettent de comparer leurs fondus.
Ces aperçus sont explicitement visuels : faits synthétiques confinés au laboratoire,
aucune modification des PV, de la mana, des buffs ou des ordres du joueur. Fichier utilisateur
isolé `graphics010_art_lab.json`. B est le réglage du produit et le choix du propriétaire.

Pour les vrais lancers : F6 `scenes/debug/booster_lab.tscn`, sans modifier les réglages du
joueur. La séquence réelle Mako puis Anne affiche deux montres qui peuvent se chevaucher.
F5 : dans les gambits de Mako, placer Allié → Booster en tête ; entrer en arène et vérifier
Duck, barre d'incantation, montre sur la bonne cible et fondu. Pause, reprise et Rejouer
restent ceux de l'arène sobre. Le buff reste actif bien après la disparition de sa montre.

Export isolé des essais : `python3 tools/export_booster_watch_lab.py --godot <binaire>
--output <chemin.apk>`. Même package que le jeu, à remettre ensuite sur l'APK normal.

## Vérification effectuée

58 scènes / 4 001 contrôles réussis, zéro erreur/avertissement moteur. Nouveau banc
`scenes/tests/booster_watch_tests.tscn` : 152 contrôles. Comparaison de fondu, intégration
d'angles à 30/60/120/144 Hz, pause et deltas invalides, matériaux distincts, orientation
caméra, cible mobile/absente/morte, doublons, autres événements, cap d'instances, anciennes
parties, scène manquante, vrai lancers avec/sans VFX, deux montres simultanées, fin de la
montre sans fin du buff, annulations (mort, portée, mana, buff concurrent), essais sans
mutation logique, nettoyage sans nœud orphelin. Les 57 bancs précédents restent réussis.

Aperçus GPU PC A/B/C sur arène claire, fondus du soin et choix B du propriétaire ; aucune
nouvelle mesure FPS. Sur le Galaxy, Revoir relance la montre B et le soin, les deux poses
d’aiguilles et le fondu sont capturés. La pause tactile donne deux images identiques,
le retour au premier plan garde la pause. L’APK normal est remis, les deux empreintes
installées sont vérifiées et les gambits restent identiques octet pour octet. Rapports et
captures joints à la livraison complète, avec sources, bundle séparé et deux APK.

APK normal 0.1.0-graphics010 (57), SHA-256 :
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK essais 0.1.0-graphics010-lab (57), SHA-256 :
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
Validation utilisateur, commit unique et sauvegarde vérifiée attendus avant UI-005.
