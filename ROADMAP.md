# Roadmap — Gambit Arena

La roadmap détaillée a été validée par l'utilisateur dans la conversation
de lancement. Ce fichier en constitue le registre opérationnel initial.

## Périmètre MVP

Android portrait, arène fixe en sprites 2D dimétriques non pixel art,
un héros automatiquement mobile, un type d'ennemi, combat et vagues,
trois gambits configurables, six emplacements manuels dont trois actifs,
pause, défaite et redémarrage.

Exclus : équipe, multijoueur, backend, déplacement manuel, pathfinding
complexe, décor bloquant, progression persistante et publication en boutique.

## Choix de départ approuvés

- Godot 4.7.2 standard ; rendu Compatibility.
- Référence proposée : 540 × 960.
- Taille apparente des acteurs à comparer : 48, 64 et 80 pixels.
- Vue dimétrique 2:1 ; coordonnées logiques au sol.
- Quatre directions temporaires ; Idle, Move, Attack, Hit et Death.
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
| STEP-028 | 12. Performance | Mesures reproductibles et budget matériel respecté |
| STEP-029 | 13. Livraison | Clone propre, import, export et installation reproductibles |
| STEP-030 | 13. Livraison | Recette finale du MVP validée sur l'APK identifié |

## Statuts

- STEP-001 : validée et anciennement commitée — 6583515 (historique perdu).
- STEP-002 : validée et anciennement commitée — 5b9baac (historique perdu).
- STEP-003 : validée après correctif ; aucun commit confirmé avant suppression.
- RECOVERY-001 : Validée, commit en attente — restauration fonctionnelle confirmée
  par l’utilisateur le 22 octobre 2026.
- STEP-004 à STEP-030 : À faire.

Les hashes ci-dessus attestent les anciens retours utilisateur ; ils ne sont
pas disponibles dans un dépôt reconstruit. Aucun historique n'est simulé.
Voir [la reprise](docs/recovery.md) et [les sauvegardes](docs/backup.md).

## Chemin critique et jalons Android

- STEP-004 : prototype technique sur téléphone.
- STEP-005 : lisibilité des animations.
- STEP-012 : premier combat jouable sur téléphone.
- STEP-018 : cœur stratégique et diagnostics.
- STEP-020 à STEP-023 : ergonomie tactile.
- STEP-026 : boucle de partie complète.
- STEP-027 à STEP-030 : robustesse, performance et livraison.

## Risques principaux

Sprites trop petits ; mémoire des animations ; confusion entre coordonnées
logiques et affichées ; tri visuel ; oscillations à portée ; blocage par
séparation ; ciblage instable ; effets ou coûts doublés ; priorité manuelle ;
ergonomie de l'éditeur ; compatibilité de l'export ; chauffe du téléphone.

La validation matérielle précoce et les tests ciblés des actions et gambits
doivent précéder toute optimisation ou extension de périmètre.

## Documentation par étape

Chaque étape possède docs/steps/STEP-XXX.md, rédigé au moment de sa livraison :
objectif, périmètre, dépendances, décisions, fichiers, installation,
comportement, limites, vérifications, tests manuels, critères et commit.

ROADMAP.md et PROJECT_STATUS.md évoluent à chaque étape.
README.md et ARCHITECTURE.md décrivent uniquement le projet réel.
Les autres documents sont créés lorsqu'ils ont un contenu utile.

## Conventions Git

Une étape validée = un commit incluant sa documentation.
Le message contient [STEP-XXX]. Aucun hash n'est inventé.

Statuts : À faire, En cours, En attente de validation,
Validée, commit en attente, Bloquée.

Avant commit : validation utilisateur consignée et statut
« Validée, commit en attente ». La présence du commit établit la clôture.
Le statut précédent est actualisé dans le commit de l'étape suivante.
Aucun amendement ou commit dédié uniquement à l'ajout d'un hash.

Une correction après clôture reçoit un nouvel ID stable.
Aucune nouvelle étape ne commence sans feu vert explicite.

## Prochaine action

Initialiser le nouveau dépôt, vérifier les fichiers préparés et créer le commit
de reprise RECOVERY-001, dont la restauration est validée. Produire ensuite la
sauvegarde complète avec history.bundle et transmettre son archive. STEP-004 attend
cette clôture et un nouveau feu vert. Les validations fonctionnelles antérieures
restent consignées ; elles ne remplacent pas le contrôle de la copie restaurée.

## État de l'annexe

Le fichier transmis le 21 octobre 2026 contient le titre ci-dessous, mais aucun
texte d'annexe. Le registre des 30 étapes ci-dessus est conservé intégralement.
La proposition détaillée validée reste dans la conversation de lancement ;
son contenu n'est pas encore archivé dans ce fichier. Cette lacune documentaire
est distincte de l'avancement technique de STEP-002.

## Proposition détaillée validée
