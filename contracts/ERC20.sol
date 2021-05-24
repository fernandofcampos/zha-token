// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

/**
 * @dev Implementation of the {IERC20} interface.
 */
contract ERC20 is IERC20 {
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name}, {symbol} and {decimals}
     */
    constructor (string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev See {IERC20-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC20-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC20-decimals}.
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual override returns (bool) {
        _transfer(msg.sender, to, value, false);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual override returns (bool) {
        _transfer(from, to, value, true);
        uint256 currentAllowance = _allowances[from][msg.sender];
        _approve(from, msg.sender, currentAllowance - value);

        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Moves tokens `value` from `from` to `to`.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     */
    function _transfer(address from, address to, uint256 value, bool checkAllowance) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if(checkAllowance) {
          uint256 currentAllowance = _allowances[from][msg.sender];
          require(currentAllowance >= value, "ERC20: transfer amount exceeds allowance");
        }

        uint256 senderBalance = _balances[from];
        require(senderBalance >= value, "ERC20: transfer amount exceeds balance");
        _balances[from] = senderBalance - value;
        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    /** @dev Creates `value` tokens and assigns them to `to` address, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address to, uint256 value) internal virtual {
        require(to != address(0), "ERC20: mint to the zero address");

        _totalSupply += value;
        _balances[to] += value;
        emit Transfer(address(0), to, value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}
