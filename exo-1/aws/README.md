# Exercice 1 - Option "AWS"

## Démarrer

1. Avec un terminal, se positionner dans le répertoire `exo-1/aws`
2. Exécuter la commande suivante:

   ```bash
   export AWS_ACCESS_KEY_ID=<votre_identifiant_aws>
   export AWS_SECRET_ACCESS_KEY=<votre_secret_aws>
   terraform init
   terraform apply
   ```

Une fois le déploiement terminé, l'URL de votre instance Kibana devrait être affichée dans la console.

De plus, vous devriez pouvoir visualiser votre domaine OpenSearch à l'adresse https://us-east-1.console.aws.amazon.com/aos/home?region=us-east-1#opensearch/domains/.

## Nettoyer son environnement après l'exercice

> **Attention !** Si vous oubliez de supprimer votre environnement à la fin de l'exercice il est possible que des frais supplémentaires vous soient facturés par la plateforme AWS !

```bash
terraform destroy
```
