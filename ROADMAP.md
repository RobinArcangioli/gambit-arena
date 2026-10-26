# Roadmap — Gambit Arena

La roadmap détaillée a été validée par l'utilisateur dans la conversation
de lancement. Ce fichier en constitue le registre opérationnel initial.

## Périmètre MVP

Android portrait, arène fixe avec personnages 3D sur fond 2D isométrique,
un héros automatiquement mobile, un type d'ennemi, combat et vagues,
trois gambits configurables, six emplacements manuels dont trois actifs,
pause, défaite et redémarrage.

Exclus : équipe, multijoueur, backend, déplacement manuel, pathfinding
complexe, décor bloquant, progression persistante et publication en boutique.

## Choix de départ approuvés

- Godot 4.7.2 standard ; rendu Compatibility.
- Référence proposée : 540 × 960.
- Taille apparente retenue après STEP-004 : 48 pixels de référence.
  Comparaison 48/64/80 effectuée ; ajustement possible avec les vrais assets.
- Vue dimétrique 2:1 ; coordonnées logiques au sol.
- Idle, Move, Attack, Hit et Death restent les états visuels cibles.
- Les quatre directions en sprites de STEP-005 décrivent le prototype historique ;
  elles ne contraignent pas la future orientation des personnages 3D.
- Évaluation initiale des gambits à 10 Hz.
- Plafond initial : 20 ennemis vivants.
- Objectif provisoire : 30 images/s soutenues sur le téléphone de référence.
- Gambits conservés au redémarrage de partie, sans sauvegarde persistante.
- Une commande manuelle en attente, remplaçable, valide trois secondes
  de temps de jeu ; aucune interruption d'une action engagée.

Les valeurs visuelles et de performance seront confirmées sur appareil.
Elles ne sont pas des résultats déjà mesurés.

## Registre chronologique

Chaque étape dépend de la clôture de la précédente, sauf STEP-001,
qui dépend de la validation de la roadmap.

| ID | Phase | Livrable et acceptation principale |
|---|---|---|
| STEP-001 | 1. Initialisation | Projet minimal lançable, Git et documentation |
| STEP-002 | 1. Initialisation | Prérequis Android documentés, téléphone autorisé dans ADB |
| STEP-003 | 2. Prototype | Projection et inverse cohérentes, sprites mobiles triés aux pieds |
| STEP-004 | 2. Prototype | APK installé : mobilité, tri, taille et bouton tactile vérifiés |
| STEP-005 | 3. Assets | Deux acteurs temporaires, cinq animations, ancrages et licences |
| STEP-006 | 4. Arène | Arène fixe lisible, limites et réservations pour l'interface |
| STEP-007 | 5. Déplacement | Approche A puis B, arrêt sans cible, vitesse et limites cohérentes |
| STEP-008 | 5. Déplacement | Ennemis apparaissant aux côtés et poursuivant le héros |
| STEP-009 | 5. Déplacement | Séparation bornée, encerclement et blocage sans téléportation |
| STEP-010 | 6. Combat | Statistiques et PV isolés entre instances |
| STEP-011 | 6. Combat | Action identifiée, impact unique, portée et mort respectées |
| STEP-012 | 6. Combat | Premier combat autonome complet contre plusieurs ennemis |
| STEP-013 | 7. Compétences | Exécuteur partagé, coûts et cooldowns appliqués une seule fois |
| STEP-014 | 7. Compétences | Attaque, soin et spéciale fonctionnels, ressource récupérable |
| STEP-015 | 7. Compétences | Pause commune et interruption par la mort sans effet tardif |
| STEP-016 | 8. Gambits | Évaluateur déterministe sans effet de bord |
| STEP-017 | 8. Gambits | Intentions pilotant seules le héros ; contrôleur temporaire retiré |
| STEP-018 | 8. Gambits | Diagnostics bornés et scénarios de règles reproductibles |
| STEP-019 | 9. Éditeur | Trois règles visibles, activables et réordonnables au toucher |
| STEP-020 | 9. Éditeur | Cible, condition, seuil et action éditables avec validation |
| STEP-021 | 10. Interface | HUD portrait lisible et adapté aux zones de sécurité |
| STEP-022 | 10. Interface | Six emplacements, trois compétences, états disponibles visibles |
| STEP-023 | 10. Interface | Commande manuelle prioritaire, attente bornée et revalidation |
| STEP-024 | 11. Partie | Vague progressive, fin correcte et plafond simultané |
| STEP-025 | 11. Partie | Enchaînement de trois vagues et compteurs exacts |
| STEP-026 | 11. Partie | Défaite et dix redémarrages sans résidus |
| STEP-027 | 12. Robustesse | Pause, arrière-plan, verrouillage et retour Android cohérents |
| STEP-028 | 12. Performance | Mesures reproductibles et décision produit sur le budget matériel |
| STEP-029 | 13. Livraison | Clone propre, import, export et installation reproductibles |
| STEP-030 | 13. Livraison | Recette finale du MVP validée sur l'APK identifié |

