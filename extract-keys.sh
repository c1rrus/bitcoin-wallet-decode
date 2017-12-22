#!/bin/bash

if [ "$1" == "" ]
then
    echo "You must provide the path to your encrypted wallet file:" >&2
    echo >&2
    echo "$0 [path-to-wallet-file]" >&2
    echo >&2
    exit 1
fi

ENCRYPTED_WALLET_FILE="$1"


# Decrypt wallet file (will prompt user for password)
echo "Decrypting wallet file: $ENCRYPTED_WALLET_FILE"
DECRYPTED_WALLET_FILE=$(mktemp)
openssl enc -d -aes-256-cbc -md md5 -a -in "$ENCRYPTED_WALLET_FILE" -out "$DECRYPTED_WALLET_FILE"

if [ $? -ne 0 ]
then
    # Clean up...
    rm "$DECRYPTED_WALLET_FILE"

    # ...and exit
    echo >&2
    echo "Wallet decryption failed." >&2
    exit 1
fi


# Dump private keys
echo "Dumping private keys"
DUMPED_KEYS_FILE=$(mktemp)
pushd /app/bitcoinj/tools
./wallet-tool dump --dump-privkeys --wallet="$DECRYPTED_WALLET_FILE" > "$DUMPED_KEYS_FILE"
popd

if [ $? -ne 0 ]
then
    # Clean up...
    rm "$DECRYPTED_WALLET_FILE"
    rm "$DUMPED_KEYS_FILE"

    # ...and exit
    echo >&2
    echo "Dumping keys failed." >&2
    exit 1
else
    # We no longer need the decrypted wallet file
    rm "$DECRYPTED_WALLET_FILE"
fi


# Extract private keys and seed
SEED_OUTPUT_FILE="${ENCRYPTED_WALLET_FILE}-seed.txt"
PRIVATE_KEYS_OUTPUT_FILE="${ENCRYPTED_WALLET_FILE}-private-keys.txt"

grep "Seed as" "$DUMPED_KEYS_FILE" > "$SEED_OUTPUT_FILE"
grep -o -E "WIF=([a-zA-Z0-9]+)" "$DUMPED_KEYS_FILE" > "$PRIVATE_KEYS_OUTPUT_FILE"
sed -i 's/WIF=//g' "$PRIVATE_KEYS_OUTPUT_FILE"

# Clean up
rm "$DUMPED_KEYS_FILE"

# All done! ^_^
echo "Finished!"
echo
echo "Seeds are in:              $SEED_OUTPUT_FILE"
echo "Private keys (WIF) are in: $PRIVATE_KEYS_OUTPUT_FILE"
