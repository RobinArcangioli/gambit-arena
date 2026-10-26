# GRAPHICS-004 et fix1 validés — 26 octobre 2026

Le propriétaire confirme « Tout est OK. Step validée. » pour la livraison fix1,
APK 0.1.0-graphics004-fix1 (35), installé sur Galaxy A16.
SHA-256 APK : `242961171f11a2f9e0ae1dbd9efad59af43df5b02e8e745261ca24c9bd805959`.
Les fichiers non documentaires restent identiques à la livraison validée ; les 34 bancs /
2 154 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, fix1 inclus, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-005, effet de soin ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-004 — attaque, réaction, mort et priorité des actions

GO reçu après GAMEPLAY-001 et fix1 validés. Base : b1dfb33b12ba4ab74388894aefd0004cb1ce39e4.
Sauvegarde restaurée et vérifiée : gambit-arena-20261026-172958-b1dfb33b12ba.tar.gz,
SHA-256 d24379a99c7ec0f42bb1f82e881bf5012cac9d18fc591703126ef96eafce11a8,
479 fichiers identiques au checkpoint. Travail isolé dans /tmp/gambit-graphics004-work.

## Résultat

Sword, HitReact et Death raccordés aux quatre modèles. Événements de transition collectés
au tick, réactions sur dégâts réels et vues de mort détachées et bornées. Les ennemis
sortent du combat immédiatement ; le geste graphique ne prolonge pas leur vie logique.
Une galerie F6 indépendante prévisualise les gestes. Voir ../combat-presentation.md.

Pendant la recette sur l'APK initial (code 34), le propriétaire signale des attaques
parfois non visibles sur les deux héros et demande une priorité minimale stricte pour
Idle/HitReact. Le fix1 inclus ci-dessous est la livraison active de cette étape.

## GRAPHICS-004-fix1 — priorité et lecteur

Mort > action active (attaque/sort/récupération) > déplacement > HitReact > Idle.
Tout nouvel état prioritaire interrompt la réaction de bas niveau immédiatement.
L'action courante est appliquée avant de traiter les impacts reçus. En action ou en marche,
le coup reçu peut allumer le flash mais ne change ni le clip ni la pose des os.

Le test isolé ne reproduisait pas une prise de contrôle par HitReact sur une attaque déjà
active. Le test détaillé a toutefois reproduit l'arrêt d'AnimationPlayer lorsque le sampler
atteignait la fin d'un clip, alors que le cache de présentation le croyait encore actif.
Marge de 100 microsecondes à la borne finale et réarmement d'un lecteur arrêté ajoutés.
Les tests vérifient le clip ET les rotations réelles des os, y compris aux bornes et lors
 d'actions consécutives. Les quaternions sont normalisés pour cette comparaison.

Duck est avancé dans cette étape pour respecter la nouvelle instruction de priorité des
incantations : Soin d'Anne 1,5 s et Foudre de Mako 2 s. Seuls les gestes sont raccordés ;
les effets dédiés restent GRAPHICS-005/006. Aucun changement de règles, dégâts, mana ou délais.

## Vérifications effectuées

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility. **34 bancs headless, 2 154 contrôles,
zéro échec et aucun warning/erreur dans la campagne finale.**

- 107 contrôles de présentation : quatre profils, contact/récupération, clips sûrs,
  coups hors portée, actions complètes entre instantanés, déduplication, morts, pause/focus,
  fin visuelle sans temps de jeu, dix Rejouer, ancien run, plafond de corps et file bornée.
- 88 contrôles de priorité : six coups par frame sur les quatre modèles, clip et squelette,
  attaques consécutives et lecteur arrêté, deux durées de Duck, récupération de sort,
  déplacement et mort prioritaires. Main est testé avec coups reçus dans le tick exact où
  Anne et Mako commencent une attaque, puis un soin et une Foudre.
- Les 32 anciens bancs / 1 959 contrôles passent également.
- Trois traces comparées à la restauration du commit b1dfb33 : 2 463, 1 586 et 3 652 ticks,
  soit 7 701 ticks de gameplay identiques. Positions, PV, mana, coûts, actions, phases,
  cooldowns, vagues et dégâts comparés ; les durcissements fix1 n'ajoutent aucune écriture
  à ces états de jeu. Trace JSON SHA-256 335e9087d61d77cbf8a5a909465caf634b6969b69c346fb6584433b10dc3e43a.

Rendu en fenêtre inspecté pour les quatre modèles (frappe, réaction, mort), pour Main avec
une mort après victoire, puis pour Duck sur Anne et Mako. Nettoyage à zéro orphelin.

Après reconnexion du Galaxy A16, le correctif final 0.1.0-graphics004-fix1 (35) a été
installé avec adb install -r (données conservées) puis lancé avec succès. Version/code
confirmés par dumpsys package. La validation visuelle utilisateur du build 35 reste attendue.
Aucune nouvelle campagne FPS revendiquée.

APK actif : /tmp/graphics-004-fix1-debug.apk — 37 336 185 octets.
Version : 0.1.0-graphics004-fix1, code 35.
SHA-256 : 242961171f11a2f9e0ae1dbd9efad59af43df5b02e8e745261ca24c9bd805959.

## Recette utilisateur

F6 action_lab.tscn : gestes et priorités, C pour Duck, Pause et modèles/orientations.
F8 puis F5 : observer Anne et Mako attaquer et incanter sous les coups reçus ; aucun Idle
ou HitReact ne doit remplacer une action active. Vérifier le soin inclusif et la mana
préservée jusqu'à l'effet, puis pause/reprise Android, défaite/victoire et Rejouer.

Étape et fix1 en recette, sans commit/push. Validation utilisateur attendue ; ensuite
GRAPHICS-005 ajoute l'effet de soin. Le chantier graphique reste séparé de l'équilibrage.
