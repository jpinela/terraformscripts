
resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  number  = true
}



resource "aws_s3_bucket" "emrbucket" {
  bucket = "${var.s3_bucket_name}-${random_string.suffix.result}"
}

resource "aws_iam_role" "emr_role" {
  name = var.emr_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
		  #"AWS": aws_iam_role.emr_role.arn
        }
      "Action": [
              "sts:AssumeRole",
              "sts:SetContext",
			  "sts:TagSession"
              ]
      },  
    ]
  })
}

resource "aws_iam_role_policy" "emr_role_policy" {
  role = aws_iam_role.emr_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
{
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CancelSpotInstanceRequests",
                "ec2:CreateFleet",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateNetworkInterface",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteLaunchTemplate",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeImages",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInstances",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSpotInstanceRequests",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcs",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:RequestSpotInstances",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RunInstances",
                "ec2:TerminateInstances",
                "ec2:DeleteVolume",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
				"ec2:*",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListInstanceProfiles",
                "iam:ListRolePolicies",
                "iam:PassRole",
                "s3:CreateBucket",
                "s3:Get*",
                "s3:List*",
				"s3:*",
                "sdb:BatchPutAttributes",
                "sdb:Select",
                "sqs:CreateQueue",
                "sqs:Delete*",
                "sqs:GetQueue*",
                "sqs:PurgeQueue",
                "sqs:ReceiveMessage",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms",
                "application-autoscaling:RegisterScalableTarget",
                "application-autoscaling:DeregisterScalableTarget",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:DeleteScalingPolicy",
                "application-autoscaling:Describe*",
				
				"emr-serverless:*",

            ]
        },
		{
			"Effect": "Allow",
			"Action": [
				"iam:GetRole",
				"iam:PassRole"
			],
			"Resource": "*"
		},
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "spot.amazonaws.com"
                }
            }
        },
      {
        Effect = "Allow"
        Action = [
		  "elasticmapreduce:Describe*",
		  "elasticmapreduce:ListInstances",
          "elasticmapreduce:ListSteps",
          "elasticmapreduce:DescribeStep",
          "elasticmapreduce:AddJobFlowSteps",
          "elasticmapreduce:TerminateJobFlows",
		  "elasticmapreduce:GetClusterSessionCredentials",
		  
		  "elasticmapreduce:CreateEditor", 
			"elasticmapreduce:DescribeEditor",
			"elasticmapreduce:ListEditors", 
			"elasticmapreduce:DeleteEditor",

		  "elasticmapreduce:AttachEditor",
			"elasticmapreduce:DetachEditor",
			"elasticmapreduce:ListClusters",
			"elasticmapreduce:DescribeCluster",
			"elasticmapreduce:ListInstanceGroups",
			"elasticmapreduce:ListBootstrapActions"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      },
	 
    {
      "Sid": "AllowEC2ENIActionsWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:network-interface/*"
      ]
    },
    {
      "Sid": "AllowEC2ENIAttributeAction",
      "Effect": "Allow",
      "Action": [
        "ec2:ModifyNetworkInterfaceAttribute"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:network-interface/*",
        "arn:aws:ec2:*:*:security-group/*"
      ]
    },
    {
      "Sid": "AllowEC2SecurityGroupActionsWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DeleteNetworkInterfacePermission"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowDefaultEC2SecurityGroupsCreationWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSecurityGroup"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:security-group/*"
      ]
    },
    {
      "Sid": "AllowDefaultEC2SecurityGroupsCreationInVPCWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSecurityGroup"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:vpc/*"
      ]
    },
    {
      "Sid": "AllowAddingEMRTagsDuringDefaultSecurityGroupCreation",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:*:security-group/*"
    },
    {
      "Sid": "AllowEC2ENICreationWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:network-interface/*"
      ]
    },
    {
      "Sid": "AllowEC2ENICreationInSubnetAndSecurityGroupWithEMRTags",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:subnet/*",
        "arn:aws:ec2:*:*:security-group/*"
      ]
    },
    {
      "Sid": "AllowAddingTagsDuringEC2ENICreation",
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": "arn:aws:ec2:*:*:network-interface/*"
    },	 
	
	{
				"Sid": "AllowAddingTagsOnSecretsWithEMRStudioPrefix",
				"Effect": "Allow",
				"Action": "secretsmanager:TagResource",
				"Resource": "arn:aws:secretsmanager:*:*:secret:emr-studio-*"
	},
	{
				"Sid": "AllowPassingServiceRoleForWorkspaceCreation",
				"Action": "iam:PassRole",
				"Resource": [
					"arn:aws:iam::*:role/*"
				],
				"Effect": "Allow"
	}		  
	  
    ]
  })
}






resource "aws_iam_role_policy_attachment" "emr_service_role_attach" {
  role = aws_iam_role.emr_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
  }










resource "aws_iam_instance_profile" "emr_instance_profile" {
  name = "${var.emr_role_name}_instance_profile"
  role = aws_iam_role.emr_role.name
}


resource "aws_emr_cluster" "emr_cluster" {
  name          = var.cluster_name
  release_label = "emr-6.15.0"
  applications  = ["Hadoop", "Spark","Livy","JupyterEnterpriseGateway"]

  service_role  = aws_iam_role.emr_role.arn
  ec2_attributes {
    instance_profile = aws_iam_instance_profile.emr_instance_profile.arn
    subnet_id        = aws_subnet.main.id
    emr_managed_master_security_group = aws_security_group.emr_master_sg.id
    emr_managed_slave_security_group  = aws_security_group.emr_slave_sg.id
	key_name = aws_key_pair.emr_keypair.key_name
  }

  master_instance_group {
    instance_type  = "c4.large" # m5.xlarge
    instance_count = 1
  }

  core_instance_group {
    instance_type  = "c4.large" # m5.xlarge
    instance_count = var.number_of_nodes
  }

  #configurations_json = jsonencode([{
  #  Classification = "spark-log4j"
  #  Properties = {
  #    "log4j.rootCategory" = "WARN, console"
  #  }
  #}])

  termination_protection = false
  visible_to_all_users   = true
}
