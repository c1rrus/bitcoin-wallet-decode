# Android Bitcoin Wallet Decoder

A tool to export seeds and private keys from [Android Bitcoin Wallet](https://github.com/bitcoin-wallet/bitcoin-wallet) back-ups.

This is useful if you want to import or sweep those keys into other Bitcoin wallets, as the Android Bitcoin Wallet app does not offer a facility to export the private keys.

Likewise, if you had Bitcoin before blockchain forks like Bitcoin Cash (BCH) and/or Bitcoing Gold (BTG), then those same private keys can be used to claim your BCH or BTG balances in suitable wallet apps.

## Table of Contents

* [Safety warning](#safety)
* [Pre-requisites](#prereqs)
* [Setup](#setup)
* [Running the tool](#running)
* [Acknowledgements and more info](#credits)


## <a name="safety"></a>⚠️ Safety warning

☠️  This tool exposes your wallet's private key(s) and mnemonic seed(s) as plain text. **Use this tool at your own risk!!** ☠️

You are responsible for the keeping your keys safe.

This tool is provided as is under the [ISC open-source license](./LICENSE) with no warranty.


## <a name="prereqs"></a>Pre-requisites

You need to have [Docker](https://www.docker.com/) installed on your system.

(FWIW, this tool was developed and tested using Docker Community Edition version `17.11.0-ce` on Ubuntu Linux.)


## <a name="setup"></a>Setup

You need to perform this setup step only once. After that, you can run the tool as often as you like.

1. Git clone this repo
1. Navigate into the cloned repo
1. Pull or build the Docker image
    * EITHER pull the pre-built Docker image: `docker pull c1rrus/bitcoin-wallet-decode`
    * OR Build the Docker image yourself by running `./build.sh`
        * Note: On Linux systems you may need to do `sudo ./build.sh` as Docker commands typically need to be run as sudo.


## <a name="running"></a>Running the tool

First you need to copy the Android Bitcoin Wallet's backup file to your computer. If you're unsure how to do this, refer to their [instructions on locating the back-up files](https://github.com/bitcoin-wallet/bitcoin-wallet/blob/master/wallet/README.recover.md#locating-the-backup-files).

Then...

1. Navigate into the cloned repo (if you're not already there)
1. Run `./bitcoin-wallet-decode.sh path/to/your/wallet-backup`
    * Note: This tool runs entirely on your computer, so you can use it offline if you wish
1. You will be prompted for a password. This is the "backup password" you set in the Android Bitcoin Wallet app.

That's it! Once the process has completed, you should find 2 new files in the same directory as your `wallet-backup` file:

* `wallet-backup-seed.txt`: Contains the [mnemonic seed](https://en.bitcoin.it/wiki/Mnemonic_phrase) of your wallet
* `wallet-backup-private-keys.txt`: Contains your wallet's [WIF](https://en.bitcoin.it/wiki/Wallet_import_format) private keys



## <a name="credits"></a>Acknowledgements and more info

A **big thank you** to:
* **[Andreas Schildbach](https://github.com/schildbach) and the other [bitcoin-wallet](https://github.com/bitcoin-wallet/bitcoin-wallet) developers** for making an excellent Android app and also documenting [how to extract the keys from a backup](https://github.com/bitcoin-wallet/bitcoin-wallet/blob/master/wallet/README.recover.md)
* **[`mnemonicmind`](https://bitcointalk.org/index.php?action=profile;u=1093526)** on the [Bitcoin Talk Forum](https://bitcointalk.org/), for providing additional, very useful [instructions on extracting the keys from a backup](https://bitcointalk.org/index.php?topic=2061691.0)

This tool more or less performs the same steps the people above documented. The main differences are:

* Use of a Docker container with all the necessary tools (OpenSSL, git, BitcoinJ, etc.) so that you don't need to install them on your computer or muck about with heavy virtual machines
* Some shell scripts to automate the steps

Comments and contributions are welcome!
