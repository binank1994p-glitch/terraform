#!/bin/bash
# Terraform Teardown/Destroy Script
# Usage: ./teardown.sh <environment>
# Example: ./teardown.sh dev

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

echo -e "${RED}======================================${NC}"
echo -e "${RED}WARNING: TERRAFORM DESTROY${NC}"
echo -e "${RED}======================================${NC}"
echo ""
echo -e "${YELLOW}You are about to destroy ALL resources in the '$ENVIRONMENT' environment!${NC}"
echo ""
echo -e "${RED}This action will:${NC}"
echo -e "  ${RED}• Delete all infrastructure${NC}"
echo -e "  ${RED}• Remove all resources${NC}"
echo -e "  ${RED}• Cannot be undone${NC}"
echo ""
echo -e "${YELLOW}Environment: $ENVIRONMENT${NC}"
echo ""

# Require manual confirmation
read -p "$(echo -e ${YELLOW}Are you sure you want to destroy all resources? Type 'yes' to confirm: ${NC})" CONFIRMATION

if [ "$CONFIRMATION" != "yes" ]; then
    echo -e "${GREEN}Destroy cancelled. No changes were made.${NC}"
    exit 0
fi

echo ""
echo -e "${RED}======================================${NC}"
echo -e "${RED}Destroying resources in: $ENVIRONMENT${NC}"
echo -e "${RED}======================================${NC}"
echo ""

# Navigate to environment directory
cd "$ENV_DIR" || {
    echo -e "${RED}Error: Failed to navigate to $ENV_DIR${NC}"
    exit 1
}

# Run terraform destroy
echo -e "${YELLOW}Running terraform destroy...${NC}"
if terraform destroy -auto-approve; then
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}Destroy completed successfully!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo -e "${GREEN}All resources in the '$ENVIRONMENT' environment have been destroyed.${NC}"
else
    echo ""
    echo -e "${RED}======================================${NC}"
    echo -e "${RED}Destroy failed!${NC}"
    echo -e "${RED}======================================${NC}"
    echo ""
    echo -e "${RED}Please review the error messages above and try again.${NC}"
    exit 1
fi
