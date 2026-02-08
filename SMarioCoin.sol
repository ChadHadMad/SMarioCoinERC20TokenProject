// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SMarioCoin {
    string public name = "SMarioCoin";
    string public symbol = "SMC";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) private balances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
         _;
    }

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        balances[owner] = totalSupply;

        emit Transfer(address(0), owner, totalSupply);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid address");

        uint256 value = amount;
        totalSupply += value;
        balances[to] += value;

        emit Mint(to, value);
    }

    function burn(uint256 amount) public onlyOwner {
        uint256 value = amount ;
        require(balances[owner] >= value, "Not enough tokens to burn");

        balances[owner] -= value;
        totalSupply -= value;

        emit Burn(owner, value);
    }
}