## Statuts

- STEP-001 : validée et anciennement commitée — 6583515 (historique perdu).
- STEP-002 : validée et anciennement commitée — 5b9baac (historique perdu).
- STEP-003 : validée après correctif ; aucun commit confirmé avant suppression.
- RECOVERY-001 : validée et commitée — 6282d81 ; sauvegarde avec bundle reçue et vérifiée.
- STEP-004 : validée et commitée — 491cde8 ; sauvegarde reçue et vérifiée.
- STEP-005 : validée et commitée — 44f81d5 ; sauvegarde reçue et vérifiée.
- TRANSITION-001 : validée et commitée — 056a464 ; sauvegarde reçue et vérifiée.
- STEP-006 : validée et commitée — 1cc7f05 ; sauvegarde reçue et vérifiée.
- STEP-007 : validée et commitée — 9b3240c ; sauvegarde reçue et vérifiée.
- STEP-008 : validée et commitée — 46dfaa7 ; sauvegarde reçue et vérifiée.
- STEP-009 : validée et commitée — ec576ce ; sauvegarde reçue et vérifiée.
- STEP-010 : validée et commitée — ba56209 ; sauvegarde reçue et vérifiée.
- STEP-011 : validée et commitée — 3633927 ; sauvegarde reçue et vérifiée.
- STEP-012 : validée et commitée — 9725f5d ; sauvegarde reçue et vérifiée.
- STEP-013 : validée et commitée — 1ffd24a ; sauvegarde reçue et vérifiée.
- STEP-014 : validée et commitée — 5c39ac2, validation 4f4244c ; sauvegarde vérifiée.
- STEP-015 : validée et commitée — dd9fec8 ; sauvegarde reçue et vérifiée.
- STEP-016 : validée et commitée — 1da833e ; sauvegarde reçue et vérifiée.
- STEP-017 : validée et commitée — 5b2bc4d ; sauvegarde reçue et vérifiée.
- STEP-018 : validée et commitée — 4719e8d ; sauvegarde reçue et vérifiée.
- STEP-019 : validée et commitée — 4125d44 ; sauvegarde reçue et vérifiée, correctif inclus.
- STEP-020 : validée et commitée — ac58190 ; sauvegarde reçue et vérifiée.
- STEP-021 : validée et commitée — 9491d40 ; sauvegarde reçue et vérifiée, correctif inclus.
- STEP-022 : validée et commitée — 307e8c6 ; sauvegarde reçue et vérifiée.
- STEP-023 : validée et commitée — 7579504 ; sauvegarde vérifiée ; swipe traité dans STEP-024.
- STEP-024 : validée et commitée — 89ae0f6 ; sauvegarde reçue et vérifiée, correctifs inclus.
- STEP-025 : validée et commitée — f62162d ; fix1 inclus, sauvegarde reçue et vérifiée.
- STEP-026 : validée et commitée — 344a584 ; sauvegarde reçue et vérifiée.
- STEP-027 : validée et commitée — 665c0c8 ; sauvegarde reçue et vérifiée.
- STEP-028 : validée explicitement par l'utilisateur ; F6, F5, tactile Android et pause/reprise
  OK. L'ancien seuil 30 FPS Debug n'est pas atteint, mais la décision produit l'accepte pour le
  périmètre réel et 20 ennemis reste un stress test. Commit et sauvegarde en attente.
  Voir docs/steps/STEP-028.md.
- STEP-029 et STEP-030 : À faire.

