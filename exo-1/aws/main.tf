terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_opensearch_domain" "openclassrooms-p8" {
  domain_name    = "openclassrooms-p8"
  engine_version = "Elasticsearch_7.10"

  cluster_config {
    instance_type = "t3.small.search"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Domain = "OpenClassrooms_P8"
  }
}

output "elasticsearch" {
  description = "URL de la base de données ElasticSearch"
  value       = aws_opensearch_domain.openclassrooms-p8.endpoint
}

output "kibana" {
  description = "URL de connexion à l'instance Kibana"
  value       = aws_opensearch_domain.openclassrooms-p8.dashboard_endpoint
}
