# Champs des gambits — STEP-020

Toucher le résumé d'une règle ouvre son brouillon et met le combat en pause.
Les boutons de champ parcourent les options ; rien n'est appliqué avant Appliquer.
Annuler ou Échap ferme sans modifier la règle. Appliquer et Annuler gardent la pause.
Le bouton Reprendre devient utilisable après fermeture, sans rattrapage du temps.

| Champ | Options | Validation et sens |
|---|---|---|
| Cible | Soi, Ennemi | Pas d'allié ou de groupe ajouté |
| Condition | Toujours, PV inférieurs au seuil | Porte sur la cible, pas systématiquement sur le héros |
| Seuil | Entier 0..100 % | -5/-1/+1/+5, borné, actif seulement pour PV < seuil |
| Action | Attaque, Soin, Spéciale | Soin nécessite Soi ; les attaques nécessitent Ennemi |

Un couple incompatible est permis dans le brouillon, affiche une explication et bloque
Appliquer. Aucun champ n'est corrigé silencieusement. Une règle inactive doit aussi être
valide. Les quatre champs sont validés ensemble ; échec = aucun changement, aucun signal.
Le modèle vérifie également les types, indices et clés, sans se fier uniquement à l'UI.

PV < seuil est strict : 50 % exacts ne satisfont pas PV < 50 %. À 0 %, aucune cible
vivante ne satisfait la condition ; à 100 %, seules les cibles blessées la satisfont.
Toujours ignore le seuil tout en conservant sa valeur pour un futur changement.
Soin/Toujours ne soigne toujours pas à PV pleins. Portée, coût et cooldowns restent vérifiés.

Appliquer remplace les champs de la ligne en conservant activation et priorité. Un
changement réel invalide l'intention en attente ; une action déjà engagée finit normalement.
Une sauvegarde inchangée n'émet pas changed et conserve l'intention. Annuler aussi.
Le brouillon, les règles stockées et les copies du contrôleur restent indépendants.

Le formulaire bloque les commandes du laboratoire, y compris les raccourcis de pause,
Rejouer et scénario. L'arrière-plan garde le formulaire et la pause ; Annuler/Appliquer,
puis Reprendre, restent nécessaires. Ordre et activation s'éditent hors formulaire.
Les valeurs survivent à Rejouer et scénario, mais pas à une nouvelle session F5.

Recette : docs/steps/STEP-020.md. F6, tests manuels et fluidité confirmés OK par l’utilisateur ; commit en attente.
