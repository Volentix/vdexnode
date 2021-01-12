#pragma once

#include <eosio/asset.hpp>
#include <eosio/system.hpp>
#include <eosio/time.hpp>
#include <eosio/eosio.hpp>
#include <eosio/transaction.hpp>
#include <eosio/singleton.hpp>
#include <string>
#include "../eosio.token/include/eosio.token/eosio.token.hpp"


static const uint32_t SYMBOL_PRE_DIGIT = 8;
static const std::string TOKEN_SYMBOL = std::string("VTX");
static const eosio::name TOKEN_ACC = eosio::name("volentixtsys");
static const eosio::name TREASURY_ACC = eosio::name("volentixrez");
static const eosio::asset MIN_STAKE_AMOUNT = eosio::asset(100000000000, eosio::symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
static const eosio::asset MAX_STAKE_AMOUNT = eosio::asset(1000000000000000, eosio::symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
// #define STAKE_PERIOD 30 * 24 * 60 * 60
static const uint64_t STAKE_PERIOD = 5 * 60;
static constexpr eosio::name VOTING_CONTRACT = eosio::name("volentixvote");

using namespace eosio;
using std::string;

class[[eosio::contract("volentixstak")]] volentixstak : public contract
{
public:
   using contract::contract;

   volentixstak(name receiver, name code, datastream<const char *> ds) : contract(receiver, code, ds),
                                                                      _globals(receiver, receiver.value) 
                                                                      {}


   [[eosio::on_notify("volentixtsys::transfer")]] 
   void onTransfer(name from,
                   name to,
                   asset quantity,
                   string memo);

   [[eosio::action]] 
   void unstake(name owner);
   
   [[eosio::action]]
   void initglobal();
   

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
      check(periods_num <= 10, "max allowed periods num is 10 stake periods");
      double subsidy_part = (periods_num * ( 1 + (periods_num / 10.0) ) / 100);
      asset subsidy = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
      subsidy.amount = quantity.amount * subsidy_part;
      return subsidy; 
   }

   eosio::asset get_account_balance(){
      std::string_view str= "VTX";
      const symbol sym(str, 8);
      eosio::asset balance = eosio::token::get_balance("volentixtsys"_n, get_self(), sym.code());
      return balance;
   }

   void update_globals(asset quantity, asset subsidy, bool unstake) 
   {
      auto globals = _globals.get();
      auto balance = get_account_balance();   
      check(balance.amount > 0, "Balance must be greater than 0");
      if (unstake) {
         globals.currently_staked -= quantity;
      } else {
         check( globals.cumulative_staked + globals.cumulative_subsidy + quantity + subsidy <= balance ), "Contract needs funding for this amount");
         check( globals.cumulative_staked + globals.cumulative_subsidy + quantity + subsidy <= MAX_STAKE_AMOUNT, "Exceeded 10,000,000 VTX staking limit");
         globals.currently_staked += quantity;
         globals.cumulative_staked += quantity;
         globals.cumulative_subsidy += subsidy;
      }

      _globals.set(globals, get_self());
   }

   void unstake_unlocked(name account, uint64_t timestamp);

};
