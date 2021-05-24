// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined here: https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the number of decimals the token uses.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the total token supply.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the account balance of another account with address `owner`
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev Transfers `value` amount of tokens to address `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Transfers `value` amount of tokens from address `from` to address `to`
     * using the allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    /**
     * @dev Allows `spender` to withdraw from your account multiple times, up to the `value` amount.
     * If this function is called again it overwrites the current allowance with `value`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Returns the amount which `spender` is still allowed to withdraw from `owner`.
     * This is zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted on successful call to {approve}.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
