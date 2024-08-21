# Exercice 1 - Option "locale"

## Démarrer

1. Avec un terminal, se positionner dans le répertoire `exo-1/docker`
2. Exécuter la commande suivante:

   ```bash
    docker compose up
   ```

Une fois le déploiement terminé, les ressources suivantes devraient être disponibles:

- http://localhost:5601/ - Interface Kibana
- http://localhost:9200/ - Serveur ElasticSearch
- http://localhost:8000/ - Application Web (extraite du P2)

## Nettoyer son environnement après l'exercice

```bash
docker compose down --remove-orphans -v
```
