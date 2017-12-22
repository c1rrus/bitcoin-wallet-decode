#!/bin/bash

if [ "$1" == "" ]
then
    echo "You must provide the path to your encrypted wallet file:" >&2
    echo >&2
    echo "$0 [path-to-wallet-file]" >&2
    echo >&2
    exit 1
fi

HOST_WALLET_FILE="$1"
CONTAINER_WALLET_FILE="/app/wallet-file"

# Start the container
echo "Running container..."
CONTAINER_ID=$(docker run --rm -id bitcoin-wallet-decode)

# Copy the wallet into the container
echo "Transferring wallet file to container..."
docker cp "$HOST_WALLET_FILE" "${CONTAINER_ID}:${CONTAINER_WALLET_FILE}"

# Extract the keys (this will prompt the user for their wallet password)
echo "Running extract-keys.sh script in container..."
docker exec -ti $CONTAINER_ID /app/extract-keys.sh "${CONTAINER_WALLET_FILE}"

# Copy the extracted seeds and keys to the host
SEED_OUTPUT_FILE="${HOST_WALLET_FILE}-seed.txt"
PRIVATE_KEYS_OUTPUT_FILE="${HOST_WALLET_FILE}-private-keys.txt"

echo "Copying seed & private key files back to host..."
docker cp "${CONTAINER_ID}:${CONTAINER_WALLET_FILE}-seed.txt" "$SEED_OUTPUT_FILE"
docker cp "${CONTAINER_ID}:${CONTAINER_WALLET_FILE}-private-keys.txt" "$PRIVATE_KEYS_OUTPUT_FILE"

echo "Deleting wallet, seed & private key files from container..."
docker exec -ti $CONTAINER_ID /app/clean-up.sh "${CONTAINER_WALLET_FILE}"

echo "Stopping container..."
docker stop $CONTAINER_ID > /dev/null

echo "DONE!"
echo
echo "Seeds are in:              $SEED_OUTPUT_FILE"
echo "Private keys (WIF) are in: $PRIVATE_KEYS_OUTPUT_FILE"
echo
