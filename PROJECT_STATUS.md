# État du projet

## Base confirmée

TRANSITION-001 clôturée : 056a464b82869529b844571827b1aa01788bc2a6, main propre.
Sauvegarde reçue : gambit-arena-20261022-154651-056a464b8286.tar.gz.
Bundle cloné, HEAD vérifié, 59 fichiers identiques aux sources archivées.
Les APK et .idsig accidentellement exportés dans le dépôt ont été déplacés par
l’utilisateur avant sauvegarde ; ils ne font pas partie des sources.

Rendu hybride validé sous Godot et sur Galaxy A16 : profondeur, fond, décor,
commandes et pause OK. Taille 3D retenue : 48 px de référence.
Relevé utilisateur du diagnostic : 60 FPS moyens, pire image 16,7 ms, sans saccade.
APK TRANSITION-001 :
124654de74db47ac162a9f925d7f4f3844aa7504a316f43a559c4a3d86635f10.
Ces chiffres ne constituent pas un résultat de STEP-006 ou du futur combat.

## STEP-006 — Validée, commit en attente

Livraison testée : gambit-arena-complet-step-006-v1.tar.gz.
Livraison de validation : gambit-arena-complet-step-006-validation.tar.gz.
Arène fixe sur fond 2D, mannequins 3D immobiles à 48 px, bordure lisible,
limites logiques partagées et zones réservées en haut/bas pour l’interface.
Six emplacements inactifs matérialisent la place des futures commandes.
Contrôle de placement centre/quatre coins pour tester les limites.
Ancien laboratoire hybride et diagnostics 2D conservés via F6.
APK exporté et installé par l’utilisateur : 0.1.0-step006, code 5.
Installation ADB réussie ; empreinte exacte consignée ci-dessous.

## Vérifications et limites

Références, géométrie du placement portrait et archive contrôlées par l’assistant.
Godot indisponible ici : pas de compilation, rendu ou test tactile exécuté.
Les limites bornent les placements du diagnostic ; il n’y a pas encore de
contrôleur de déplacement, de collision physique ou de combat.
Les six emplacements ne sont pas des compétences. Les vrais modèles/animations
3D restent à produire ; les mannequins validés sont réutilisés pour l’arène.

## Prochaine action

Appliquer la livraison de validation, vérifier le diff préparé puis commiter
STEP-006 avec les nouvelles métadonnées Godot. Confirmer le hash réel et le
dépôt propre, exécuter bash tools/create_backup.sh et transmettre l’archive.
STEP-007 attend la clôture et un nouveau GO.

## Résultats reçus

Validation explicite reçue le 22 octobre 2026.
L’utilisateur confirme :
- Arène et bordure entièrement visibles entre les panneaux : OK.
- Mannequins lisibles à 48 px : OK.
- Cinq placements dans les limites, sans silhouette coupée ni chevauchement : OK.
- Pause bloque Position ; Repères reste utilisable : OK.
- Six cases À venir inactives : OK.
- Aucun message d’erreur ; arrêt F8 correct : OK.

ADB : téléphone en état device, installation Success sur Galaxy A16.
APK testé : step-006-debug.apk. SHA-256 :

```text
133d5096305e9278d9262c55dd5bc4ea8f067a571e618017fc4976866833c125
```

Ces résultats sont transmis par l’utilisateur ; l’assistant n’a pas exécuté Godot.
Aucune capture ni mesure de performance STEP-006 n’a été transmise.
Le retour d’arrière-plan/verrouillage n’a pas été détaillé séparément dans ce
retour ; la validation globale de l’étape est reçue sans inventer de résultat par test.
