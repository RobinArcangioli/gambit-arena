# Méthode de travail et conventions de livraison

## Collaboration

Communiquer en français, directement et avec des résultats vérifiables. Un GO autorise
l’étape suivante prévue ; poursuivre le travail autorisé sans reconfirmer chaque choix
réversible. Une validation utilisateur ne signifie pas que l’étape a déjà été commitée.
Ne pas démarrer STEP-028 pendant cette seule préparation de passation/push.

Ne pas toucher aux animations, au ciblage, au swipe ou à l’équilibrage dans une étape sans
rapport. Préserver la compatibilité des laboratoires historiques. Si le périmètre change,
le documenter clairement. Lors d’un signalement, corriger immédiatement l’étape courante
avec un identifiant stable et un test reproduisant le problème.

## Cycle établi

1. Partir du dernier commit/sauvegarde vérifié, lire l’état, la roadmap et les fichiers concernés.
2. Travailler dans une copie isolée sans réécrire l’historique utilisateur. Conserver .gd.uid,
   .svg.import et UID de Main ; les caches .godot ne sont pas des sources.
3. Implémenter uniquement l’étape autorisée, ajouter les bancs de comportement pertinents et
   actualiser README/ARCHITECTURE/ROADMAP/PROJECT_STATUS et docs/steps/STEP-XXX.md.
4. Exécuter ce qui est réellement disponible. Distinguer contrôle statique, exécution moteur,
   test manuel PC et téléphone. Ne jamais inventer de lancement, mesure ou SHA d’APK.
5. Livrer une archive complète gambit-arena/ sans .git/.godot, avec bundle historique séparé
   et notice précisant que les nouveaux changements ne sont pas encore dans le bundle.
6. L’utilisateur importe, lance F6 puis F8 entre bancs, teste F5 et l’APK sur téléphone,
   vérifie fluidité et transmet le SHA-256 du nouvel APK.
7. Consigner la validation dans une archive complète de validation : uniquement documents
   modifiés, code/configuration octet pour octet identiques à la livraison validée.
8. Fournir git add explicite, diff --cached --check/--stat, message de commit et sauvegarde.
   L’utilisateur réalise le commit. Ne pas inventer son hash ou prétendre l’avoir poussé.
9. À réception de la sauvegarde, extraction sûre, clone du bundle, bundle verify, fsck,
   vérification HEAD/parent/statut et comparaison fichier par fichier entre commit,
   sauvegarde et livraison validée. Clôturer puis attendre GO.

Pour une simple modification documentaire, pas de nouvelle recette moteur si tous les
fichiers non documentaires ont été vérifiés identiques. HANDOFF-001 suit cette règle.

## Git et archives

Une étape fonctionnelle validée = un commit portant son ID. Un fix avant clôture est inclus
dans ce commit ; un fix après clôture doit être identifié séparément. Ne pas amender un
commit uniquement pour inscrire son propre hash : l’étape suivante actualise les statuts.
Aucun git restore automatique des changements utilisateur, aucun push --force.

Les commandes d’extraction/installation/commit sont chaînées avec && pour ne pas poursuivre
après une erreur. Une archive absente dans Downloads a déjà causé une installation partielle
suivie d’un commit ; vérifier le nom exact et ne pas continuer si tar échoue.
Une nouvelle version doit produire un nouveau SHA ; plusieurs anciennes empreintes ont été
recopiées par erreur puis corrigées par l’utilisateur. Garder l’empreinte finale explicitement validée.

Le script tools/create_backup.sh exige un arbre propre et archive HEAD + bundle --all.
Il est lancé explicitement avec bash. Le chemin de sortie par défaut est
~/gambit-arena-backups, les APK sont sous ~/gambit-arena-builds (hors dépôt).
Ne jamais confondre le SHA d’une archive avec celui de l’APK.

## Pièges Godot rencontrés

- L’éditeur peut enlever le réglage explicite pointing/emulate_mouse_from_touch=true de
  project.godot ou réécrire export_path ; examiner le diff avant commit et ne pas introduire
  ces changements silencieusement. Le preset actuel possède un chemin d’export explicite.
- Une erreur F6 est bloquante même si le test manuel paraît bon. Corriger aussi les warnings
  UNASSIGNED_VARIABLE et CONFUSABLE_LOCAL_DECLARATION ; utiliser des noms de bilan distincts.
- Les anciens acteurs sont queue_free : attendre une/deux frames avant de vérifier leur
  disparition. Dans le monde UI compter les acteurs par type, pas caméra/lumières/environnement.
- Un test tactile doit injecter les événements au viewport réel, y compris la copie souris,
  pas simplement appeler le callback du bouton. Molette et doigt ne prouvent pas la même chose.
- Utiliser notification() pour tester la chaîne de notifications ; _notification est spécial
  dans l’héritage Godot. Ne pas confondre tests synthétiques et notifications d’un vrai téléphone.
- La portée vaut 1 et l’arrêt du mover 0,8 : préserver le garde d’immobilité à portée.
- Le verrou d’une action ne remplace pas la mémoire de cible entre actions (fix1).

## Contrôles utiles

Avant livraison : git diff --check ; références res:// existantes ; UID non dupliqués ;
liste des fichiers nouveaux/modifiés attendue ; composants sensibles hors périmètre identiques ;
contenu extrait de l’archive identique aux sources préparées ; bundle de la bonne base.
Ces contrôles ne compilent pas le GDScript. Si Godot devient disponible, exécuter les bancs
et consigner version, commande, résultat et limites, sans supprimer la recette matérielle.
