from time import sleep
from gateway.chains import EosClient
from gateway.config import supported_currencies, eosio_params, sleep_timeout


def main():
    eos_client = EosClient(**eosio_params)
    while True:
        for currency in supported_currencies.values():
            eos_client.fetch_new_deposits(currency['colateral_name'])
        sleep(sleep_timeout)


if __name__ == '__main__':
    main()
