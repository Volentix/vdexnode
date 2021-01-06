#include "vtxdistribut.hpp"
#include "../volentixvote/volentixvote.hpp"
#include "../volentixstak/volentixstak.hpp"
#include <algorithm>
void vtxdistribut::setrewardrule(const reward_info& rule)
{
  require_auth( treasury );
  auto reward_iterator = rewards.find(rule.reward_id);
  
  if (reward_iterator == rewards.end()) {
    rewards.emplace(treasury, [&] ( auto& row ) { 
      row = rule;
    });
  } else {
    rewards.modify(reward_iterator, treasury, [&] ( auto& row ) {
      row = rule;
    });
  } 
}


void vtxdistribut::delhistory() {
    auto itr = rewardhistory.find(1);
    while(itr!=rewardhistory.end()){
      itr = rewardhistory.erase(itr);
    }
    auto itr2 = rewardhistory.find(2);
    while(itr2!=rewardhistory.end()){
      itr2 = rewardhistory.erase(itr2);
    }

}
void vtxdistribut::calcrewards(name account, uint32_t job_id) {
  time_point_sec tps = current_time_point();
  uint32_t now = tps.sec_since_epoch();

  auto reward_iter = rewards.find(job_id);
  check(reward_iter != rewards.end(), "unknown job_id");
  auto history_iter = rewardhistory.find(job_id);
  //first reward
  if (history_iter == rewardhistory.end()) {      
      rewardhistory.emplace(get_self(), [&] ( auto& row ) {
      row.reward_id = job_id;
      row.last_timestamp = now;
    });
  // last reward history record exists
  } else {
     
      check(
        now >= history_iter->last_timestamp + reward_iter->reward_period,
        "rewards for previous period have been already calculated"
      );
      
      rewardhistory.modify(history_iter, get_self(), [&] ( auto& row ) {
      row.last_timestamp = now;
    });

  }
  
  std::vector<name> top_nodes = volentixvote::get_top_nodes(VOTING_CONTRACT, reward_iter->standby_rank_threshold, job_id);
  string memo;
  asset amount;
  for (auto &node: top_nodes) {
  	uint32_t rank  = volentixvote::get_rank(VOTING_CONTRACT, node);
    	if (rank < reward_iter->rank_threshold) {
      		amount = reward_iter->reward_amount;
      		memo = reward_iter->memo;
    	} else {
      		amount = reward_iter->standby_amount;
      		memo = reward_iter->standby_memo;
    	}
    	memo = std::to_string(job_id) + " | " + std::to_string(rank+1) + " | "  + std::to_string(now); 
   	  
    	add_reward(node, amount, memo);
  }
  
  
}

void vtxdistribut::add_reward(name node, asset amount, string memo) {
  name accnt = "volentixvote"_n;
  name scope = "volentixvote"_n;
  auto voters =  volentixvote::voters_table(accnt, scope.value);
  auto voter = voters.find(node.value);
  if (voter == voters.end()) {
      return;
  }
  for (auto itr = voters.cbegin(); itr != voters.cend(); itr++) {
	  if(itr->owner == node && itr->producers.empty()){
      return;
    }
  }

  node_rewards node_reward_table(get_self(), node.value);
  node_reward_table.emplace(get_self(), [&] ( auto& row ) {
    row.id = node_reward_table.available_primary_key(),
    row.amount = amount;
    row.memo = memo;
  });
}

void vtxdistribut::getreward(name node) {

  node_rewards node_reward_table(get_self(), node.value);
  auto itr = node_reward_table.begin();
  while(itr!=node_reward_table.end()){
    payreward(node, itr->amount, itr->memo);
    itr = node_reward_table.erase(itr);
  }
  
}

void vtxdistribut::payreward(name account, asset quantity, std::string memo)
{
  name staking_contract = "vltxstakenow"_n; 
  auto staked = volentixstak::get_staked_amount(staking_contract, account);
  const double balance_tokens = staked.amount / vtx_precision;
  if(balance_tokens >= 10000){
    std::vector<permission_level> p;
    p.push_back(permission_level{ get_self(), "active"_n });
    action(
      p, 
      vtxsys_contract, 
      "transfer"_n, 
      std::make_tuple( get_self(), account, quantity, memo )
    ).send();
  }

}


void vtxdistribut::uptime(name account, string node_id, string memo) { 
  uint64_t size = 0;
  auto job_ids_new = volentixvote::get_jobs(VOTING_CONTRACT, account);
  //hardcoded for now
  calcrewards(account, 1);
  calcrewards(account, 2);
  name accnt = "volentixvote"_n;
  name scope = "volentixvote"_n;
  auto nodes =  volentixvote::producers_table(accnt, scope.value);
  auto itr =    nodes.begin();
  for (auto itr = nodes.cbegin(); itr != nodes.cend(); itr++) {
	  getreward(itr->owner);
  }
}

void vtxdistribut::addblacklist(name account, string ip){
  require_auth( account );
    auto iterator = usblacklist.find(account.value);
    
    check(iterator == usblacklist.end(), "node already registered");
    
    usblacklist.emplace(account, [&] ( auto& row ) {
      row.account = account;
    });
}
void vtxdistribut::rmblacklist(name account){
  require_auth( account );
    
    auto iterator = usblacklist.find(account.value);
    check(iterator != usblacklist.end(), "node not found");
    
    usblacklist.erase(iterator);
}
void vtxdistribut::initup(name account){
  require_auth( account );

  name staking_contract = "vltxstakenow"_n; 
    auto staked = volentixstak::get_staked_amount(staking_contract, account);
    const double balance_tokens = staked.amount / vtx_precision;
    check(balance_tokens >= 10000, "need at least 10000 VTX staked for init");
  

    auto iterator = inituptime.find(account.value);
    
    check(iterator == inituptime.end(), "node already registered");
    time_point_sec tps = current_time_point();
    uint32_t now = tps.sec_since_epoch();

    inituptime.emplace(account, [&] ( auto& row ) {
      row.account = account;
      row.init_uptime = now;
    });
}
void vtxdistribut::rmup(name account){
  require_auth( account );
    
    auto iterator =  inituptime.find(account.value);
    check(iterator !=  inituptime.end(), "node not found");
    
    inituptime.erase(iterator);
}

void vtxdistribut::checkblacklist ( name account ){ 
  auto refuse = usblacklist.find( account.value );
  check( refuse == usblacklist.end(), "Your IP is from a restricted country, cannot proceed with reward" );
}

EOSIO_DISPATCH(vtxdistribut, (setrewardrule)(getreward)(calcrewards)(uptime)(addblacklist)(rmblacklist)(initup)(rmup))
