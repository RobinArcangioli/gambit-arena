# État du projet

## Base confirmée

STEP-008 clôturée : 46dfaa77ac79fccccebe165973a1bdbfb1000cf4, main propre.
Sauvegarde reçue : gambit-arena-20261022-210049-46dfaa77ac79.tar.gz.
Bundle cloné et vérifié ; 90 fichiers versionnés identiques aux sources archivées.
Tests manuels validés par l’utilisateur : aucune saccade, verrouillage et
réduction/retour OK. Résultat automatisé F6 non détaillé séparément dans son retour.
APK STEP-008 : 214b055b0f4af6c095c0827018d0f1a2108bffa603dd97a43a18c80dbfe50f3c.

## STEP-009 — Validée, commit en attente

Livraison : gambit-arena-complet-step-009-v1.tar.gz.
Disques de rayon 0,35, contrôle du trajet contre les voisins, correction de
chevauchement plafonnée à 0,6 u/s. Héros jamais déplacé par correction passive.
Encerclement, poursuite, couronne bloquante ouvrable, bordure et pile initiale.
Limite 20 ennemis, points d’apparition contrôlés, pause et remise à zéro.
Version Android 0.1.0-step009, code 8. APK installé avec succès et validé ;
empreinte et résultats consignés ci-dessous.

## Vérifications et limites

Contrôles statiques des ressources, fichiers préservés et archive effectués.
Une simulation numérique séparée a vérifié les budgets, une paire dans un coin,
la couronne fermée/ouverte et des groupes de 20 ; elle ne valide pas GDScript.
Banc F6 fourni pour exécuter les vrais scripts Godot. Godot absent ici : aucune
exécution moteur, compilation GDScript, mesure FPS ou export Android réalisé.
Les contacts restent conservateurs : attente possible même lorsqu’un détour
existe. Pas de recherche de chemin, attribution de place, combat ou dégâts.
Les résultats de performance STEP-008 ne sont pas transposés à STEP-009.
Les vrais modèles et animations 3D restent à produire et qualifier.

## Prochaine action

Appliquer l’archive complète de validation, vérifier le diff et commiter les
fichiers ainsi que les UID générés par Godot. Confirmer le hash et le statut
propre, puis créer et transmettre la sauvegarde complète. STEP-010
(statistiques et PV par instance) attend cette clôture et un nouveau GO.

## Validation utilisateur reçue

STEP-009 explicitement validée par l’utilisateur : tous les tests manuels OK,
banc F6 OK, fluidité OK. Installation ADB Success sur Samsung Galaxy A16
SM-A165F, Android 16. Aucun chiffre FPS ni temps d’image fourni.
APK testé : step-009-debug.apk, version 0.1.0-step009, code 8.
SHA-256 : ff61292efe28c5688fd537982efe2f5ff03672c7934f2edeab19b5e7bf8bb24f.

Archive de validation : gambit-arena-complet-step-009-validation.tar.gz.
Code et configuration identiques à la livraison v1 testée ; seule la documentation
est actualisée. Aucun lancement Godot exécuté chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde après commit à recevoir.
