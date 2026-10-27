# BUFFS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour Booster dans les compétences et les
Gambits de Mako : 20 mana, cast 1,5 s, ×1,30 pendant 60 s de combat normal, aucune
recharge dédiée, sans cumul ni renouvellement. Allié cible Mako puis Anne en ignorant
les porteurs du même buff ; mana insuffisante → gambit suivant. Débit au succès réel.
57 bancs / 3 849 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, profils, configuration, assets et APK
restent identiques à la livraison validée. Aucun nouveau test moteur nécessaire.
Gambits du téléphone conservés ; laboratoire isolé disponible pour la séquence complète.
APK normal 0.1.0-buffs002 (56), SHA-256
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK laboratoire 0.1.0-buffs002-lab (56), SHA-256
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GRAPHICS-010,
montre dorée procédurale et fondu partagé avec le soin, puis UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-002 — Booster jouable via les gambits — en recette

Base clôturée : BUFFS-001 `eac9a39eb14c040dde5d3fc4a3477809d8a4829b`, 727 fichiers vérifiés.
Le GO autorise cette intégration de Booster ; sa montre et le fondu commun attendent
GRAPHICS-010. Le sort utilise déjà Duck et les barres d'incantation existantes.

## Règles livrées

Mako possède Attaque, Foudre, Booster ; Anne conserve Attaque, Soin. Références :
20 mana, 1,5 s de cast, portée 4 unités, récupération de 0,4 s de temps personnel,
aucune recharge dédiée. Effet ×1,30 pendant 60 s du temps normal du combat. Attaques,
incantations, récupération, recharges, mouvement et modèles suivent ce temps personnel ;
la régénération de mana ne change pas. Les 60 s et la pause restent ceux de BUFFS-001.
Aucun cumul ni renouvellement tant que le même buff est actif.

Le critère continue de produire son classement. Seuls les buffs filtrent ensuite les
candidats déjà porteurs du même buff avant de choisir le premier. Cela vaut pour les onze
critères : Soi-même, Allié, seuils de PV alliés et critères ennemis. Le lanceur est un allié,
Mako précède Anne dans le roster. Un autre buff n'exclut pas la cible. Booster peut être
lancé sur un ennemi ; aucun camp imposé par la capacité. Si tous les candidats portent
Booster, ou si la mana est inférieure à 20, le gambit suivant est évalué normalement.
Les soins conservent leur sélection précédente : aucun report automatique vers un autre
allié blessé quand le premier candidat d'Allié sans condition a ses PV pleins.

L'engagement vérifie acteur/cible vivants, capacité possédée, portée, mana et buff absent.
La résolution revalide l'identité des états, le même conteneur de buffs cible, la portée,
la mana et l'absence du buff. La mutation du buff et le débit sont synchrones, sans callback
intermédiaire. Si la cible est morte, remplacée, sortie de portée, devenue buffée entre-temps,
ou si la mana manque à la résolution : aucun débit ni renouvellement. Des lancers concurrents
sur une même cible produisent une seule application et un seul paiement. L'action conserve
sa récupération habituelle après un impact devenu indisponible, comme les autres capacités.

Avec Allié → Booster en tête : Mako se buffe en environ 1,5 s, récupère en 0,4/1,30 s,
puis buffe Anne en 1,5/1,30 s. Quand les deux sont buffés, il peut poursuivre ses autres
ordres. À expiration, une cible redevient éligible ; aucun curseur de sélection persistant.
Le paiement suit chaque succès réel, même si le manque de mana fait temporairement passer
aux autres ordres. Les vagues et les autres acteurs restent sur leurs horloges prévues.

## Architecture et sauvegarde

`buff_catalog.gd` centralise la définition immuable de Booster et l'éligibilité par ID de
buff. Orders utilise les instantanés de valeurs pour filtrer les candidats. PartyExecutor
emploie la même règle à l'engagement et à la résolution, et applique le véritable état de
combat. Les profils restent séparés des modèles et les visuels ne déclenchent aucun effet.

