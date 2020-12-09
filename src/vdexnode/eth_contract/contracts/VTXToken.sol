pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";


contract VTX is  ERC777 {

    constructor () public ERC777("Volentix", "VTX", new address[](0)) {
      _mint(msg.sender, 10000000 * 10 ** 18, "", "");
    }
}
