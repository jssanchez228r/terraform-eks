### Providers ###
aws_credentials = {
    aws_region    = "eu-south-2"  
    profile       = "genia"
    path = "terraform-preprod.tfstate"
}

### Networking ###

vpc = {
    vpc-preprod ={
        cidr_block = "10.120.220.0/22"
    }
}

private_subnets = {
  subnet-preprod-pvt-a = {
    vpc_name            = "vpc-preprod"
    cidr_block          = "10.120.220.0/24"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = false
  }
  subnet-preprod-pvt-b = {
    vpc_name            = "vpc-preprod"
    cidr_block         = "10.120.221.0/24"
    availability_zone   = "eu-south-2b"
    map_public_ip_on_launch = false
  }
  subnet-preprod-pvt-c = {
    vpc_name            = "vpc-preprod"
    cidr_block         = "10.120.222.0/24"
    availability_zone   = "eu-south-2c"
    map_public_ip_on_launch = false
 }
}

public_subnets = {
  subnet-preprod-pub-a = {
    vpc_name            = "vpc-preprod"
    cidr_block          = "10.120.223.0/26"
    availability_zone   = "eu-south-2a"
    map_public_ip_on_launch = true
  }
  #subnet-preprod-public-b = {
  #  vpc_name            = "vpc-preprod"
  #  cidr_block         = "10.120.221.0/24"
  #  availability_zone   = "eu-south-2b"
  #  map_public_ip_on_launch = false
  #}
  #subnet-preprod-public-c = {
  #  vpc_name            = "vpc-preprod"
  #  cidr_block         = "10.120.222.0/24"
  #  availability_zone   = "eu-south-2c"
  #  map_public_ip_on_launch = false
  #}
}

eip = {
  eip-preprod-nat-prod-a ={}
}

internet_gateway = {
  igw-preprod = {
    vpc_name              = "vpc-preprod"
  }
}

nat = {
  nat-preprod-pvt-a = {
    connectivity_type     = "public"
    allocation_id         = "eip-preprod-nat-prod-a"
    subnet_id             = "subnet-preprod-pub-a"
  }
}

route_table = {
  rtbl-preprod-pvt-subnets = {
    vpc_name               = "vpc-preprod"
    route_table_name       = "rtbl-preprod-pvt-subnets"
  }
  rtbl-preprod-pub-subnets = {
    vpc_name               = "vpc-preprod"
    route_table_name       = "rtbl-preprod-pub-subnets"
  }
}

private_routes = {
  rtbl-preprod-pvt-subnets={
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_name       = "nat-preprod-pvt-a"
  }
}

public_routes ={
  rtbl-preprod-pub-subnets={
    destination_cidr_block = "0.0.0.0/0"
    igw_name = "igw-preprod"
  }  
}

route_table_association_pvt = {
  association_1 = {
    subnet_name              = "subnet-preprod-pvt-a"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }
  association_2 = {
    subnet_name              = "subnet-preprod-pvt-b"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }
  association_3 = {
    subnet_name              = "subnet-preprod-pvt-c"
    route_table_name         = "rtbl-preprod-pvt-subnets"
  }  
}

route_table_association_pub = {
  association_1 = {
    subnet_name              = "subnet-preprod-pub-a"
    route_table_name         = "rtbl-preprod-pub-subnets"
  }
}
### SG EKS ###

security_groups = {
  sg_cluster_eks = {
    vpc_name         = "vpc-preprod"
    description_rule = "Security group Cluster EKS"
    cidr_blocks_in   = ["0.0.0.0/0"]
    from_port_in     = 443
    to_port_in       = 443
    protocol_in      = "tcp"
    from_port_out    = 0
    to_port_out      = 0
    protocol_out     = "-1"
    cidr_blocks_out  = ["0.0.0.0/0"]
  }
}

### EKS Cluster ###

eks = {
  eks-preprod-genaia = {
    name                    = "eks-preprod-genaia"
    role_arn                = "arn:aws:iam::105054799343:role/eksPreProductionCluster-Role"
    vpc_name                = "vpc-preprod"
    cluster_security_group_id = "sg_cluster_eks"
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
    version-eks             = "1.28"
    subnet_name-a           ={
      subnet_name = "subnet-preprod-pvt-a"
    }
    subnet_name-b           ={
      subnet_name = "subnet-preprod-pvt-b"
    }
    subnet_name-c           ={
      subnet_name = "subnet-preprod-pvt-c"
    }
    authentication_mode      = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
    
  }
}

eks-addon ={
    addon_1 = {
      addon_name            =  "vpc-cni"
      cluster_name          =  "eks-preprod-genaia"
    }
    #addon_2 = {
    #  addon_name            =  "coredns"
    #  cluster_name           =  "eks-preprod-genaia"      
    #}       
    addon_3 = {
      addon_name            =  "kube-proxy"
      cluster_name          =  "eks-preprod-genaia"
    }  
    addon_4 = {
      addon_name            =  "eks-pod-identity-agent"
      cluster_name          =  "eks-preprod-genaia"
    }                
}

eks-nodes = {
  m7i_2xlarge = {
    cluster_name    = "eks-preprod-genaia"
    #node_group_name = "eks-preprod-genaia-nodes"
    node_role_arn   = "arn:aws:iam::105054799343:role/AmazonEKSNodeRole"
    ami_type        = "AL2_x86_64" #Amazon Linux 2
    capacity_type   = "ON_DEMAND" 
    disk_size       = "20"
    instance_types  = ["m7i.2xlarge"] # 8 CPU / 32 RAM
    subnets_name = {
      subnet_name-a = {
        subnet_name = "subnet-preprod-pvt-a"
      }
      subnet_name-b = {
        subnet_name = "subnet-preprod-pvt-b"
      }
      subnet_name-c = {
        subnet_name = "subnet-preprod-pvt-c"
      }
    }
    desired_size    = 2
    max_size        = 2
    min_size        = 2
    max_unavailable = 1
  }
}