Un événement distinct `buff_applied`, borné et composé de valeurs, est émis une seule fois
après application réussie : source/cible, action, run, buff ID, durée, facteur, positions et
temps de combat. Aucun événement de ce type sur annulation/doublon, aucun soin/dégât fictif.
Les faits start/resolve/end continuent de synchroniser l'action. GRAPHICS-010 utilisera
ce fait de succès pour la montre ; aucun VFX de remplacement n'est introduit ici.

Fiche de Mako : nom, description 30 % / 60 s / non-renouvellement / mana normale et valeurs
20 mana, 1,5 s, portée 4, recharge 0. L'éditeur propose Booster uniquement aux héros qui
possèdent la capacité, avec le style bleu nuit/or existant et sauvegarde immédiate.
Schéma v3 inchangé, aucune migration ou insertion silencieuse dans les ordres existants.
Les 0–100 gambits, associations libres et réglages d'Anne sont conservés. Les diagnostics
historiques conservent leur modèle v2 ; le catalogue de Mako leur présente la nouvelle capacité.

`booster_preset.gd` ajoute Allié → Booster avant les ordres reçus dans une copie détachée,
sans changer Anne ou les ordres suivants. Si le preset dépasserait 100 lignes, il est refusé
sans troncature. Il sert à la recette isolée, sans écrire dans la configuration du joueur.

## Recette propriétaire

F5 : Équipe → Mako → consulter Booster dans les compétences → Gambits. Ajouter ou modifier
un ordre, choisir Allié et Booster, le monter en première position. Revenir puis rouvrir
pour constater la sauvegarde immédiate. Entrer en arène : Duck et barre dorée pendant le
cast ; Mako puis Anne accélérés. La montre viendra dans GRAPHICS-010.

Pour une comparaison sans toucher aux ordres réels : F6
`scenes/debug/booster_lab.tscn`, F8 pour fermer. Le laboratoire utilise le vrai moteur,
les capacités du produit et le preset devant les ordres par défaut ; aucun buff injecté
ou temps d'expiration raccourci. Chemin isolé `user://buffs002_isolated_lab.json`.
Aucune apparition automatique : attendre les deux applications consignées en bas.
Les affichages donnent durée restante et mana. Repartir efface tout et rejoue la séquence ;
Mana 0 permet de constater l'absence d'attente forcée avant de passer aux autres ordres ;
Squelette fournit une cible pour ces ordres. Pause gèle le buff ; retour Android conserve
une reprise explicite. Attendre l'expiration réelle des 60 s pour voir la réapplication.

Export isolé : `python3 tools/export_booster_lab.py --godot <binaire> --output <chemin.apk>`.
Même package que le jeu ; installer temporairement le labo puis remettre l'APK normal.

## Vérification effectuée

57 scènes / 3 849 contrôles, zéro erreur/avertissement moteur. Nouveau banc
`scenes/tests/booster_tests.tscn` : 118 contrôles. Séquences réelles et expiration à
30/60/120 Hz, coûts 0/19/20, concurrent/répété, mort/cible/état remplacés, portée perdue,
mana perdue, pause, tous critères, buff différent, buff ennemi, absence de régression soin,
v3 et autosauvegarde, éditeur et fiche, 100 lignes et protection contre la 101e.
Les assertions de compétences historiques sont actualisées pour les trois capacités de Mako.

Aperçu GPU PC piloté : clip Duck et barre en cours, applications vers Mako à 1,53 s puis
Anne à 3,00 s au pas 1/60, 40 mana dépensés et deux états ×1,30, fiche sobre au style existant,
zéro nœud orphelin. Il ne s'agit pas d'une validation manuelle du propriétaire.
Sur le Galaxy A16, le laboratoire produit la même séquence à 1,53 s et 3,00 s.
La pause tactile donne deux captures identiques ; retour d’arrière-plan encore en pause.
L’APK normal est remis, les empreintes des deux APK installés sont vérifiées et les gambits
d’origine sont identiques octet pour octet. Rapports et captures joints à la livraison.
Aucun benchmark FPS supplémentaire.

APK normal 0.1.0-buffs002 (56), SHA-256 :
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK lab 0.1.0-buffs002-lab (56), SHA-256 :
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
Validation utilisateur, commit unique et sauvegarde vérifiée attendus avant GRAPHICS-010.
