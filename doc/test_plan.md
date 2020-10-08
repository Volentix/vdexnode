Preparation
===========

**Local network** \* ONGOING

**Other preparatory actions**

1.  Wallets reside on normal host  /eosio-wallet path

2.  Bash scripts run as root

3.  Open another terminal for nodeos output(tty 2)
    <https://github.com/Volentix/vdexnode/tree/master/src/vdexnode/test>

4.  Mint 2 test pools of 100000.00000000 ERC-777 VTX on Ropsten \* DONE

5.  prevent issuing on the Ethereum side if there are less than 8 nodes
    TODO

**Docker network** \* ONGOING

1.  Eos wallet

2.  Openethereum

3.  Bridging oracle

4.  Bitcoin node

5.  Vdex node

**Test network** \* DONE\
Running nodeos binary and feeding the output to second terminal enables
\"caveman\" debugging on the chain.

Tests
=====

1.  **Staking test**

    1.  v11111111111 stakes 10000.00000000 VTX DONE

2.  **Persistency test**

    1.  Uptime DONE

    2.  Less than 8 nodes DONE

    3.  Register and unregister nodes DONE

3.  **Authority tests**

    1.  Open, unlocks eos wallet and signs executes oracle balance
        submisssion to EOS. DONE

    2.  Register and unregister nodes DONE

    3.  Reward test DONE

        1.  Test job selection DONE

        2.  Test reward calculation DONE

        3.  Test transfer DONE

        4.  Test period DONE

    4.  Oracle test \* REGRESSION

        1.  Decouple eth-vtx oracle and uptime DONE

        2.  Bridge functionality ONGOING

        3.  Load tests TODO

Postulates/Todo
===============

Reverse proxy\
A Nginx HTTPS reverse proxy is an intermediary proxy service which takes
a client request, passes it on to one or more servers, and subsequently
delivers the server's response back to the client. In our case for key
management keosd has to be launched as daemon behind reverse
proxy(nginx) nginx will be used to enable password based authentication.
