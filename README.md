# DistributedEditor
Distributed editing prototype with wave algorithms, critical section and snapshot

## Principe

Ce projet se base sur la suite logicielle [Airplug](https://airplug.hds.utc.fr/dokuwiki/doku.php). Un ensemble de machines sont connectées par un réseau décentralisé (simulé par des pipes nommés). Un texte peut être édité collaborativement de manière sûre et cohérente.

Les fonctionnalités proposées par le prototype sont :
* Communication avec un sous-groupe des machines ;
* Edition d'un texte avec exclusion mutuelle automatique ;
* Snapshot de l'état du système ;
