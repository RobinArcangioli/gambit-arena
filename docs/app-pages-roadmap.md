# UI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'accueil, le thème, les retours et les
arènes aléatoires. APK normal 0.1.0-ui001 (44), SHA-256
`0c18f5936ca60e5bda292f364501a5a765c834f9827ff07b9b560cb33ee615fa`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 43 bancs / 2 718 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. Prochaine étape UI-002 :
page Équipe avec Mako, Anne et deux places vides ; attendre un nouveau GO.
GAMEPLAY-003 reste annulée. Les mentions de recette suivantes sont historiques.

# UI-001 implémentée, en recette

GO reçu : accueil, thème, fonds, navigation et arène aléatoire sont livrés dans UI-001,
encore sans commit/push. Voir steps/UI-001.md et app-navigation.md. Équipe reste désactivé
jusqu'à UI-002. Les pages Fiche et Gambits hors combat attendent UI-003/004.
Les décisions et le découpage ci-dessous restent le contrat du chantier.

# Accueil, équipe, fiches et gambits — roadmap proposée

Préparée le 27 octobre 2026, après GRAPHICS-009 validée et clôturée au commit
d632dfbfcce35cbe2d2bb7993347d0cb450b8d8e. Cette livraison est documentaire : les nouveaux
écrans ne sont pas implémentés. Le prochain GO, après accord sur ce plan, démarre UI-001.
UI-001 à UI-005 s'intercalent avant STEP-029 et STEP-030, qui conservent leurs identifiants.
GAMEPLAY-003 reste annulée : tailles, navigation et ombres sont conservées.

## Parcours retenu

Accueil → Équipe → Fiche du héros → Gambits du héros.
Accueil → Arène (combat).

L'accueil propose les boutons « Équipe » et « Arène ». Équipe possède un bouton retour vers
l'accueil. La fiche revient à l'équipe ; Gambits revient à la fiche du même héros. Arène
possède un retour vers l'accueil. Le bouton Retour Android suit la même hiérarchie ; une
fenêtre modale ouverte se ferme d'abord. Les identités Mako/Anne restent explicites à chaque
passage, sans déduire le héros de l'index d'une carte.

Réponses explicites du propriétaire :

- quitter l'arène abandonne le combat ; la prochaine entrée démarre une partie neuve ;
- équipe en grille 2 × 2 : Mako, Anne, puis deux emplacements vides ;
- les fiches montrent les valeurs de référence, pas les PV/mana restants d'un combat ;
- tous les boutons sont superposés aux fonds, sur toutes les pages ;
- style bleu profond/bleu nuit et jaune or/orange de coucher de soleil ;
- chaque nouveau combat tire une arène aléatoire parmi les huit arènes illustrées.

Les gambits enregistrés survivent à l'abandon. Chaque nouvelle entrée en arène recharge
la configuration validée, avec PV/mana et état de combat neufs selon les règles existantes.
Le passage de l'application en arrière-plan reste une pause Android : ce n'est pas une
commande de retour à l'accueil ni un abandon implicite.

## Fonds fournis

Accueil : `/home/arkhane/Gambit_Arena_Home.png`, 941 × 1672, RGB.
SHA-256 : 35879c7af2127c709c213f1d6a644ab9057be939e67d1cb59ed0a29196aec1fe.
Le logo est déjà dans l'image ; ne pas lui superposer un deuxième titre. Placer les deux
boutons dans la partie basse, lisibles sur le sol, en préservant la lune et le logo.

Équipe : `/home/arkhane/Gambit_Arena_Background_1.png`, 941 × 1672, RGB.
SHA-256 : 4121d79a06909712e99c006f5a3894e8e985a5a616b02ec34ee36e2b87ca049b.
Quatre cartes sobres, lisibles sur ce fond détaillé, avec des aperçus 3D transparents pour
les deux héros. Les emplacements vides restent identifiés « Vide », sans personnage actif.

Importer ces images dans le projet lors de UI-001, avec provenance « fournies par le
propriétaire ». Conserver leurs originaux et leurs proportions ; tester le recadrage sur
les écrans portrait longs et la zone sûre Android. Cette préparation ne les importe pas
encore dans Godot. Les originaux sont joints comme références à l'archive documentaire.
Proposition : réutiliser ce fond pour les fiches et les gambits, avec panneaux de lecture,
pour garder une unité visuelle ; aucun nouveau fond n'a été demandé pour ces deux pages.

## Boutons et habillage sur toutes les pages

