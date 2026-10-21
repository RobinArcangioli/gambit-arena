# STEP-003 — Projection du sol et tri visuel

## Identification

- Phase : 2 — Prototype technique.
- Statut : Validée, commit en attente.
- Validation utilisateur reçue le 22 octobre 2026 après application du correctif 1.
- Dépendances : STEP-001 et STEP-002 clôturées ; base fournie 5b9baac.
- Godot cible : 4.7.2 standard, Compatibility.
- Complexité : moyenne.

## Objectif et périmètre

Fournir un laboratoire de projection avec sprites mobiles, croisements,
décor non bloquant, repères aux pieds et conversion inverse vérifiable.
Exclus : combat, collisions, gambits, vraie animation directionnelle,
commande tactile, APK et optimisation Android.

## Décisions

Deux espaces distincts ; conversion centralisée dans ground_projection.gd.
Tri natif vertical, même z_index, racines au sol, HUD séparé dans CanvasLayer.
SVG temporaires originaux : aucun téléchargement d'asset nécessaire.
Trajectoires programmées dans le laboratoire, pas de contrôleur du héros.
L'horloge locale dans _physics_process rend les durées indépendantes des images.
Elle ne constitue pas le système de pause global futur.

## Fichiers livrés

- scenes/main.tscn : conserve sa racine et son UID, instance le laboratoire.
- scenes/debug/projection_lab.tscn : hiérarchie statique et textes.
- scripts/world/ground_projection.gd : projection/inverse, sans état mutable.
- scripts/debug/projection_lab.gd : construction visuelle, mouvement de diagnostic,
  alternance des silhouettes, repères, contrôle numérique et affichage.
- assets/debug/actor.svg, actor_tall.svg, pillar.svg : textures temporaires.
- docs/coordinates.md : conventions, exemple numérique, hiérarchie, tri et limites.
- docs/assets.md : provenance, dimensions et import.
- README.md, ARCHITECTURE.md, ROADMAP.md, PROJECT_STATUS.md : suivi actualisé.
- docs/steps/STEP-003.md : présente fiche.

project.godot, export_presets.cfg, docs/android.md et les fiches antérieures
ne sont pas modifiés. Aucun nouveau réglage Android n'est ajouté.

## Installation

1. Fermer Godot pour éviter l'écrasement de scènes chargées.
2. Vérifier le dépôt propre sur main, dernier commit attendu 5b9baac.
3. Extraire step-003-livraison.tar.gz à la racine de ~/gambit-arena.
4. Ouvrir project.godot avec Godot 4.7.2 ; attendre l'import SVG/scripts.
5. Lancer F5 ; F8 arrête l'exécution.
6. La scène scenes/debug/projection_lab.tscn peut aussi se lancer avec F6.

Aucune manipulation de nœud ni modification manuelle de fichier n'est nécessaire.
Voir docs/coordinates.md pour les propriétés exactes. Les éléments ajoutés à
l'exécution sont visibles dans l'arbre distant, pas avant lancement.

## Vérifications réellement effectuées par l'assistant

- Lecture de l'archive fournie et cohérence avec la scène/configuration attendues.
- Références res:// des scènes et scripts résolues vers des fichiers livrés.
- XML des trois SVG analysé sans erreur.
- Calcul Python/NumPy float32 de 14 allers-retours sur 7 points et 2 origines :
  erreur maximale 0.0, inférieure à 0.01 unité.
- Exemple de distance au sol (100,0) vers (130,40) : 50 unités.
- Inspection statique du tri, des ancrages et des changements de texture.
- Archive finale comparée aux fichiers sources, sans cache ni fichier Git.

Non exécutés : compilation/import GDScript, lancement Godot, recette visuelle,
export APK et tests Android. Aucun exécutable Godot n'était disponible dans
l'environnement de l'assistant. Le calcul Python ne remplace pas le test GDScript.

Le laboratoire exécute à son démarrage les 14 allers-retours et un exemple connu.
Il affiche OK ou ECHEC et l'erreur maximale ; ECHEC produit aussi une erreur Godot.
Ces contrôles embarqués sont livrés mais pas encore exécutés dans Godot.

## Tests manuels à exécuter sous Linux

Préconditions : Godot 4.7.2, import terminé, projet en Compatibility.
Cliquer dans la vue de jeu si les touches ne répondent pas.

1. F5 : voir titre STEP-003, deux losanges, trois acteurs et un pilier.
   Attendu : aucune erreur dans le débogueur.
2. Contrôle numérique : lire « Projection/inverse : OK » et une erreur < 0.01.
3. Laisser tourner 8 secondes : cyan/orange échangent leur profondeur deux fois.
   Attendu : l'acteur dont les pieds sont plus bas passe devant.
4. Observer le violet : derrière le pilier au début, devant après le croisement,
   puis retour derrière ; aucune collision n'empêche le trajet.
