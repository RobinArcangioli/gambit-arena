# Effet de soin — GRAPHICS-005

Le geste Duck existant suit l'incantation de 1,5 s. Le halo de réussite apparaît uniquement
sur un événement `resolve`, `skill=heal`, `healing>0`, après le soin réel. Le nombre flottant
est la valeur effectivement rendue (par exemple +7 si seuls 7 PV manquaient). Engagement,
refus, annulation, PV pleins, cible morte ou hors de portée ne produisent pas de réussite.

## Remplacement de l'apparence

`resources/presentation/effects/heal.tres` porte la scène, la couleur, le rayon, la durée
visuelle (0,85 s) et la hauteur du nombre. Changer sa scène suffit à remplacer le graphisme.
La scène reçoit `setup(profile, healed)` puis `advance_visual(dt)` ; elle ne s'auto-anime pas.
Elle doit être un Node3D et fournir ces deux méthodes. Une scène absente ou sans ce contrat
est ignorée sans effet sur le combat. Le profil est exporté sur CombatPresenter.

`CharacterDefinition.heal_effect_origin` définit un décalage en unités du monde dans le
repère orienté du personnage (indépendant de l'échelle du GLB). Par défaut il vaut zéro :
l'effet part aux pieds. Le halo suit ensuite la position et l'orientation copiées de la cible
vivante. Sans vue de personnage, il utilise la position de résolution capturée.
La hauteur du nombre s'ajoute à cette origine ; les barres PV/mana/cast restent indépendantes.

## Budget et cycle de vie

Un anneau TorusMesh de 24 x 6 segments, quatre signes « + » et un Label3D de valeur.
Matériau unshaded, sans lumière dynamique, ombre ni shader personnalisé. Aucun asset externe.
L'opacité décroît après 40 % de la durée ; le rayon s'étend et les signes montent légèrement.
Maximum huit effets simultanés ; le plus ancien est retiré si ce plafond est atteint.

CombatPresenter reçoit uniquement des faits et des instantanés de présentation. Il filtre
les anciennes parties, déduplique les séquences et ne conserve aucune cible logique dans
un effet. La mort retire les effets de la cible. Rejouer et la désactivation des animations
nettoient les effets immédiatement ; la fermeture de la scène libère tous leurs enfants.
Le temps fourni est celui déjà accepté par l'application. Pause, arrière-plan et menus
figent halo et valeur ; fermer un menu laisse le jeu en pause. Le premier tick de retour
est rejeté. En fin de combat, la courte fin visuelle bornée existante termine aussi le halo.

## Recette

F6 : `scenes/debug/heal_lab.tscn`, bouton « Soin (demo) ». Cette galerie montre un exemple
+30 sur Anne, sans modifier de PV/mana. F8 puis F5 pour retrouver le vrai combat.
Sur Main : Anne peut soigner Mako ou elle-même ; manuel et gambit partagent le même effet.
Observer le halo au moment où les PV remontent et la mana est réellement débitée, puis
vérifier pause/reprise, menus et Rejouer. Le soin garde coût 20, cooldown 4 s, montant 30,
portée 4 et cible offensive mémorisée. Ces règles ne sont pas définies dans les ressources
visuelles. Les priorités Mort > Action > Marche > HitReact > Idle restent celles de GRAPHICS-004.