Les anciens hashes STEP-001/002 attestent les retours utilisateur ; leurs objets
sont perdus. Le nouveau commit 6282d81 est disponible et sauvegardé.
STEP-003 validée est incluse dans ce commit de reprise.
Voir [la reprise](docs/recovery.md) et [les sauvegardes](docs/backup.md).

## Situation de passation

HANDOFF-001 documente l’état après STEP-027, sans nouvelle étape fonctionnelle.
Commit documentaire cc91c79 et main GitHub vérifiés le 26 octobre 2026.
Voir [HANDOFF.md](HANDOFF.md) et [la procédure GitHub](docs/handoff/GITHUB.md).

## Étapes restantes

Le propriétaire a demandé de préparer un chantier graphique avant la livraison finale :
voir la [roadmap graphique GRAPHICS-001 à GRAPHICS-007](docs/graphics-roadmap.md).
Elle prévoit d'abord les arènes interchangeables, puis les personnages 3D et les actions
attaque, soin et Foudre, avec une couche de présentation isolée du gameplay. Plan validé et
GRAPHICS-001 clôturée localement (f5a790d), GRAPHICS-002 validée avec commit autorisé. STEP-029 et STEP-030 conservent
leurs identifiants et se dérouleront après ce chantier.

| Étape | État | Livrable |
|---|---|---|
| STEP-028 | Clôturée — 580ce64, poussée et sauvegarde vérifiée | Mesures reproductibles sur téléphone ; objectif historique 30 FPS non atteint en Debug, accepté pour le périmètre prévu |
| GRAPHICS-001 | Validée, commit local f5a790d et sauvegarde vérifiée | Colisée et référence interchangeables, galerie et contrat de présentation |
| GRAPHICS-002 | Clôturée localement — 1e42756, sauvegarde vérifiée | Catalogue des huit arènes fournies |
| GRAPHICS-003 | Clôturée localement — 7956cfc, sauvegarde vérifiée | Anne, Mako et deux squelettes : modèles 3D et animation de base |
| GAMEPLAY-001 | Clôturée localement — b1dfb33, sauvegarde vérifiée | Équipe Anne/Mako, compétences propres, soin ciblé et gambit Allié < 50 % PV ; voir docs/party-skills-plan.md |
| GRAPHICS-004 | Clôturée localement — 074f971, sauvegarde vérifiée | Attaque, réaction, mort et priorités des actions ; Duck pour les sorts |
| GRAPHICS-005 | Clôturée localement — bf4904d, sauvegarde vérifiée | Halo de soin, valeur rendue, profil remplaçable et cycle de vie |
| GRAPHICS-006 | Clôturée localement — 834f532, sauvegarde vérifiée | Éclair descendant et glow, préparation et impact sur cible réelle |
| GRAPHICS-007 | Validée — clôture autorisée | Qualification graphique et facilité de remplacement |
| STEP-029 | À faire | Clone neuf, import, export et installation reproductibles |
| STEP-030 | À faire | Recette finale MVP sur APK identifié |

Le [plan détaillé proposé](docs/handoff/NEXT_STEPS.md) prépare ces étapes ; il ne prétend
ni les implémenter ni remplacer leur autorisation. « Fluidité OK » ne prouve pas un budget
matériel mesuré. La publication initiale du dépôt ne remplace pas la recette STEP-029.

## Conventions et risques

Une étape validée est commitée avec sa documentation, puis sauvegardée et vérifiée avant GO.
Le hash d’un commit est consigné à l’étape suivante, sans amendement circulaire. Les recettes
historiques peuvent donc mentionner « commit en attente » ; le présent registre et Git
font foi pour l’état courant. Correctifs et changements de direction restent documentés.

Préserver ciblage vivant à portée, impact/coût uniques, immobilité à portée, swipe tactile,
compteurs des trois vagues, fin/replay et reprise explicite Android. Les modèles/animations
finaux, l’équilibrage et la mesure matérielle ne sont pas acquis. Voir la passation.

## Limite du document initial

Le fichier transmis au lancement contenait un titre d’annexe sans son texte détaillé.
Le registre des 30 étapes ci-dessus est conservé. Ne pas inventer l’annexe manquante.
Le choix du 22 octobre 2026 remplace les sprites par des personnages 3D sur fond 2D :
TRANSITION-001 a été insérée après STEP-005 et avant STEP-006. Les anciens laboratoires
2D restent historiques ; la production d’assets 3D définitifs n’a pas été réalisée.
