# Roadmap restante et plan de reprise

## Nouvelle priorité validée — évolutions graphiques

STEP-028 est maintenant clôturée : commit 580ce64, push et sauvegarde vérifiés. Le propriétaire
a demandé de préparer des évolutions graphiques avant la recette finale. Lire la
[roadmap graphique](../graphics-roadmap.md), GRAPHICS-001 à GRAPHICS-007 : arènes, modèles 3D,
attaque, soin et Foudre, avec présentation interchangeable et gameplay préservé.
Plan validé et GO reçu : GRAPHICS-001 est en recette après implémentation du Colisée et de la
présentation interchangeable. Les sections ci-dessous conservent le contexte des étapes
initiales de livraison, qui gardent leurs identifiants. Après validation/clôture de GRAPHICS-001,
la prochaine étape graphique est GRAPHICS-002 : catalogue des huit arènes fournies.

STEP-001 à STEP-027 sont clôturées selon les preuves du registre, avec reprise d’historique
RECOVERY-001 et transition 3D TRANSITION-001. HANDOFF-001 prépare la transmission et GitHub ;
elle n’autorise ni n’implémente STEP-028. Les trois étapes restantes gardent leur périmètre.

## STEP-028 — Mesures reproductibles et budget matériel

Actualisation du 26 octobre : instrumentation, protocole et campagnes Android sont exécutés.
Consulter ../steps/STEP-028.md pour les essais, résultats et SHA testé. L'ancien objectif de
30 FPS Debug n'est pas atteint ; le propriétaire a cependant accepté explicitement la performance
pour le périmètre réel, où 20 ennemis simultanés ne sont pas prévus. Le plan ci-dessous reste
le contexte historique de l'étape, pas une promesse de performance générale.

Le propriétaire a ensuite validé STEP-028 : F6, F5, tactile Android et pause/reprise OK.
La clôture immédiate consiste uniquement à commiter puis sauvegarder cette étape ; STEP-029
reste une étape distincte, à démarrer seulement avec son GO.

Objectif initial : vérifier le budget matériel, avec cible provisoire de 30 images/s soutenues
sur le Galaxy A16. Les mesures chiffrées et la décision produit sont maintenant consignées dans
`../steps/STEP-028.md` ; ne pas les remplacer par ce plan antérieur.

Plan d’implémentation proposé, à préciser au démarrage :

1. Relever appareil/OS, Godot/templates, APK/SHA, mode Debug ou Release, options de rendu,
   conditions de test (charge batterie, alimentation, luminosité, température si disponible).
2. Définir un protocole reproductible : durée de chauffe, durée de capture, scénario normal
   et scénario saturé à 20 ennemis, même UI/règles et répétitions. Fixer explicitement ces
   durées et critères avant de comparer des résultats.
3. Mesurer des temps de frame réels de rendu et de simulation séparément. Ne pas calculer
   les FPS avec le dt borné de GameClock ni présenter un test accéléré F6 comme une mesure réelle.
4. Relever distribution des temps de frame (médiane/p95/p99 ou équivalent), images longues,
   mémoire si disponible, pics d’acteurs/objets et dérive après resets. Choisir une collecte
   bornée et un export exploitable, sans remplir indéfiniment un tableau ou le journal UI.
5. Confronter les résultats à l’objectif 30 FPS ; documenter les limites des compteurs et
   l’influence de Debug/USB/éditeur. Ne pas promettre une conformité avec la seule moyenne.
6. N’optimiser que les postes réellement dominants, un changement à la fois, avec nouvelle
   mesure comparable et régressions ciblage/actions/swipe/cycle de vie.

Points à examiner, pas des goulots déjà prouvés : séparateur Crowd, captures/allocations de
snapshots, HUD actualisé et relayout différé, rendu SubViewport, ressources de diagnostic
incluses par all_resources. Aucun de ces éléments ne doit être supprimé sans preuve et recette.
Livrables attendus : protocole, données brutes, synthèse, APK identifié, décision sur budget.

## STEP-029 — Clone propre, import, export et installation

Objectif approuvé : reproduire une installation depuis un clone neuf sans cache existant.
La première publication GitHub de HANDOFF-001 ne valide pas à elle seule STEP-029.

Plan proposé : vérifier l’URL/branche et le commit de référence ; cloner dans un nouveau
dossier ; relever versions et chemins SDK/JDK/templates ; importer sans .godot réutilisé ;
exécuter les tests utiles ; exporter/installler un APK propre et relever son SHA ; documenter
ce qui est global à la machine (SDK, templates, signature Debug) et ce qui est versionné.
Ne pas exiger un APK bit-à-bit reproductible sans avoir étudié métadonnées et signature.
Vérifier aussi la restauration du bundle et une nouvelle sauvegarde. Ne pas inscrire de
mot de passe ou clé privée dans export_presets.cfg. La CI éventuelle n’est pas déjà en place.

## STEP-030 — Recette finale MVP

Objectif approuvé : validation finale sur un APK identifié. Rassembler la matrice gameplay,
UI/portrait/zones sûres, ciblage, coûts/impacts, trois vagues, défaite/replay, pause/Android,
performance et installation. Consigner les réserves connues, décisions, SHA et commit.
Ne pas déclarer le MVP finalisé simplement parce que STEP-027 est validée. Le contenu
artistique reste provisoire tant qu’un chantier distinct n’a pas été décidé.

## Après MVP — propositions, hors autorisation actuelle

Production de modèles/rigs/animations et décors définitifs, direction artistique, équilibrage,
options d’accessibilité, sauvegarde persistante ou publication boutique demanderaient des
choix explicites. Ce ne sont pas des extensions automatiques de STEP-028 à STEP-030.
L’annexe détaillée initiale n’était pas fournie dans le fichier de lancement : le registre
des 30 étapes est conservé, mais ne pas inventer une spécification originale plus détaillée.

## Premier tour recommandé pour la prochaine IA

Vérifier le commit STEP-028 et sa sauvegarde une fois fournis ; lire HANDOFF.md et les
invariants ; confirmer les outils réellement disponibles. Attendre ensuite un GO explicite
pour STEP-029. Toujours conserver les corrections utilisateur et les preuves de validation.