Les fonds couvrent la page derrière les commandes. Tous les boutons, y compris les retours,
les cartes cliquables, les commandes de fiche/gambits et le HUD de combat, sont superposés
au fond. Aucun bandeau séparé hors du fond ne doit accueillir les boutons. Les panneaux
éventuels restent des surimpressions locales permettant de lire le contenu sur l'illustration.
L'aire de combat logique, les gabarits et les collisions ne changent pas avec cette composition.
Le cadrage du décor et sa calibration par rapport aux pieds doivent être revalidés lorsque
le HUD de combat est recomposé ; les commandes ne doivent pas masquer les informations utiles.

Répartition : Home pour l'accueil ; Background_1 pour Équipe, Fiche et Gambits ; image de
l'arène choisie pour le combat. Le logo de Home reste visible. Les zones sûres Android et
le défilement s'appliquent aux commandes, sans découper le fond en zones opaques séparées.

Palette de départ déduite visuellement des fonds, à affiner sur les maquettes :

| Usage | Couleur proposée |
|---|---|
| Bleu nuit, corps des boutons | #10182F |
| Bleu profond, relief ou dégradé | #172B4D |
| Or, liserés et accents | #D9AA4C |
| Orange ambré, appui et sélection | #EE9A45 |
| Ivoire chaud, texte | #FFF2D4 |

Style commun : surface bleu nuit légèrement translucide, liseré or fin, relief discret,
texte clair et accents ambrés. Prévoir repos, appui, focus et désactivation, avec lisibilité
et surface tactile suffisantes. Centraliser thème, espacements et états dans des ressources
remplaçables ; ne pas disperser les couleurs dans les pages. Valider le contraste sur les
fonds clairs comme sombres. UI-001 pose ce thème ; UI-002 à UI-004 le réutilisent.

## Tirage de l'arène à chaque nouveau combat

UI-001 choisit uniformément une des huit arènes illustrées du catalogue au démarrage de
chaque nouvelle partie : entrée depuis l'accueil et commande Rejouer. Le terrain de référence
est exclu. Des répétitions successives sont possibles : ce n'est pas une rotation imposée.

L'arène sélectionnée reste stable pendant les vagues, la pause et la reprise. Le tirage
visuel est isolé du RNG éventuel du combat, du ciblage et du pathfinding. Il est injectable
ou contrôlable dans les tests ; l'identifiant choisi est disponible dans le diagnostic.
Le sélecteur existant ne détermine pas le tirage de la prochaine partie. Éviter de tirer
plusieurs fois pour un même démarrage ou d'instancier plusieurs combats sur un double appui.
Ce choix concerne uniquement le modèle de présentation : terrain logique et règles conservés.

## Étapes et critères de validation

| Étape | Périmètre | Acceptation |
|---|---|---|
| UI-001 | Fonds, thème commun, accueil, navigation et arène aléatoire | F5 ouvre l'accueil ; Arène ouvre le combat existant ; retour le détruit ; une nouvelle entrée recrée une partie propre, conserve les gambits et tire un des huit fonds ; boutons sur les fonds |
| UI-002 | Page Équipe et aperçus Idle | Grille 2 × 2, Mako puis Anne, deux cases vides ; aperçus 3D cadrés et animés au repos ; sélection identifie correctement le héros ; retour accueil |
| UI-003 | Fiche de personnage | PV/mana maximums, caractéristiques et compétences issus des données de référence ; bonne identité ; retour équipe ; accès Gambits préparé pour UI-004 |
| UI-004 | Page Gambits indépendante du combat | Bouton de la fiche ouvre la programmation du bon héros ; règles existantes réutilisées ; sauvegarde/rechargement cohérents ; prochain combat utilise les modifications |
| UI-005 | Recette du parcours complet sur Android | Pages et retours cohérents, tactile/scroll, arrière-plan, cycles de navigation sans fuite, cadrage, boutons sur les fonds, palette commune et tirage des huit arènes ; ancien combat et laboratoires préservés |
| STEP-029 | Reproduction depuis un clone neuf | Import, F5 sur accueil, export et installation du même périmètre documentés et rejoués |
| STEP-030 | Recette finale sur APK identifié | Accueil, équipe, fiches, gambits et arène inclus dans la recette MVP complète |

Chaque étape a sa fiche dans docs/steps/UI-00N.md. Validation, commit unique, sauvegarde
restaurée/vérifiée puis GO pour la suivante, selon le cycle établi. La connexion complète
Fiche → Gambits est livrée dans UI-004, après les fiches de UI-003 ; les galeries F6 permettent
une validation progressive des composants. La qualification du parcours complet est UI-005.

## Contenu des fiches

