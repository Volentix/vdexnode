#pragma once

#include <eosio/asset.hpp>
#include <eosio/system.hpp>
#include <eosio/time.hpp>
#include <eosio/eosio.hpp>
#include <eosio/transaction.hpp>
#include <string>
#include <eosio/symbol.hpp>
#include <eosio/time.hpp>
#include <eosio/contract.hpp>
#include <eosio/name.hpp>
#include <eosio/singleton.hpp>

#define SYMBOL_PRE_DIGIT 8

#define TOKEN_ACC name("volentixtsys")

using namespace eosio;
using std::string;
class[[eosio::contract("vltxcstdn")]] vltxcstdn : public contract
{
int64_t vtx_precision = 100000000;
name staking_contract = ""_n;    
public:
   using contract::contract;

   vltxcstdn(name receiver, name code, datastream<const char *> ds) : contract(receiver, code, ds),
                                                                      _balances(receiver, receiver.value),
                                                                      _nodelist(receiver, receiver.value),
                                                                      _currentbal(receiver, receiver.value) {}
   [[eosio::action]] 
   void initbalance(uint64_t balance);

   [[eosio::action]] 
   void updtblnc(name account, uint64_t balance, uint64_t timestamp);
   
   [[eosio::action]] 
   void regnode(name account);
   
   [[eosio::action]]
   void rmnode(name account);

    [[eosio::action]]
   void checknode(name account);
   [[eosio::action]]
   void clearblnc();
   
private:

   struct [[eosio::table]] currentbal
   {
      uint64_t balance;
   };

   typedef eosio::singleton<name("currentbal"), currentbal> current_balance;
   current_balance _currentbal;   

   struct [[eosio::table]] balance
   {
      uint64_t id;
      name account;
      uint64_t balance;
      uint32_t timestamp;
      uint32_t local_timestamp;
      uint64_t primary_key() const { return id; }
   };

   typedef eosio::multi_index<name("balances"), balance> etherium_balances;
    etherium_balances _balances;

   struct [[eosio::table]] regnodelists
   {
      name account;
      uint64_t primary_key() const { return account.value; }
   };
   
   typedef multi_index<name("regnodelist"), regnodelists> regnodelist_table;
   regnodelist_table _nodelist;
   void check_regnodelist(name account);
};