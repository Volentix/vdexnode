Preparation
===========

**Main accounts on Jungle testnet 2**

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

1.  Deploy main token on *volentixtsys*

2.  Create 2.1 million TVTX

3.  Create volentixsale testnet account and isssue balance of EOS
    volentixsale

4.  Deploy vdexdposvote contract to volentixvote + ressources

5.  Deploy vtxdistribut contract to vistribution + ressources

6.  Deploy volentixstak contract to vltxstakenow + ressources

7.  Mint 2 test pools of 100000.00000000 ERC-777 VTX on Ropsten

8.  Deploy custodian on v22222222222 + ressources

9.  set v22222222222 permissions for volentixtsys

10. Initialize v22222222222 *currentbal*

11. Clear v22222222222 *balances* buffer

12. Make vltxstakenow, vistribution, and v22222222222 use volentixvote
    registration

13. Put condition for 10000 VTX

14. Ensure uptime is respected

15. prevent issuing on the Ethereum side if there are less than 8 nodes

**Docker network**\

1.  eos wallet

2.  Openethereum

3.  Bridging oracle

4.  Bitcoin node

5.  Vdex node

Tests
=====

1.  **Persistency test**

    1.  uptime

    2.  Less than 8 nodes

    3.  Register nodes unregister nodes
