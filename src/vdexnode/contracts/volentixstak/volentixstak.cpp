#include "volentixstak.hpp"
#include <ctype.h>

void volentixstak::initglobal() {
   globalamount initial_global_amounts;
   _globals.get_or_create(get_self(), initial_global_amounts);
}

bool is_number(const std::string& s)
{
    return !s.empty() && std::find_if(s.begin(), 
        s.end(), [](unsigned char c) { return !std::isdigit(c); }) == s.end();
}

void volentixstak::onTransfer(name from, name to, asset quantity, string memo)
{
   if (from == TREASURY_ACC || from == get_self() || to != get_self() || from == TOKEN_ACC) {
        return;
   }
   check(is_number(memo), "must be a digit");
   uint16_t periods_num = stoi(memo);
   std::list<int> periods;
   int sum (0);
   for (int i=1;i<=10;++i) periods.push_back(i);
   bool found = (std::find(periods.begin(), periods.end(), periods_num) != periods.end());
   check(found, "Memo must be a number 1-10");
   double value = quantity.amount/10000000;
   check(value >= 10000.00000000, "Minimum stake amount of 10,000 VTX");
   check( value <= 10000000.00000000, "Exceededs 10,000,000 VTX staking limit");
   check(periods_num <= 10 && periods_num != 0, "Memo must be a number 1-10");
   _stake(from, quantity, periods_num);
}

void volentixstak::_stake(name account, asset quantity, uint16_t periods_num)
{  
   asset subsidy = calculate_subsidy(quantity, periods_num);
   auto now = current_time_point().sec_since_epoch();
   account_stake stake_table(get_self(), account.value);
   update_globals(quantity, subsidy, false);
   stake_table.emplace(get_self(), [&](auto& row){
        row.id = stake_table.available_primary_key();
        row.amount = quantity;
        row.subsidy = subsidy;
        row.unlock_timestamp = now + periods_num * STAKE_PERIOD;
      });
   
    action(
      permission_level{ get_self(), "active"_n }, 
      "volentixwork"_n, 
      "setvoter"_n, 
      account
    ).send();
}
   
void volentixstak::unstake_unlocked(name account, uint64_t timestamp)
{

   asset to_transfer = asset(0, symbol(TOKEN_SYMBOL, SYMBOL_PRE_DIGIT));
   account_stake stake_table(get_self(), account.value);
   auto itr = stake_table.begin();
   while (itr != stake_table.end()) {
      // if stake unlock timestamp is bigger just skip 
      if (timestamp < itr->unlock_timestamp) {
         itr++;
      // else transfer funds and erase record
      } else {
         to_transfer += itr->amount + itr->subsidy;
         update_globals(itr->amount, itr->subsidy, true);
         itr = stake_table.erase(itr);
      }
   }

   string memo = "unstaking fund";

   action(
      permission_level{get_self(), "active"_n},
      TOKEN_ACC,
      "transfer"_n,
      std::make_tuple(get_self(), account, to_transfer, memo)
   ).send();
  
}

void volentixstak::unstake(name owner){
   require_recipient(VOTING_CONTRACT);
   check(has_auth(owner) || has_auth(get_self()), "Auth failed");
   auto now = current_time_point().sec_since_epoch();
   unstake_unlocked(owner, now);
}

