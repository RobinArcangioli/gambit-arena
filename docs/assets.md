# Assets de diagnostic

Les trois SVG de assets/debug/ ont été créés spécifiquement pour ce projet
par l'assistant : formes vectorielles simples, sans ressource tierce copiée.
Ils sont livrés comme sources modifiables du projet, sans dépendance externe.
Aucun asset Broken Ranks ou Final Fantasy n'est utilisé.

| Source | Dimensions | Usage |
|---|---|---|
| actor.svg | 48 × 48 | Silhouette normale, teinte appliquée par Sprite2D |
| actor_tall.svg | 80 × 80 | Même ancrage, silhouette étendue pour tester le tri |
| pillar.svg | 76 × 100 | Décor non bloquant, base ancrée au centre inférieur |

Godot importe ces SVG comme textures 2D. Filtrage linéaire explicite dans le
laboratoire ; pas de pixel art, pas de lumière 3D, pas de spritesheet finale.
Le contrat d'animations directionnelles et la compression individuelle seront
établis en STEP-005. Aucun budget mémoire Android n'est mesuré à cette étape.

À l'import, conserver dans Git les fichiers .svg.import générés (réglages),
ainsi que les .gd.uid générés pour les scripts ; exclure le cache .godot/.
Les fichiers .gd.uid ne sont pas fabriqués à la main dans cette livraison.
