#!/bin/bash
# Terraform Initialization Script
# Usage: ./init.sh <environment>
# Example: ./init.sh dev

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo -e "${YELLOW}Usage: $0 <environment>${NC}"
    echo ""
    echo "Valid environments: dev, staging, prod"
    echo ""
    echo "Example: $0 dev"
    exit 1
}

# Check if environment parameter is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Environment parameter is required${NC}"
    usage
fi

ENVIRONMENT=$1

# Validate environment parameter
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    echo -e "${RED}Error: Invalid environment '$ENVIRONMENT'${NC}"
    echo -e "${YELLOW}Valid environments are: dev, staging, prod${NC}"
    exit 1
fi

# Check if environment directory exists
ENV_DIR="Environments/$ENVIRONMENT"
if [ ! -d "$ENV_DIR" ]; then
    echo -e "${RED}Error: Environment directory '$ENV_DIR' does not exist${NC}"
    exit 1
fi

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}Initializing Terraform for: $ENVIRONMENT${NC}"
echo -e "${YELLOW}======================================${NC}"
echo ""

# Navigate to environment directory
cd "$ENV_DIR" || {
    echo -e "${RED}Error: Failed to navigate to $ENV_DIR${NC}"
    exit 1
}

# Run terraform init
echo -e "${YELLOW}Running terraform init...${NC}"
if terraform init; then
    echo -e "${GREEN}✓ Terraform init completed successfully${NC}"
    echo ""
else
    echo -e "${RED}✗ Terraform init failed${NC}"
    exit 1
fi

# Run terraform fmt
echo -e "${YELLOW}Running terraform fmt...${NC}"
if terraform fmt; then
    echo -e "${GREEN}✓ Terraform fmt completed successfully${NC}"
    echo ""
else
    echo -e "${RED}✗ Terraform fmt failed${NC}"
    exit 1
fi

# Run terraform validate
echo -e "${YELLOW}Running terraform validate...${NC}"
if terraform validate; then
    echo -e "${GREEN}✓ Terraform validate completed successfully${NC}"
    echo ""
else
    echo -e "${RED}✗ Terraform validate failed${NC}"
    exit 1
fi

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Initialization completed successfully!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Review the plan: ${YELLOW}terraform plan${NC}"
echo -e "  2. Apply changes: ${YELLOW}terraform apply${NC}"
