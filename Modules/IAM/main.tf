# IAM Module - Main Configuration
# Consolidates all IAM users, roles, groups, and policies for EKS access control

################################################################################
# Admin User (Full AWS Access)
################################################################################

# Resource: AWS IAM User - Admin User (Has Full AWS Access)
resource "aws_iam_user" "admin_user" {
  name          = "${var.name_prefix}-eksadmin1"
  path          = "/"
  force_destroy = true
  tags          = var.common_tags
}

# Resource: Admin Access Policy - Attach it to admin user
resource "aws_iam_user_policy_attachment" "admin_user" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

################################################################################
# Basic User (EKS Dashboard Access Only)
################################################################################

# Resource: AWS IAM User - Basic User (No AWSConsole Access)
resource "aws_iam_user" "basic_user" {
  name          = "${var.name_prefix}-eksadmin2"
  path          = "/"
  force_destroy = true
  tags          = var.common_tags
}

# Resource: AWS IAM User Policy - EKS Dashboard Full Access
resource "aws_iam_user_policy" "basic_user_eks_policy" {
  name = "${var.name_prefix}-eks-dashboard-full-access-policy"
  user = aws_iam_user.basic_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "eks:*",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

################################################################################
# EKS Admin Role and Users
################################################################################

# Resource: AWS IAM Role - EKS Admin
resource "aws_iam_role" "eks_admin_role" {
  name = "${var.name_prefix}-eks-admin-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.name_prefix}-eks-admin-role"
  }
}

# Resource: AWS IAM Role Policy - EKS Admin
resource "aws_iam_role_policy" "eks_admin_policy" {
  name = "eks-full-access-policy"
  role = aws_iam_role.eks_admin_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "eks:*",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Resource: AWS IAM Group 
resource "aws_iam_group" "eksadmins_iam_group" {
  name = "${var.name_prefix}-eksadmins"
  path = "/"
}

# Resource: AWS IAM Group Policy
resource "aws_iam_group_policy" "eksadmins_iam_group_assumerole_policy" {
  name  = "${var.name_prefix}-eksadmins-group-policy"
  group = aws_iam_group.eksadmins_iam_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid      = "AllowAssumeOrganizationAccountRole"
        Resource = "${aws_iam_role.eks_admin_role.arn}"
      },
    ]
  })
}

# Resource: AWS IAM User 
resource "aws_iam_user" "eksadmin_user" {
  name          = "${var.name_prefix}-eksadmin3"
  path          = "/"
  force_destroy = true
  tags          = var.common_tags
}

# Resource: AWS IAM Group Membership
resource "aws_iam_group_membership" "eksadmins" {
  name = "${var.name_prefix}-eksadmins-group-membership"
  users = [
    aws_iam_user.eksadmin_user.name
  ]
  group = aws_iam_group.eksadmins_iam_group.name
}

################################################################################
# EKS Developer Role and Users
################################################################################

# Resource: AWS IAM Role - EKS Developer User
resource "aws_iam_role" "eks_developer_role" {
  name = "${var.name_prefix}-eks-developer-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.name_prefix}-eks-developer-role"
  }
}

# Resource: AWS IAM Role Policy - EKS Developer
resource "aws_iam_role_policy" "eks_developer_policy" {
  name = "eks-developer-access-policy"
  role = aws_iam_role.eks_developer_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "ssm:GetParameter",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "eks:ListUpdates",
          "eks:ListFargateProfiles",
          "eks:ListIdentityProviderConfigs",
          "eks:ListAddons",
          "eks:DescribeAddonVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Resource: AWS IAM Group 
resource "aws_iam_group" "eksdeveloper_iam_group" {
  name = "${var.name_prefix}-eksdeveloper"
  path = "/"
}

# Resource: AWS IAM Group Policy
resource "aws_iam_group_policy" "eksdeveloper_iam_group_assumerole_policy" {
  name  = "${var.name_prefix}-eksdeveloper-group-policy"
  group = aws_iam_group.eksdeveloper_iam_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid      = "AllowAssumeOrganizationAccountRole"
        Resource = "${aws_iam_role.eks_developer_role.arn}"
      },
    ]
  })
}

# Resource: AWS IAM User 
resource "aws_iam_user" "eksdeveloper_user" {
  name          = "${var.name_prefix}-eksdeveloper1"
  path          = "/"
  force_destroy = true
  tags          = var.common_tags
}

# Resource: AWS IAM Group Membership
resource "aws_iam_group_membership" "eksdeveloper" {
  name = "${var.name_prefix}-eksdeveloper-group-membership"
  users = [
    aws_iam_user.eksdeveloper_user.name
  ]
  group = aws_iam_group.eksdeveloper_iam_group.name
}

################################################################################
# EKS Read-Only Role and Users
################################################################################

# Resource: AWS IAM Role - EKS Read-Only User
resource "aws_iam_role" "eks_readonly_role" {
  name = "${var.name_prefix}-eks-readonly-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:root"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.name_prefix}-eks-readonly-role"
  }
}

# Resource: AWS IAM Role Policy - EKS Read-Only
resource "aws_iam_role_policy" "eks_readonly_policy" {
  name = "eks-readonly-access-policy"
  role = aws_iam_role.eks_readonly_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:ListRoles",
          "ssm:GetParameter",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "eks:ListUpdates",
          "eks:ListFargateProfiles",
          "eks:ListIdentityProviderConfigs",
          "eks:ListAddons",
          "eks:DescribeAddonVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Resource: AWS IAM Group 
resource "aws_iam_group" "eksreadonly_iam_group" {
  name = "${var.name_prefix}-eksreadonly"
  path = "/"
}

# Resource: AWS IAM Group Policy
resource "aws_iam_group_policy" "eksreadonly_iam_group_assumerole_policy" {
  name  = "${var.name_prefix}-eksreadonly-group-policy"
  group = aws_iam_group.eksreadonly_iam_group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Sid      = "AllowAssumeOrganizationAccountRole"
        Resource = "${aws_iam_role.eks_readonly_role.arn}"
      },
    ]
  })
}

# Resource: AWS IAM User 
resource "aws_iam_user" "eksreadonly_user" {
  name          = "${var.name_prefix}-eksreadonly1"
  path          = "/"
  force_destroy = true
  tags          = var.common_tags
}

# Resource: AWS IAM Group Membership
resource "aws_iam_group_membership" "eksreadonly" {
  name = "${var.name_prefix}-eksreadonly-group-membership"
  users = [
    aws_iam_user.eksreadonly_user.name
  ]
  group = aws_iam_group.eksreadonly_iam_group.name
}
