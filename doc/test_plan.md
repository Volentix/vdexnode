Preparation
===========

**Main accounts on Jungle testnet 2** \* DONE

1.  vltxstakenow\
    *The staking contract*

2.  volentixtsys\
    *The main token contract, emulation of volentixgsys*

3.  vistribution\
    *Distribution contract*

4.  volentixvote\
    *Voting contract*

5.  volentixsale\
    Pool

**Other preparatory actions**

1.  compile Volentixgsys.cpp \* DONE\
    <https://github.com/Volentix/volentix_contracts/blob/master/volentixgsys/src/volentixgsys.cpp>

2.  Deploy main token on *volentixtsys* \* DONE

3.  Create 2.1 billion TVTX \* DONE

4.  Create volentixsale testnet account and issue balance of EOS
    volentixsale (128153044.02514328 TVTX) \* DONE

5.  Create registering node account on eosio testnet and issue
    v11111111111 1000000 TVTX

6.  Deploy vdexdposvote contract to volentixvote + ressources \* DONE

7.  Deploy vtxdistribut contract to vistribution + ressources \* DONE

8.  Deploy volentixstak contract to vltxstakenow + ressources \* DONE

9.  Mint 2 test pools of 100000.00000000 ERC-777 VTX on Ropsten \* DONE

10. Deploy custodian on v22222222222 + ressources \* DONE

11. set v22222222222 permissions for volentixtsys \* DONE

12. set v22222222222 permissions for volentixtsys \* DONE

13. Put condition for 10000 VTX staked in vltxstakenow \* DONE

14. Put condition for 10000 VTX staked in vltxcustodian \* DONE

15. Integrate oracle functionality to volentixnode

16. Reward per container selection.\* DONE

17. Uptime validation DONE

18. Initialize v22222222222 *currentbal*

19. Clear v22222222222 *balances* buffer

20. Init vltxstakenow \* DONE

21. Edit docker compose\
    Initial default values

22. prevent issuing on the Ethereum side if there are less than 8 nodes

**Docker network** \* DONE

1.  Eos wallet

2.  Openethereum

3.  Bridging oracle

4.  Bitcoin node

5.  Vdex node

Tests
=====

1.  **Staking test**

    1.  v22222222222 stakes 10000 TVTX

2.  **Persistency test**

    1.  Uptime

    2.  Less than 8 nodes

    3.  Register and unregister nodes

3.  **Authority tests**

    1.  Open, unlocks eos wallet and signs executes oracle balance
        submisssion to EOS.

    2.  Register and unregister nodes

    3.  Reward selection and funds transfer

4.  **Accuracy tests**

    1.  reward selection and funds transfer

Postulate
=========

1.  A default active private key can be used to send to oracle
    initially.

2.  Reverse proxy\
    A Nginx HTTPS reverse proxy is an intermediary proxy service which
    takes a client request, passes it on to one or more servers, and
    subsequently delivers the server's response back to the client. In
    our case for key management keosd has to be launched as daemon
    behind reverse proxy(nginx) nginx will be used to enable password
    based authentication.
