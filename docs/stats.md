# Statistiques et PV — STEP-010

ActorProfile est une Resource de configuration : max_health, attack, defense,
move_speed. Les profils hero.tres et enemy.tres définissent respectivement
100/12/3/1,2 et 60/8/1/0,9. Ces valeurs sont provisoires, pas un équilibrage.

ActorState est un RefCounted neuf par acteur. Son constructeur copie les scalaires
et ne conserve aucune référence au profil. Le profil ennemi est volontairement
partagé entre A et B. Aucun état de partie n'est écrit dans une Resource .tres.
Les propriétés publiques sont en lecture ; les mutations passent par les méthodes.
Les champs préfixés _ sont internes par convention GDScript.

| Opération | Contrat |
|---|---|
| damage(n) | Dégâts finaux positifs, bornés aux PV restants ; retourne les PV retirés |
| heal(n) | Soin positif, borné aux PV manquants ; retourne les PV rendus |
| set_attack(n) | Modifie uniquement l'attaque de cette instance, bornée à 0…1 000 000 |
| alive | Vrai exactement lorsque health > 0 |
| health_changed | Une émission par variation effective des PV |
| died | Une émission au passage vivant → zéro ; aucune sur les appels suivants |
| stats_changed | Une émission par changement effectif d'attaque |

Les montants nuls ou négatifs sont ignorés. À zéro PV, dégâts et soins sont
sans effet : aucune résurrection implicite. Une nouvelle partie reconstruit les
états. PV maximum : 1…1 000 000 ; attaque/défense : 0…1 000 000 ; vitesse :
0…100, non finie ramenée à zéro. La défense n'est PAS soustraite par damage :
la formule d'attaque appartiendra à STEP-011, qui fournira le montant final.

StatsActor compose le mannequin et son ActorState. Le laboratoire instancie trois
StatsActor ; les anciennes scènes conservent leur comportement validé. Aucun
assemblage avec la poursuite ou le combat automatique à cette étape. La vitesse
est stockée, sans déplacer les mannequins de ce laboratoire. Un acteur mort est
masqué et son état reste consultable ; destruction/annulation des actions et
animation de mort ne sont pas implémentées ici.

La pause est un verrou du laboratoire : aucune commande de mutation ne passe.
ActorState ne dépend pas du temps, du rendu ou de la pause globale ; les futurs
appelants devront appliquer le même verrou. Rejouer recrée les trois acteurs,
nettoie les anciens par queue_free et conserve la pause. Réduction/verrouillage
activent la pause héritée de l'arène ; reprise explicite obligatoire.

## Validation

Tests manuels et F6 confirmés OK par l’utilisateur ; aucun doublon.
STEP-010 validée, commit en attente. Voir docs/steps/STEP-010.md.
