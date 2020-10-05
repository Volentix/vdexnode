#include "vtxdistribut.hpp"
#include "../volentixvote/volentixvote.hpp"

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


void vtxdistribut::calcrewards(uint32_t job_id) {
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

  std::vector<name> top_nodes = volentixvote::get_top_nodes(VOTING_CONTRACT, 
                                                            reward_iter->standby_rank_threshold,
                                                            job_id);
  uint32_t rank = 0;
  string memo;
  asset amount;
  eosio::print("Top nodes:\n");
  eosio::print(top_nodes.size());
  for (auto &node: top_nodes) {
    if (rank < reward_iter->rank_threshold) {
      amount = reward_iter->reward_amount;
      memo = reward_iter->memo;
    } else {
      amount = reward_iter->standby_amount;
      memo = reward_iter->standby_memo;
    }
    memo += " job_id: " + std::to_string(job_id) + " rank: " + std::to_string(rank+1) + " calcrewards timestamp: " + std::to_string(now); // rank starts from 1
    eosio::print(memo);
    add_reward(node, amount, memo);
    rank++;
  }
}

void vtxdistribut::add_reward(name node, asset amount, string memo) {
  node_rewards node_reward_table(get_self(), node.value);
  node_reward_table.emplace(get_self(), [&] ( auto& row ) {
    row.id = node_reward_table.available_primary_key(),
    row.amount = amount;
    row.memo = memo;
  }); 
}
//Value, exchange value, use-value, sign value
void vtxdistribut::getreward(name node) {
  require_auth(node);
  node_rewards node_reward_table(get_self(), node.value);
  auto itr = node_reward_table.begin();
  eosio::print("get reward");
  while (itr != node_reward_table.end()) {
    eosio::print(itr->amount);
    eosio::print(itr->memo);
    action(
      { get_self(), "active"_n }, 
      pool_account, 
      "payreward"_n, 
      make_tuple(node, itr->amount, itr->memo)
    ).send();
    itr = node_reward_table.erase(itr);
  }
}

void vtxdistribut::uptime(name account, const std::vector<uint32_t> &job_ids, string node_id, string memo) { 
 
  //check(!node_id.empty() || node_id == null, "Node needs to be up for rewards to work");
  dht_index dht_table(get_self(), get_self().value);
  uint64_t size = 0;
  calcrewards(1);
  calcrewards(2);
  getreward(account);
  // auto itr = dht_table.find(account.value);
  // if(itr == dht_table.end()){
  //      dht_table.emplace(get_self(), [&] ( auto& row ) {
  //      row.account = account;
  //      row.id = node_id;
  //      row.timestamp = current_time_point().sec_since_epoch();
  //     });
  // }
  
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

void vtxdistribut::checkblaclist ( name account ){ 
  auto refuse = usblacklist.find( account.value );
  check( refuse == usblacklist.end(), "Your IP is from a restricted country, cannot proceed with reward" );
}

EOSIO_DISPATCH(vtxdistribut, (setrewardrule)(getreward)(calcrewards)(uptime)(addblacklist)(rmblacklist)(initup)(rmup))