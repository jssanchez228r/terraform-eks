# genaia-eks
genaia-eks

Este Repositorio contiene los archivos de IaC (Infraestructure as Code) y Ansible, con los que fue desplegado el repositorio.

## Pre-Requisitos
1. Install Terraform
2. Modificar el archivo de variables segun necesidad  
      Ambiente Preprod: 'Terraform/Env/Preprod.tfvars'  
      Ambiente Prod: 'Terraform/Env/Prod.tfvars' 
3. Install Ansible

## Terraform 
Utilizamos la modularización para el despliegue de los recursos, los recursos que se crearan son los siguientes:  
| Recurso | Descripción |
|--------|-------------|
| VPC | 1 VPC para el Entorno |
| Private Subnet | 3 Subnets Privadas | 
| Public Subnet | 1 Subnet Publica| 
| Elastic_IP | 1 IP Elastica Publica para el NAT GATEWAY Publico |
| Internet_Gateway | 1 Internet Gateway para las subnets publicas |
| NAT_Gateway | 1 NAT Gateway Publico |
| Route_Table | 2 Route Tables Subnet Privadas y Publicas |
| Private_Routes | Rutas Privadas |
| Public_Routes  | Rutas Publicas |
| Route_Table_Association_Private | Asociacion de rutas al Route Table Privado |
| Route_Table_Association_Public | Asociacion de rutas al Route Table Publico |
| EKS_Cluster | 1 Cluster EKS |
| EKS_Addon | Los Complementos Principales para el funcionamiento del cluster y la comunicación de los servicios |
| EKS_Node_Group | Grupo de Nodos del Cluster EKS |

1. Dirigirse a la ruta donde esta el arbol de trabajo de terraform  
 `cd Terraform`

2. Modificar el archivo 'backend.tf' y modificar la linea de path para elegir el nombre del tfstate(archivo control de cambios)  
 `path = "terraform-preprod.tfstate"`  
 'Preprod=terraform-preprod.tfstate'  
 'Prod=terraform-prod.tfstate'  
 NOTA: Este archivo no se puede dejar por variables, por tal razon es importante tener SUMAMENTE CUIDADO para no dañar el archivo.  

3. Inicializar los modulos
`terraform init`

4. Revisión y validación los cambios por aplicar aplicar  
`terraform plan --var-file="./Env/Preprod.tfvars"` o   
`terraform plan --var-file="./Env/Prod.tfvars"`

5. Aplicación y despliegue de cambios  
`terraform apply --var-file="./Env/Preprod.tfvars"` o  
`terraform apply --var-file="./Env/Prod.tfvars"`

### IMPORTANTE
Al ejecutar el terraform apply se genera automaticamente el archivo ***terraform.tfstate*** este archivo es el que contiene el control de cambios ejecutados, ***NO ELIMINAR***. en caso de que se pierda este archivo al hacer un terraform plan o un terraform apply, este no reconocera ningun recurso previamente creado; En pocas palabras creara recursos nuevos ante cualquier modificación.

## Ansible

## Storage Class S3

1. Crear S3 Bucket
2. Asociar Policy al S3 Bucket  
   Preprod: 's3-storageclass/iam/s3-bucket/preprod/s3-bucket-policy.json'
   Prod: 's3-storageclass/iam/s3-bucket/prod/s3-bucket-policy.json'
3. Crear Rol ***AmazonEKS_S3_CSI_DriverRole***
4. Crear Policy ***AmazonS3CSIDriverPolicy*** y asociar al Role ***AmazonEKS_S3_CSI_DriverRole***  
   Preprod: 's3-storageclass/iam/NodePolicy/preprod/AmazonS3CSIDriverPolicy.json'
   Prod: 's3-storageclass/iam/NodePolicy/prod/AmazonS3CSIDriverPolicy.json'
5. Crear relacion de confianza para el Role ***AmazonEKS_S3_CSI_DriverRole***  
   Preprod: 's3-storageclass/iam/NodePolicy/preprod/trust-relation.json  
   Prod: 's3-storageclass/iam/NodePolicy/prod/trust-relation.json  
6. Asociar Policy ***AmazonS3CSIDriverPolicy*** al Role del Grupo de Nodos.
7. Desplegar Addon ***Mountpoint for Amazon S3 CSI Driver*** Cluster EKS y asociar Role ***AmazonEKS_S3_CSI_DriverRole***

## Ejemplo de despliegue Storage class
### Modificar archivo ejemplo y adicionar el Bucket name
### Despliegue  
`kubectl apply -f s3-storageclass/examples/example_static_provisioning.yaml`  
### Validacion del Pod
`kubectl get pod s3-app`
### Validacion Bucket 
`$ aws s3 ls bucket_name`

  
En caso de tener alguna duda sobre el proceso o la arquitectura del storage class seguir las siguientes documentaciones  
- https://docs.aws.amazon.com/es_es/eks/latest/userguide/s3-csi.html
- https://docs.aws.amazon.com/eks/latest/userguide/s3-csi.html