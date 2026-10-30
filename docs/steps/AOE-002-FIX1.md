# AOE-002-FIX1 — Refonte de Météore et annulation de zone vide

## État

Base AOE-002 : `108f4d3`. Choix Godot final du propriétaire : **C — Avec braises**,
sur **Flash compact** et **Rouge accentué**. Deux APK v87 installés et validés
sur Galaxy A16 : « Oui, AOE-002-FIX1 validée ».
Clôture documentaire uniquement : code et APK identiques à la recette validée.
Commit local puis sauvegarde complète restaurée/vérifiée. Aucun push automatique.

## Comportement

Incantation de 3 s, accélérable par Booster. Chute accélérée de 30 % par rapport à
AOE-002 : 1 / 1,3 s (environ 0,77 s de temps de combat), puis explosion de 1 s.
Le point fixé au début du cast ne bouge pas. Les 40 PM et la recharge de 4 s sont
engagés au lancement. Les ennemis présents au début de l’explosion, dans un rayon
de 1,4, perdent chacun 40 PV sans réduction de défense ; dégâts effectifs plafonnés
aux PV restants, aucun dégât allié.

Pendant l’incantation uniquement, contrôle aux échéances 0,5 s, 1 s, etc., en temps
de combat, pause exclue et indépendamment de Booster. Si aucun ennemi vivant dans
le disque fixé, annuler immédiatement sans paiement, recharge ou récupération
imposée. Puis réévaluer les gambits ; un autre groupe valide peut produire une
nouvelle incantation vers un autre centre. Un seul ennemi suffit à poursuivre le
cast déjà commencé. Les alliés et les morts ne comptent pas. Un nouveau cast remet
son échéancier à zéro. Après lancement, aucune annulation parce que la zone se vide.

## Présentation retenue

- Chute : roche irrégulière tournante, flammes rouges turbulentes, cœur orange,
  quelques fins filets rose profond. Rendu de chute approuvé dans Godot.
- Explosion : Flash compact blanc en demi-sphère, expansion rapide et fondu commun.
  Rouge accentué : opacité du dôme 0,78, volutes 0,90, largeur ×1,50.
- C Avec braises : onde rouge étendue au rayon AOE en 0,28 s, courte couronne de
  flammes basse et irrégulière, 18 braises supplémentaires projetées. Blanc dominant
  conservé. Fragments et étincelles existants conservés.

Le laboratoire propose A Onde rouge, B Enflammée et C Avec braises sur la même base.
C est le défaut du laboratoire et du jeu. Il conserve les scénarios groupe stable,
soin prioritaire et zone vidée ; aucune sauvegarde du joueur n’est modifiée.

## Architecture

Le contrôle de zone appartient à PartyExecutor. L’effet ne consulte aucune cible.
Le cumul utilise le delta de combat et s’arrête à la fin du temps de cast courant.
Le journal indique « zone vide ». L’énergie d’incantation, l’indicateur AOE et les
animations suivent l’annulation existante. La fiche d’Anne décrit le nouveau délai.

L’art reste isolé dans MeteorEffect, ses shaders et MeteorDefinition : intensités,
largeur des volutes, densité du dôme et style de feu remplaçables sans logique de jeu.
La roche et les flammes utilisent un bruit procédural. Le dôme et les volutes sont
des maillages statiques animés par transformation et couleur. Un quad pour l’onde,
une couronne statique et au plus 18 braises supplémentaires par effet. Huit effets
maximum, nettoyage existant au reset et après explosion. Aucun shader n’utilise
TIME : les animations ne changent pas lorsque le temps visuel accepté vaut zéro.

## Vérifications

77 scènes / 5 773 contrôles consolidés. Le premier passage du nouveau banc avait
une attente erronée : un groupe déplacé entier reste valide ailleurs. L’attente a
été corrigée, puis le banc a passé ses 21 contrôles. Derniers contrôles sur la
version retenue : AOE gameplay 70/70, Météore 17/17, annulation 21/21 (108 au total),
sans erreur ou avertissement moteur.

Couverture : échéances et répétition, pause, Booster, un seul ennemi, morts et alliés
ignorés, rayon inclusif, nouveau cast, absence de paiement/recharge, réévaluation des
gambits, journal, impacts différés et absence de nœuds orphelins. Les tests de l’ancien
contrat n’ont été adaptés que pour le cast vide et la nouvelle durée de chute.
Captures GPU des trois variantes et aperçu interactif vérifiés ; C validé dans Godot.
Pas de nouveau relevé FPS. Validation Android obtenue ; gambits, composition
d’équipe et réglages identiques avant/après installation, vérifiés par empreinte.

## APK validés

- aoe-002-fix1-debug.apk : `069a684f7d40d18e6b34b2b2f0b34d5fcf2b0e8246d8d9d134889a77f0b7ba8f`
- aoe-002-fix1-lab-debug.apk : `1f3d16542c5df64367527df859edcdc143e541d7f2c066d6b1ffdd05f2e3608c`
