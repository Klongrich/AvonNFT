// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Erc20Minter is ERC20("Kyle Coin", "KC") {
    uint256 AmountOfCoins = 714000;

    constructor() public {
        _mint(msg.sender, AmountOfCoins);
    }
}
