# FIX-STEP-018-001 — Corriger le banc diagnostics

## FIX-STEP-018-001 — 24 octobre 2026

Retour F6 utilisateur sur v1 : avertissement CONFUSABLE_LOCAL_DECLARATION pour
report et échec du contrôle des résidus après dix resets en pause. À ce stade,
STEP-018 restait en attente de validation ; ce retour ne constituait pas un succès global F6.

Le test utilisait World.get_child_count() == 4, mais World possède aussi une caméra,
un WorldEnvironment et un DirectionalLight3D. Le correctif compte les ProxyActor
(et leurs sous-classes) et vérifie leur appartenance aux quatre acteurs courants.
Pause et remise à zéro du journal disposent désormais de contrôles séparés.
Le texte du bilan est renommé summary_text pour éviter le nom report utilisé dans
une boucle du même bloc parent. Aucun composant de gameplay ou diagnostic ne change.

Livraison corrigée : gambit-arena-complet-step-018-v2.tar.gz.
Validation utilisateur reçue le 24 octobre 2026 : F6, tests manuels et fluidité OK.
FIX-STEP-018-001 validé dans ce retour global ; aucun résultat détaillé par banc fourni.
Contrôles statiques effectués ; Godot non exécuté chez l'assistant.

Le correctif est intégré à STEP-018 encore non commitée ; aucun commit séparé requis.
Version Android conservée : 0.1.0-step018, code 17. APK validé : voir STEP-018.md pour son SHA-256.
