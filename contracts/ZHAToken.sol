// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20DailyMinter.sol";

/**
 * @dev {ERC20} token, including:
 *
 *  - Token minting with daily and global limits
 *
 * This contract uses {ERC20DailyMinter} to implement minting capability - head to
 * its documentation for details.
 */
contract ZHAToken is ERC20DailyMinter {
    uint256 private constant _GLOBAL_MINT_LIMIT = 1  * 10 ** 7; // 10 million
    uint256 private constant _DAILY_MINT_LIMIT = 1 * 10 ** 5; // 100k

    /**
     * @dev See {ERC20-constructor} and {ERC20DailyMinter-constructor}
     */
    constructor() ERC20("ZHAToken", "ZHA", 5) ERC20DailyMinter(_DAILY_MINT_LIMIT, _GLOBAL_MINT_LIMIT){
    }

    /*
    * @dev Faucet where users can request tokens.
    * This method will mint the requested `amount` of tokens to the callers address.
    *
    * It enforces a daily limit of 100k base units and a global limit of 10 million base
    * units per address.
    */
    function mint(uint256 amount) external returns (bool){
      _mint(msg.sender, amount);
      return true;
    }
}
