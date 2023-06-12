// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

//Smart Contract that mint tokens and allows buying and selling

contract KingsCoin {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
    
    constructor() {
        name = "KingsCoin";
        symbol = "KINGS";
        decimals = 18;
        totalSupply = 10000000000;
        owner = msg.sender;
    }
    
    function mint(address _to, uint256 _value) external onlyOwner {
        require(_to != address(0), "Invalid address.");
        
        totalSupply += _value;
        balanceOf[_to] += _value;
        
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
    }
    
    function buy() external payable {
        require(msg.value > 0, "Insufficient funds.");
        
        uint256 amount = msg.value;
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        
        emit Transfer(address(0), msg.sender, amount);
    }
    
    function sell(uint256 _amount) external {
        require(_amount > 0, "Invalid amount.");
        require(balanceOf[msg.sender] >= _amount, "Insufficient balance.");
        
        uint256 amount = _amount;
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        
        payable(msg.sender).transfer(amount);
        
        emit Transfer(msg.sender, address(0), amount);
    }
}
