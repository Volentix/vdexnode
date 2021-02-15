# Signing with cleos tutorial


## Mac EOSIO install

### Install package manager brew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```
### Install eosio
```
brew tap eosio/eosio
brew install eosio

```


## Linux EOSIO install
```
wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
sudo apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
```

## create wallet
```
cleos wallet create -n named_wallet --file password.pwd

```
You should see the output below: 

```console

Creating wallet: named_wallet
Save password to use in the future to unlock this wallet.
Without password imported keys will not be retrievable.
saving password to passwd

```