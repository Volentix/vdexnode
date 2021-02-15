db = 'sqlite:///volentix_gateway_db'

eosio_params = {
    'nodeos_host': 'https://eos.greymass.com',
    'nodeos_port': 443,
    'keosd_host': 'localhost',
    'keosd_port': 8888,
}

supported_currencies = {
    'BTC': {
        'colateral_name': 'VBTC',
        'node_host': '',
        'node_port': '',
        'required_confirmations': 4
    },
    'ETH': {
        'colateral_name': 'VETH',
        'node_host': '',
        'node_port': '',
        'required_confirmations': 4
    }
}

logger_params = {
    'name': 'Vdex Gateway',

}

sleep_timeout = 0.5
