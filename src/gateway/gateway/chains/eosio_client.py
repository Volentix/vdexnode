import json
import requests
from operator import itemgetter
from gateway.db import GatewayTable, Session, AccountDeposit, DepositStatus
from gateway.utils import logger


class EosClient:
    gateway_contract = 'vdexgateway1'
    deposits_table = 'accntdeposit'
    withdrawals_table = 'accntwithdra'
    DEPOSIT_FETCH_LIMIT = 100
    db_session = Session()

    def __init__(self, nodeos_host, nodeos_port, **kwargs):
        self._host = nodeos_host
        self._port = nodeos_port

    def _get_table_rows(self, table, scope, lower_bound):
        url = f'{self._host}:{self._port}/v1/chain/get_table_rows'
        payload = {
            'json': True,
            'code': self.gateway_contract,
            'table': table,
            'table_key': '',
            'scope': scope,
            'index_position': 'primary',
            'lower_bound': str(lower_bound),
            'upper_bound': '',
            'limit': str(self.DEPOSIT_FETCH_LIMIT),
            'key_type': 'uint64_t',
            'encode_type': 'dec',
            'reverse': False,
            'show_payer': False
        }

        r = requests.post(url, data=json.dumps(payload))
        rows = r.json()['rows']
        return rows

    def fetch_new_deposits(self, currency):
        logger.info(f'Start fetching new deposists for currency {currency}.')
        table_obj = self.db_session.query(GatewayTable).filter(GatewayTable.currency == currency).first()
        if table_obj is None:
            table_obj = GatewayTable(name=self.deposits_table, currency=currency)
            self.db_session.add(table_obj)
            self.db_session.commit()

        last_id = table_obj.last_row_read
        deposits = self._get_table_rows(table=self.deposits_table, scope=currency, lower_bound=last_id + 1)
        logger.info(f'{len(deposits)} new deposits fetched deposists for currency {currency}.')
        for deposit in deposits:
            deposit_obj = AccountDeposit(
                            id=deposit['id'],
                            currency=currency,
                            account=deposit['account'],
                            amount=deposit['amount'],
                            hash=deposit['tx_hash'],
                            status=DepositStatus.pending)

            self.db_session.add(deposit_obj)

        last_id = max(
            map(
                itemgetter('id'),
                deposits
            ),
            default=last_id
        )

        table_obj.last_row_read = last_id

        self.db_session.commit()
        logger.info('Deposits saved.')
