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
cleos wallet create -n <named_wallet> --file password.pwd

```
You should see the output below: 

```console

Creating wallet: <named_wallet>
Save password to use in the future to unlock this wallet.
Without password imported keys will not be retrievable.
saving password to passwd

```

## import private key to wallets


```

cleos wallet import -n <named_wallet> 

```

Type your private key. You should see something like this:

```console

private key: imported private key for: EOS8FBXJUfbANf3xeDWPoJxnip3Ych9HjzLBr1VaXRQFdkVAxwLE7

```

## make sure the wallet is open

```
cleos wallet open -n <named_wallet>

```

## Sign transaction

Use the provided tx.json to sign the transaction. (mainnet chain-id)

```

cleos sign tx.json --public-key <eos_public_key> --chain-id aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906

```


