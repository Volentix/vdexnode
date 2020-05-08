import requests
from gateway.db import GatewayTable


class EosClient:
    gateway_contract = 'vdexgateway1'
    deposits_table = 'accntdeposit'
    withdrawals_table = 'accntwithdra'

    def __init__(self, host, port):
        self._host = host
        self._port = port

    def _get_table(self, code, table, lower_bound, upper_bound, scope=None, limit=0, reverse=True):
        pass

    def get_new_deposits(self, currency):
        table_info = GatewayTable.get(currency=currency)
        lower_bound = table_info.last_row_read + 1


