import secrets
import argparse
from datetime import datetime as dt
from typing import List, Tuple
from eth_keys import keys
from eth_utils import decode_hex
import binascii, hashlib, base58, ecdsa


def ripemd160(x):
    d = hashlib.new('ripemd160')
    d.update(x)
    return d


def generate_private_key(nbytes=32):
    return secrets.token_hex(nbytes)


def generate_eth_address(private_key: str) -> str:
    private_key_bytes = decode_hex('0x' + private_key)
    private_key = keys.PrivateKey(private_key_bytes)
    pub_key = private_key.public_key
    return pub_key.to_checksum_address()


def generate_btc_address(private_key: str) -> str:
    sk = ecdsa.SigningKey.from_string(bytes.fromhex(private_key), curve=ecdsa.SECP256k1)
    vk = sk.get_verifying_key()
    publ_key = '04' + binascii.hexlify(vk.to_string()).decode()
    hash160 = ripemd160(hashlib.sha256(binascii.unhexlify(publ_key)).digest()).digest()
    publ_addr_a = b"\x00" + hash160
    checksum = hashlib.sha256(hashlib.sha256(publ_addr_a).digest()).digest()[:4]
    publ_addr_b = base58.b58encode(publ_addr_a + checksum)
    return publ_addr_b.decode()


def generate_eth_key_pair():
    private_key = generate_private_key()
    address = generate_eth_address(private_key)
    return private_key, address


def btc_key_to_wif(private_key):
    fullkey = '80' + binascii.hexlify(bytes.fromhex(private_key)).decode()
    sha256a = hashlib.sha256(binascii.unhexlify(fullkey)).hexdigest()
    sha256b = hashlib.sha256(binascii.unhexlify(sha256a)).hexdigest()
    WIF = base58.b58encode(binascii.unhexlify(fullkey+sha256b[:8]))
    return WIF.decode()


def generate_btc_key_pair():
    private_key = generate_private_key()
    address = generate_btc_address(private_key)
    return btc_key_to_wif(private_key), address


def generate_key_pair(currency):
    if currency == 'btc':
        return generate_btc_key_pair()
    elif currency == 'eth':
        return generate_eth_key_pair()
    else:
        raise ValueError(f'Unknown currency: ${currency}')


def generate_addresses(currency: str, num: int) -> List[Tuple['str', 'str']]:
    return [generate_key_pair(currency) for _ in range(num)]


def format_key_pair(key_pair: Tuple['str', 'str']) -> str:
    return '{};{}'.format(key_pair[0], key_pair[1])


def save(filename: str, addresses: List[Tuple['str', 'str']]):
    with open(filename, 'w') as f:
        f.write('private key, address\n')
        f.write('\n'.join(map(format_key_pair, addresses)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Generate blockchain addresses.')
    parser.add_argument('-c', '--currency', choices=['eth', 'btc'],
                        help='currency name addresses will be generated for')
    parser.add_argument('-n', '--num-addresses', type=int, help='number of addresses', metavar='int')
    parser.add_argument('-o', '--outfile', type=str, help='output file', metavar='str',
                        default='addresses_%H_%M_%S.csv')
    args = parser.parse_args()
    if '_%H_%M_%S' in args.outfile:
        args.outfile = 'addresses_' + dt.strftime(dt.now(), '%H_%M_%S') + '.csv'

    print(f'Writing addresses to {args.outfile} ...')
    addresses: List[Tuple['str', 'str']] = generate_addresses(args.currency, args.num_addresses)
    save(args.outfile, addresses)
