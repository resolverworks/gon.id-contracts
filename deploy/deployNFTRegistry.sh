#!/bin/bash

# Load environment variables
source .env

# Check if required variables are set
if [ -z "$CONTRACT_SYMBOL" ] || [ -z "$ETHERSCAN_API_KEY" ] || [ -z "$RPC_URL" ] || [ -z "$PRIVATE_KEY" ] || [ -z "$BASE_URI" ]; then
    echo "Error: Missing required environment variables. Please check your .env file."
    exit 1
fi

# Set contract details
CONTRACT_NAME="NFTRegistry"
CONTRACT_FILE="src/NFTRegistry.sol"

# Build the project
echo "Building the project..."
forge build

# Deploy the contract
echo "Deploying $CONTRACT_NAME from $CONTRACT_FILE..."
DEPLOYED_OUTPUT=$(ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY forge create --rpc-url $RPC_URL \
             --private-key $PRIVATE_KEY \
             $CONTRACT_FILE:$CONTRACT_NAME \
	         --verify \
	         --legacy \
             --constructor-args "$CONTRACT_NAME" "$CONTRACT_SYMBOL" "$BASE_URI" \
             --json)

echo "$DEPLOYED_OUTPUT"