Lecture seule à ce stade : nom, aperçu du héros, PV max, mana max, attaque, défense,
vitesse, régénération de mana, attaque de base et compétence propre.

Valeurs actuelles, lues dans les ressources existantes (pas un nouvel équilibrage) :

| Héros | PV max | Mana max | Compétences |
|---|---|---|---|
| Mako | 180 | 60 | Attaque, Foudre |
| Anne | 140 | 60 | Attaque, Soin |

Présenter pour chaque compétence coût, portée, incantation, délai de recharge et description
fidèle au calcul existant. Le soin cible un allié vivant, soi inclus ; les PV rendus peuvent
être plafonnés. Les dégâts réels dépendent de la cible et de sa défense : ne pas présenter
un dégât de référence comme une garantie de dégâts effectifs. Les métadonnées de compétence
doivent venir d'un contrat partagé avec le moteur, sans copier des constantes dans les pages.
Aucun niveau, équipement, expérience ou point de caractéristique à inventer pour ces fiches.
Le bouton « Gambits » se trouve en bas du contenu, accessible aussi sur petit écran.

## Architecture et préservation

- Une racine d'application possède les routes et les pages. Le combat existant garde sa scène
  et son UID pour les anciens F6 ; le point d'entrée F5 passe explicitement à l'accueil.
- L'arène est instanciée à l'entrée et libérée à l'abandon : acteurs, événements, effets,
  barres, caches de chemins et gestes en cours disparaissent avec elle. Aucun combat caché
  ne tourne derrière les menus. Les doubles appuis ne créent pas plusieurs arènes.
- Les aperçus utilisent les vues de personnages passives et leur temps visuel accepté,
  sans PartySimulation ni exécuteur de combat. Deux aperçus actifs au plus sur Équipe ;
  aucune scène 3D pour les cases vides ; rendu/animation arrêtés lorsque la page est masquée.
- Un catalogue léger distingue l'ordre d'affichage [Mako, Anne, vide, vide] des identités de
  combat. Changer cet ordre d'affichage ne réordonne pas le solveur ni les gambits du combat.
- Partager le chargement, la validation et la sauvegarde des règles via PartyRules ou un
  petit dépôt de configuration. Réutiliser l'éditeur en dehors de PartyApplication : il
  reçoit un identifiant de héros et des données, sans exiger un combat vivant pour éditer.
- Préserver `user://party_rules_v2.json`, son schéma et les configurations enregistrées.
  Trois règles par héros restent prévues ; les quatre slots d'équipe ne sont pas quatre
  slots de gambits. Éditer Mako doit préserver intégralement les règles d'Anne, et inversement.
  Les brouillons utilisent Appliquer/Annuler ; quitter un brouillon ne le sauvegarde pas.
- Reprendre les commandes actuelles d'activation et de priorité des règles, les compétences
  autorisées par héros et le défilement tactile. Une configuration invalide ou une erreur
  d'écriture suit une stratégie explicite de repli/retour utilisateur, sans écrasement silencieux.
- Conserver l'accès aux gambits en combat pendant ce chantier ; s'il partage le nouvel éditeur,
  les modifications continuent à suivre son comportement actuel. Les deux entrées utilisent
  les mêmes règles et le même format de sauvegarde.
- Préserver styles et fonds dans la présentation, indépendants des scènes de navigation et
  des règles du jeu. Adapter aussi les exports diagnostiques qui supposent aujourd'hui que
  le point d'entrée du projet est directement l'UID de Main.

## Recette prévue

Vérifier au minimum : bon héros sélectionné dans les deux cartes ; slots vides inactifs ;
Idle et pause des aperçus ; fiche cohérente avec les données ; édition indépendante des deux
héros ; persistance après fermeture/réouverture ; aucun tick de combat sur l'accueil ;
abandon pendant attaque, soin ou foudre ; retour via bouton et Retour Android ; vingt cycles
Accueil/Équipe/Fiche/Gambits et Accueil/Arène sans nœuds retenus ni événements d'une ancienne
partie ; menus puis arrière-plan/reprise ; tactile sans sélection accidentelle pendant scroll.
La régénération et les cooldowns ne doivent pas évoluer hors d'un combat actif.

Le projet reste portrait. La recette couvre référence 540 × 960 et format long du Galaxy A16,
les zones sûres, le texte français et les fonds fournis. Garder le coût des aperçus borné et
mesurer seulement si une régression se manifeste ; ne pas inventer de nouveau seuil FPS.

Les deux places libres préparent une extension future, sans recrutement, remplacement de
héros ou quatrième combattant dans ce chantier. Ces fonctionnalités exigeraient un autre plan.
