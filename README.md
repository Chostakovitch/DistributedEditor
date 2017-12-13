# DistributedEditor
Distributed text editing prototype with wave algorithms, critical section and snapshot

## Principe

Ce projet se base sur la suite logicielle [Airplug](https://airplug.hds.utc.fr/dokuwiki/doku.php). Un ensemble de machines sont connectées via un réseau décentralisé (simulé par des pipes nommés). Un texte peut être édité collaborativement de manière sûre et cohérente.

Les fonctionnalités proposées par le prototype sont :
* Communication avec un sous-groupe des machines ;
* Edition d'un texte avec exclusion mutuelle automatique ;
* Snapshot de l'état du système.

## Algorithmes

Les algorithmes utilisés pour ce prototypes sont issus de l'algorithmie distribuée. En particulier, ceux implémentés pour ce projet sont :
* Algorithmes de vague et de demi-vague pour la diffusion (wave algorithms) ;
* Construction de snapshot avec lestage (piggybacking) ;
* Exclusion mutuelle avec file d'attente distribuée (Lamport's algorithm) ;
* Horloges logiques (logical clocks) :
  * Estampilles (Lamport's clock) ;
  * Horloges vectorielles (vector clock).
  
## Utilisation

`cd bin; source config.sh` configure l'environnement. Le script `bin/run.sh` lance les interfaces graphiques de démonstration.

L'interface est divisée en différentes zones configurables via la barre de menu. Une première zone permet d'envoyer des messages aux autres applications.

La zone de texte est liée au bouton d'entrée et de sortie de section critique, permettant d'éditer et de diffuser de manière cohérente et loyale.

Le bouton de snapshot permet de construire un instantané cohérent de l'état du système (i.e., une coupure dont les composantes de la date vectorielle calculée de la frontière sont cohérents par rapport aux sites dont elles sont issues).
