# GAMEPLAY-001-fix1 — auto-soin et débit de mana à la résolution

Correctif demandé par le propriétaire avant validation de GAMEPLAY-001 ; il sera inclus
dans le commit de cette étape. Dernier checkpoint : GRAPHICS-003 / 7956cfce2efcdaf4b95fd3f0631193cb9d442589.
Livraison initiale remplacée : archive c2c97755fc3a65dc15d611c212ec94f612dd78c05b42b8fcab5b5a215435eed2,
APK 0.1.0-gameplay001 (32). Travail isolé dans /tmp/gambit-gameplay001-fix1-work.

## Corrections

La cible Allié inclut maintenant Anne. Le soin automatique utilise le seuil strict configuré
(PV < 50 % par défaut) pour chaque membre, puis choisit le plus bas pourcentage de PV.
Égalité : distance puis identité. Le soin manuel choisit le même ordre parmi tous les
membres blessés, sans seuil imposé. Une Anne à moins de 50 % peut donc se soigner même
si Mako est indemne ; si les deux sont blessés, le plus faible ratio est prioritaire.
L'éditeur indique « Allié (soi inclus) ». Les règles sauvegardées en version 2 sont conservées.

Soin et Foudre ne dépensent aucune mana pendant l'incantation. Le débit a lieu une seule
fois, dans la résolution réelle, après validation des participants, de la portée et de
la mana disponible, avant les signaux de santé. Une cible morte, retirée, remplacée ou
hors de portée ne coûte rien ; une mort du lanceur, une annulation ou un soin devenu
inutile non plus. Aucun remboursement artificiel n'est nécessaire. La régénération
normale continue selon le temps de jeu ; les tests d'annulation la neutralisent pour
isoler le débit. Le cooldown garde son déclenchement à l'engagement de l'action.

## Vérifications

Godot 4.7.2.stable.official.ed1daf0bf. **32 bancs, 1 959 contrôles, zéro échec et aucun
warning/erreur dans la campagne headless.** Le nouveau banc party_fix1_tests.tscn apporte
38 contrôles : Anne sous le seuil, frontière 50 %, priorité par ratio, auto-soin réel,
soin manuel et ciblage de Mako, coûts avant/après effet, garde contre la réentrance et
les doubles impacts, annulations pour les deux sorts et revalidation de la mana.
Les attentes de deux bancs existants sont actualisées pour le débit tardif.

Contrôle en fenêtre du vrai Main : Anne à 40/140 PV lance sur elle-même avec 60 mana,
puis atteint 70/140 PV et dépense exactement 20 mana à l'effet ; après quelques ticks
la mana est 40,25 par régénération normale. Aucun nœud orphelin après fermeture.
Éditeur « Allié (soi inclus) » et barre d'incantation inspectés visuellement.

APK signé/exporté et installé sur Galaxy A16 en conservant les données de l'application.
Version 0.1.0-gameplay001-fix1, code 33. Pas de nouvelle campagne FPS.
APK : /tmp/gameplay-001-fix1-debug.apk — 37 297 869 octets.
SHA-256 : 76bfa8a26bc93863b8f19122cd36bed360cbeb4f276fdc7667b1844a2f27290d.

## Recette utilisateur

Rejouer, observer Anne sous le seuil et vérifier qu'elle peut se soigner. Blesser les deux
héros en combat et vérifier la priorité au plus faible ratio. Pendant Soin/Foudre, la
mana ne baisse pas ; elle baisse à l'effet. Si la cible meurt avant la fin, la barre de
sort disparaît sans débit. Vérifier aussi les commandes manuelles, pause/reprise et Rejouer.
F6 : scenes/tests/party_fix1_tests.tscn pour reproduire les cas contrôlés, puis F8/F5.

GAMEPLAY-001 reste en recette, sans commit/push du chantier gameplay. Fix1 corrige cette
étape avant sa validation ; les statistiques et les étapes graphiques suivantes restent
celles du plan actuel. Voir ../party-gameplay.md pour le contrat actif.

## Validation du propriétaire

« Steps validée. » : GAMEPLAY-001 et son correctif fix1 sont validés.
Les fichiers non documentaires ont été vérifiés identiques à la livraison fix1.
Clôture par un commit unique GAMEPLAY-001, correctif inclus ; sauvegarde à créer et vérifier.
