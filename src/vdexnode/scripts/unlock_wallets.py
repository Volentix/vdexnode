#!/usr/bin/env python3
import subprocess

unlock = {
    # "distributvtx":"PW5JZANXxtN8t3mrDtKhmGs9tmTH5sbwHM3J3HPMqJZhdf4DrEB9v",
    "quaremachina":"PW5J8pUqvutkxRVZCJ1qgBNCUCmwocZc7DRHr6QnTbGKDtNJsJdRa",
    "volentixwvtx":"PW5JMHyTZSaVoD21oFJgUk7DsWwj3o5hknsYJdvSN9DKxxojwxbuz",
    "volentixvote":"PW5JsJXVbGQojLqtt14dsX8zy8RALfYFBnrsMwubhhsCHASqp87Ny",
    "volentixtsys":"PW5KUSsSmtUcdMmrQV2oKG5ePu3wGDJheSMBLW1cYyGsgeHvA628f",
    "volentixtst5":"PW5HxfP4np21UiCNanQxsPGagnAzEYEXXS24LJ9cUNdC4C8BF1QLH",
    "volentixsale":"PW5KSNBoxRQxc6dP5fr3n8n9ZGqdjvY84QkymvKqCrfQJZGa2PPDS",
    "volentixnode":"PW5HuwnvAuLnTJg2HhUibhQNGh3tghBj1fDnASsc1FmCfAiBij1hy",
    "vltxtknaudit":"PW5JYqVjPdodqabtZ2URb47iGBFYK6eZ82skAfDaBGDFV144w3aTw",
    "vltxstakenow":"PW5J1ok2CP7xmEd43dn1fzN6E7BXaENpioPbQT54UitsgaqdsDNSP",
    "vistribution":"PW5KKYhtT67HisBhMNKyVxiPAcBw5rEFSiRVshqS9GPe7RYSkuYWt",
    "v55555555555":"PW5K3XtMxZdJKmrsUwJn81ABAfsshESLMnbgw8nsgRUGUMFC9Ycvw",
    "v44444444444":"PW5HvM7R1eKQYutEzoHhVqw8idovYynrocszdFZEFXDWjweSKqL5p",
    "v33333333333":"PW5KjRkj1vuSDUYqGLirLfiAR14TGJCiggm2u81FcmvFTE4sJor8k",
    "v22222222222":"PW5K24xVDGzFSJFWahgoi58rMbWh4sE19dG9ERyczmmC1LciYKwAT",
    "v11111111111":"PW5HwdNt1TrmJKjrWGgcZMVFbgrp4SVkhTTWDG865o6DGhVzLz5op",
    "v11111111111":"PW5HwdNt1TrmJKjrWGgcZMVFbgrp4SVkhTTWDG865o6DGhVzLz5op",
    "vtxcustodian":"PW5JQP5pZo2NHYtvsVrzgJEfATcmAKhcXgM12uAbP6eE4D1MnGhh5",
    "volentixstak":"PW5KVt9eoBscguyX7tHBK5U88S71hYRc5QfzpGD9KgPAtRpJzfbnB"
}

retries=300
sleep_timeout=1

def unlock_wallets():
    for i in unlock:
        subprocess.Popen(["cleos", "wallet", "unlock", "-n", i, "--password", str(unlock[i])])

def open_wallets():
    for i in unlock:
        subprocess.Popen(["cleos", "wallet", "open", "-n", i])

unlock_wallets()

