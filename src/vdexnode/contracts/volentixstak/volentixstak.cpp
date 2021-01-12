#include "volentixstak.hpp"

void volentixstak::initglobal() {
   globalamount initial_global_amounts;
   _globals.get_or_create(get_self(), initial_global_amounts);
}

void volentixstak::onTransfer(name from, name to, asset quantity, string memo)
{
   if (from == "v22222222222"_n || from == get_self() || to != get_self() || from == TOKEN_ACC) {
        return;
   }
   check(!memo.empty(), "Memo must not be empty. Must be an number 1-10");
   uint16_t periods_num = stoi(memo);
   std::string::size_type sz;  
   check(quantity.amount > 10000, "Minimum stake amount of 10000 VTX");
   check(periods_num <= 10, "Memo must be a number 1-10");
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

