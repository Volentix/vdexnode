#pragma once

#include <eosio/asset.hpp>
#include <eosio/system.hpp>
#include <eosio/time.hpp>
#include <eosio/eosio.hpp>
#include <eosio/transaction.hpp>
#include <eosio/singleton.hpp>
#include <string>

#define SYMBOL_PRE_DIGIT 8
#define TOKEN_SYMBOL "VTX"
#define TOKEN_ACC name("volentixgsys")
#define MIN_STAKE_AMOUNT asset(100000000000, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT))
#define MAX_STAKE_AMOUNT asset(1000000000000000, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT))
#define STAKE_PERIOD 30 * 24 * 60 * 60
#define VOTING_CONTRACT name("vdexdposvote")

using namespace eosio;
using std::string;

class[[eosio::contract("volentixstak")]] volentixstak : public contract
{
public:
   using contract::contract;

   volentixstak(name receiver, name code, datastream<const char *> ds) : contract(receiver, code, ds),
                                                                      _globals(receiver, receiver.value),
                                                                      _blacklist(receiver, receiver.value) {}


   [[eosio::on_notify("volentixgsys::transfer")]] 
   void onTransfer(name from,
                   name to,
                   asset quantity,
                   string memo);

   [[eosio::action]] 
   void unstake(name owner);

   [[eosio::action]] 
   void mockunstake(name owner, uint64_t now);

   [[eosio::action]]
   void initglobal();
   
   [[eosio::action]] 
   void addblacklist(name account);
   
   [[eosio::action]]
   void rmblacklist(name account);

   [[eosio::action]]
   void clearstakes(name account);

   [[eosio::action]]
   void clearglobals();

   static asset get_staked_amount( const name& token_contract_account, const name& account)
   {
      asset staked_amount(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
      account_stake stake_table(token_contract_account, account.value);
      auto itr = stake_table.begin();
      while (itr != stake_table.end()) {
         staked_amount += itr->amount;
         itr++;
      }
      return staked_amount;
   }

private:
   void _stake(name account, asset quantity, uint16_t periods_num);

   struct [[eosio::table]] stake
   {
      uint64_t id;
      asset amount;
      asset subsidy;
      uint32_t unlock_timestamp;

      uint64_t primary_key() const { return id; }
   };

   typedef eosio::multi_index<name("accountstake"), stake> account_stake;

   struct [[eosio::table]] globalamount
   {
      asset currently_staked = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
      asset cumulative_staked = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
      asset cumulative_subsidy = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
   };

   typedef singleton<name("globalamount"), globalamount> global_amounts;
   global_amounts _globals;

   struct [[eosio::table]] stake_blacklist
   {
      name account;
      uint64_t primary_key() const { return account.value; }
   };
   
   typedef multi_index<name("blacklist"), stake_blacklist> blacklist_table;
   blacklist_table _blacklist;

   void check_quantity(asset quantity)
   {
      check(quantity.symbol.is_valid(), "invalid symbol");
      check(quantity.is_valid(), "invalid quantity");
      check(quantity.symbol == MIN_STAKE_AMOUNT.symbol, "symbol precision mismatch");
      check(quantity >= MIN_STAKE_AMOUNT, "quantity is lower than min stake amount");
      check(quantity <= MAX_STAKE_AMOUNT, "quantity is bigger than max stake amount"); 
      
   }

   asset calculate_subsidy(asset quantity, uint16_t periods_num) 
   {
      check_quantity(quantity);
      check(periods_num <= 10, "max allowed perions num is 10 stake periods");
      double subsidy_part = ( 1 + periods_num / 10.0 ) / 100;
      asset subsidy = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
      subsidy.amount = quantity.amount * subsidy_part;
      return subsidy; 
   }

   void check_blacklist(name account);

   void update_globals(asset quantity, asset subsidy, bool unstake) 
   {
      auto globals = _globals.get();

      if (unstake) {
         globals.currently_staked -= quantity;
      } else {
         // check global limit
         check(
            globals.cumulative_staked + globals.cumulative_subsidy + quantity + subsidy <= MAX_STAKE_AMOUNT, 
            "Exceed total limit"
         );

         globals.currently_staked += quantity;
         globals.cumulative_staked += quantity;
         globals.cumulative_subsidy += subsidy;
      }

      _globals.set(globals, get_self());
   }

   void unstake_unlocked(name account, uint64_t timestamp);
};