5. Observer cyan/violet pendant 8 secondes : silhouettes 48/80 px alternent.
   Attendu : pieds stables sur le trajet ; silhouette haute sans changement de tri.
6. Espace : relever coordonnées et temps, attendre 3 secondes.
   Attendu : valeurs et images restent fixes. Espace reprend sans saut temporel.
7. En pause, R : temps zéro et cyan en (262,225) à la référence 540 × 960.
   Attendu : sol A=(-209,-201), pas de décalage d'origine ; la pause est conservée.
8. T : désactiver l'alternance ; reprendre. Attendu : silhouettes normales fixes,
   trajectoires inchangées. T réactive l'alternance.
9. Observer les textes pendant tous les croisements : aucun sprite ne les recouvre.
10. F8, fermer/rouvrir le projet puis F5 : même départ, sans erreur d'import.

La recette est globalement validée par le retour utilisateur du 22 octobre 2026 :
« Tout est OK. Step validée. Les croisements s’effectuent sans ambiguïté. »
Aucun relevé chiffré distinct de l’erreur affichée dans Godot n’a été transmis. Une égalité exacte de
profondeur à l'instant de croisement n'impose pas d'ordre sémantique.

## Critères d'acceptation

- [x] Import et lancement Godot sans erreur.
- [x] Conversion/inverse : erreur < 0.01 dans Godot.
- [x] Croisements et passage devant/derrière le décor corrects.
- [x] Changement de silhouette sans saut des pieds ni tri par centre de texture.
- [x] Interface indépendante du monde.
- [x] Pause locale/reprise et redémarrage cohérents.
- [x] Relecture des fichiers, validation explicite utilisateur.

## Limites et dette bornée

Laboratoire seulement : pas de mouvement du futur héros ni d'attaque.
Les contrôles clavier sont destinés à la recette PC ; adaptation tactile en STEP-004.
Le pilier est non bloquant ; aucune promesse de navigation autour d'un obstacle.
L'interface du laboratoire est prévue pour 540 × 960 et une largeur au moins égale
à 540 ; la validation des ratios et zones de sécurité Android n'est pas acquise.
L'annexe détaillée de la roadmap était vide à la réception ; registre préservé.
Le premier import utilisateur a révélé une collision de nom, décrite ci-dessous.
Le lancement corrigé et la recette ont ensuite été validés par l’utilisateur.

## Traçabilité et suite

Message proposé :
`feat: [STEP-003] definir la projection du sol et le tri visuel`

Commit STEP-003 : aucun. Dernier commit antérieur connu : 5b9baac.
Validation reçue : inclure code, scènes, assets, métadonnées d’import
et documentation dans un commit unique après vérification du contenu préparé. Aucun hash n'est fabriqué à l'avance.
Prochaine action : appliquer les documents de validation, préparer et vérifier
le contenu du commit, puis créer et contrôler le commit STEP-003.
STEP-004 attend la validation, le commit et un nouveau feu vert.

## Correctif 1 — 22 octobre 2026

Le premier import sur le poste utilisateur a échoué : la constante Projection
portait le nom du type natif Godot Projection. Les erreurs ground_to_screen et
screen_to_ground étaient consécutives à cette collision, pas à une absence de
ces fonctions dans ground_projection.gd.

Correction : renommer la constante en GroundProjection et ses dix appels dans
scripts/debug/projection_lab.gd. Aucune formule, scène ou trajectoire modifiée.
Source : https://docs.godotengine.org/en/4.7/classes/class_projection.html

Vérification effectuée ici : une déclaration remplacée, dix appels renommés,
absence de référence de code à l'ancien identifiant, archive vérifiée.
Non exécuté : compilation et lancement Godot, moteur toujours indisponible ici.

Recette de correction : fermer Godot, extraire step-003-correctif-1.tar.gz à
la racine du projet, rouvrir et lancer F5. Les erreurs de collision doivent
avoir disparu ; poursuivre alors les dix tests manuels décrits ci-dessus.
Si une autre erreur survient, transmettre son message exact.

Cette correction appartient à STEP-003 non encore validée ni commitée.
Aucun commit correctif distinct n'est requis avant sa première validation.

### Résultat du correctif 1

L'utilisateur a confirmé le 22 octobre 2026 que tout fonctionne et que les
croisements s'effectuent sans ambiguïté, puis a validé STEP-003.
Le blocage initial est résolu selon ce retour. La compilation et le rendu
n'ont toujours pas été exécutés dans l'environnement de l'assistant.
Aucun export Android ni mesure de performance n'est déduit de cette validation PC.

## Incident ultérieur — RECOVERY-001

Après validation de STEP-003, la copie locale a perdu son historique et ses
sources ; seuls quatre documents restaient. Aucun commit STEP-003 n'a été
confirmé. Le contenu validé est reconstruit dans une archive complète.
Les sections de validation ci-dessus sont conservées comme trace historique ;
la reprise actuelle suit docs/recovery.md et PROJECT_STATUS.md.
