# Nassau et ordre de l’équipe — roadmap en deux étapes

Statut : TEAM-001 validée sur Android le 30 octobre 2026 ; TEAM-002 non commencée,
en attente du prochain GO.
Base : MATERIALS-001 clôturée, commit 7493296cce1f589096012ff6ad5e761497638a1a.
Date : 30 octobre 2026.

## Demande et ressources

Ajouter Nassau, pirate, avec Attaque et Booster ; retirer Booster de Mako.
Conserver Foudre pour Mako, Soin pour Anne et les règles actuelles des compétences.
Fichiers fournis :
- /home/arkhane/Downloads/Pirate kit-glb/Pirate Captain.glb
- /home/arkhane/Downloads/Nassau_540x960.png

Le GLB contient les clips Idle, Walk, Sword, Duck, HitReact et Death compatibles avec
les conventions actuelles. Son atlas PNG est embarqué. L’import réel Godot devra
confirmer le squelette, l’orientation, les matériaux et le calage du contact Sword.
Les fichiers fournis restent intacts, avec leur provenance. Nassau reçoit le profil
C Peint contrasté déjà validé. Le PNG est son illustration de héros, pas une arène.

## TEAM-001 — Nassau, transfert de Booster et formation ordonnée

### Données et architecture

Remplacer les listes Mako/Anne codées en dur par un catalogue logique de héros et
une composition d’équipe de quatre emplacements. Les ressources artistiques gardent
leur catalogue de présentation séparé. Une composition contient des identifiants
stables ou un emplacement vide ; ni doublon ni perte de héros lors d’un échange.

Composition initiale : Mako, Anne, Nassau, Vide. Lecture en grille 2×2 :
haut-gauche, haut-droite, bas-gauche, bas-droite.
Cette composition alimente Équipe, les fiches et gambits par identifiant, les panneaux
de combat, l’ordre du critère Allié et la formation de départ. La simulation reçoit
un instantané de composition au lancement du combat. La sauvegarde des gambits
reste attachée à l’identifiant du héros, jamais à son numéro de case.
Préparer dès cette étape le stockage persistant de la composition, initialisé avec
ces quatre emplacements pour les anciennes sauvegardes.

### Nassau et Booster

Ajouter le profil de Nassau, sa fiche de référence et ses compétences :
Attaque et Booster. Mako conserve Attaque et Foudre, Anne Attaque et Soin.
Nassau reçoit par défaut Allié → Booster en premier, puis Ennemi proche → Attaque.
Avec cette composition, Allié → Booster cible Mako, puis Anne, puis Nassau lui-même,
en ignorant les membres déjà buffés ; le nouvel ordre de l’équipe changera cet ordre.
Booster garde 20 PM, 1,5 s d’incantation, +30 % pendant 60 s et la montre validée.

Migrer les anciennes configurations sans réinitialiser les gambits existants :
ajouter Nassau, retirer la capacité Booster de Mako et traiter ses lignes Booster
en transférant ses lignes Booster vers Nassau, choix confirmé par le propriétaire.
Conserver une copie de la configuration
d’origine, appliquer une migration atomique et ne pas la répéter aux relances.
En cas de transfert, garder ordre relatif et états actif/inactif ; les lignes
transférées remplacent le Booster par défaut de Nassau. Ajouter son attaque de repli
seulement si la limite de 100 lignes le permet. Aucune ligne utilisateur perdue.

### Présentation et placement

Ajouter l’illustration 2D et le petit cadre 3D Idle décalé dans la carte Équipe de
Nassau, avec cadrages propres au héros, sans agrandir les cadres pour l’image.
Ajouter son portrait dans le troisième panneau de combat, ses barres, ses buffs
horizontaux, ses statistiques et ses entrées du journal. Les effets existants,
le gabarit au sol et le matériau mat s’appliquent aussi à Nassau.

Au lancement/Rejouer, placer les héros sur une ligne horizontale à l’écran au bas
de l’octogone commun, de gauche à droite dans l’ordre de l’équipe. Tenir compte
du rayon des modèles et conserver une marge physique avec le bord. Les ennemis
restent au nord. Ne pas repositionner les héros entre les vagues : leurs positions,
PV, PM et buffs restent conservés conformément au mode Infini.

Conserver strictement le style approuvé des cartes occupées : illustration dans son
cadre fin rectangulaire or et petite fenêtre Idle décalée. Ne pas leur ajouter de
panneau arrondi ni modifier leur cadrage. Appliquer aux cartes vides ce même cadre
fin, aux mêmes dimensions que l’illustration, avec Vide sur fond bleu nuit translucide.
Les panneaux de combat conservent leur style existant.

### Recette et arrêt de l’étape

Vérifier le troisième héros dans tous les parcours, les animations et matériaux,
le ciblage Allié avec trois membres, la migration et les limites à 100 gambits,
la suppression effective de Booster chez Mako, la séquence de buffs de Nassau,
les trois positions de départ, les dix décors et la conservation entre vagues.
Présenter les cadrages et la ligne de départ dans Godot puis installer sur Android.
Attendre validation du propriétaire avant clôture/commit/sauvegarde.

## TEAM-002 — Échanger les cartes par appui long et glisser-déposer

Ajouter un geste commun souris/tactile aux quatre cartes Équipe :
- clic bref sur un héros : ouvrir sa fiche comme aujourd’hui ;
- appui long proposé d’environ 450 ms : saisir la carte, sans ouvrir la fiche ;
- déplacement : aperçu léger de la carte et contour or sur la destination ;
- relâchement sur une autre case : échanger exactement les deux contenus ;
- relâchement hors des cases, retour Android ou perte de focus : annuler le geste.

Une case vide est une vraie case d’échange. Le geste ne retire jamais un héros de
l’équipe et ne crée aucun doublon. Aucun clic de fiche ne doit être déclenché après
un glisser-déposer. Aucun surlignage persistant au retour d’une fiche.
Le fantôme du geste utilise l’illustration ; éviter de créer un nouveau viewport
3D pour suivre le doigt. Les cadres Idle gardent leurs dimensions et animations.

Sauvegarder immédiatement chaque échange réussi, sans Appliquer/Annuler, et
publier le nouvel ordre seulement si la sauvegarde réussit. En cas d’erreur, garder
la composition précédente et afficher un retour concis. Relire la même composition
au retour sur Équipe et après relance. L’ordre s’applique au prochain combat :
formation, panneaux et critère Allié suivent tous le même instantané.
Le tri des statistiques par dégâts reste celui déjà validé ; les gambits, PV de
référence et compétences restent liés à chaque identifiant de héros.

Recette : échanges héros/héros, héros/vide et vide/héros, échanges répétés,
clic court, seuil d’appui long, relâchement hors zone, perte de focus/retour,
rechargement de la sauvegarde, absence de fiche ouverte après déplacement,
correspondance entre équipe/panneaux/positions/ciblage Allié. Validation Godot et
tactile Galaxy A16, puis clôture/commit/sauvegarde.

## Choix confirmés par le propriétaire

1. Statistiques de Nassau : 160 PV, 60 PM, attaque 14, défense 4,
   vitesse 1,2 et régénération de 5 PM/s.
2. Transférer les lignes Booster de Mako vers Nassau, dans leur ordre relatif et
   avec leur état actif/inactif ; conserver une copie de la configuration d’origine.
3. Quatre positions de départ fixes ; une case vide garde sa place sur la ligne.

L’ajout et le réordonnancement constituent exactement les deux étapes demandées.
UI-005, qualification intégrée, et STEP-029/030 restent planifiés ensuite.
