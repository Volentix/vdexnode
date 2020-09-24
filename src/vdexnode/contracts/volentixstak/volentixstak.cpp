#include "volentixstak.hpp"

void volentixstak::initglobal() {
   globalamount initial_global_amounts;
   _globals.get_or_create(get_self(), initial_global_amounts);
}

void volentixstak::onTransfer(name from, name to, asset quantity, string memo)
{
   if (from == get_self() || to != get_self() || from == TOKEN_ACC) {
        return;
  }

   // TODO: handle wrong memo
   uint16_t periods_num = stoi(memo);
   check_blacklist(from);
   _stake(from, quantity, periods_num);
}

void volentixstak::_stake(name account, asset quantity, uint16_t periods_num)
{
   asset subsidy = calculate_subsidy(quantity, periods_num);
   auto now = current_time_point().sec_since_epoch();
   account_stake stake_table(get_self(), account.value);
   
   stake_table.emplace(get_self(), [&](auto& row){
        row.id = stake_table.available_primary_key();
        row.amount = quantity;
        row.subsidy = subsidy;
        row.unlock_timestamp = now + periods_num * STAKE_PERIOD;
      });

   update_globals(quantity, subsidy, false);
   
}

void volentixstak::unstake_unlocked(name account, uint64_t timestamp)
{
   check_blacklist(account);

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

   // TODO: add some memo
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

// // For debug purposes
// void volentixstak::mockunstake(name owner, uint64_t now){
//    require_auth(get_self());
//    unstake_unlocked(owner, now);
// }

void volentixstak::addblacklist(name account)
{
   require_auth(get_self());
   auto iter = _blacklist.find(account.value);
   if (iter ==  _blacklist.end())
   {
       _blacklist.emplace(get_self(), [&](auto &row) {
         row.account = account;
      });
   }
}

void volentixstak::rmblacklist(name account)
{
   require_auth(get_self());
   auto itr = _blacklist.find(account.value);
   if (itr != _blacklist.end())
   {
      _blacklist.erase(itr);
   }
};

void volentixstak::check_blacklist(name account)
{
   auto itr = _blacklist.find(account.value);
   check(itr == _blacklist.end(), "account is blacklisted.");
};

void volentixstak::clearstakes(name account)
{
   require_auth(get_self());
   account_stake stake_table(get_self(), account.value);
   auto itr = stake_table.begin();

   while (itr != stake_table.end()) {
      itr = stake_table.erase(itr);
   }
}

void volentixstak::clearglobals()
{
   require_auth(get_self());
   globalamount initial_global_amounts;
   _globals.set(initial_global_amounts, get_self());  
}