Preparation
===========

**Multi blockchain test network**\
**EOSIO**

1.  2 node test network DONE

2.  add more nodes ONGOING

**ETHEREUM** TODO

1.  Set up a distributed ethereum test network with openethereum.

2.  Deploy the 777 contract onto it

3.  Setup openzeppelin tests

4.  Mint 2 test pools of 100000.00000000 ERC-777 VTX on Ropsten

**Docker network** TODO

1.  Keosd proxy

2.  Eos Node

3.  Openethereum

4.  Bridging oracle

5.  Bitcoin node

6.  Vdex node

**Docker network** \* ONGOING

1.  Eos wallet

2.  Openethereum

3.  Bridging oracle

4.  Bitcoin node

5.  Vdex node

 

Tests
=====

1.  **Staking test**

2.  **Persistency test**

    1.  Uptime TODO

    2.  Less than 8 nodes check TODO

    3.  Register and unregister nodes, updates TODO

3.  **Authority tests**

    1.  Keosd running as a reverse proxy in docker network

    2.  Reward test DONE

    3.  Oracle test

        1.  Load tests

        2.  Ressources test

    4.  Ethereum TODO

        1.  bridging oracle/custodian contract

        2.  prevent issuing on the Ethereum side if there are less than
            8 nodes

    Conclusions/Todo
    ================

    1.  Bridging oracle on ethereum watching eos pool

    2.  Reverse proxy\
        A Nginx HTTPS reverse proxy is an intermediary proxy service
        which takes a client request, passes it on to one or more
        servers, and subsequently delivers the server's response back to
        the client. In our case for key management keosd has to be
        launched as daemon behind reverse proxy(nginx) nginx will be
        used to enable password based authentication.

    3.  Ethereum oracle finance mechanism will be determined in next
        iteration

    4.  Bridging oracle persistency lock

    5.  Vdexnode config mechanism
