// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

abstract contract ERC20DailyMinter is ERC20 {
  uint256 immutable private _dailyLimit;
  uint256 immutable private _globalLimit;

  struct DailyBalance {
    uint256 balance;
    uint256 day;
  }

  mapping (address => DailyBalance) private _dailyBalances;

  /*
  * @Dev Sets the values of dailyLimit and globalLimit
  *
  * See {ERC20-constructor}.
  */
  constructor(uint256 dailyLimit_, uint256 globalLimit_) {
    _dailyLimit = dailyLimit_;
    _globalLimit = globalLimit_;
  }

  /*
  * @dev Returns the maximum amount of tokens that can be minted to an address in a single day.
  */
  function dailyLimit() public view virtual returns (uint256) {
    return _dailyLimit;
  }

  /*
  * @dev Returns the maximum amount of tokens that can be minted to an address.
  */
  function globalLimit() public view virtual returns (uint256) {
    return _globalLimit;
  }

  /**
  * @dev Resets values in `_dailyBalances` for `address` if last entry is older than today
  */
  function _resetDailyBalanceIfExpired(address addr) private {
    uint256 today = block.timestamp / 1 days;

    if (today > _dailyBalances[addr].day) {
      _dailyBalances[addr].balance = 0;
      _dailyBalances[addr].day = today;
    }
  }

  /*
  * @dev Enforces limits (daily and global) before calling {ERC20-_mint}.
  *
  * See {ERC20-_mint}.
  */
  function _mint(address to, uint256 value) internal virtual override {
    _resetDailyBalanceIfExpired(to);

    uint256 newDailyBalance = _dailyBalances[to].balance + value;
    require(newDailyBalance <= dailyLimit(), "Daily limit exceeded");

    uint256 newBalance = balanceOf(to) + value;
    require(newBalance <= globalLimit(), "Global limit exceeded");

    super._mint(to, value);

    _dailyBalances[to].balance = newDailyBalance;
  }
}
