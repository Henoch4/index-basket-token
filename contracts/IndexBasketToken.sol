// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ReentrancyGuard {
    bool private _nonReentrant;
    constructor() { _nonReentrant = false; }
    modifier nonReentrant() {
        require(!_nonReentrant, "ReentrancyGuard: reentrant call");
        _nonReentrant = true;
        _;
        _nonReentrant = false;
    }
}
abstract contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() { _owner = msg.sender; emit OwnershipTransferred(address(0), _owner); }
    modifier onlyOwner() { require(_owner == msg.sender, "Ownable: caller is not the owner"); _; }
    function owner() public view returns (address) { return _owner; }
}

contract IndexBasketToken is ReentrancyGuard, Ownable {
    struct BasketComponent {
        address token;
        uint256 weightBps;
        bool active;
    }
    BasketComponent[] public components;
    mapping(address => bool) public componentExists;
    uint256 public componentCount;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    event ComponentAdded(address indexed token, uint256 weightBps);
    event ComponentRemoved(address indexed token);
    event WeightsUpdated(address indexed token, uint256 newWeightBps);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function addComponent(address token, uint256 weightBps) external onlyOwner nonReentrant {
        require(token != address(0), "Zero token");
        require(weightBps > 0 && weightBps <= 10000, "Invalid weight");
        require(!componentExists[token], "Component exists");
        BasketComponent storage c = components.push();
        c.token = token;
        c.weightBps = weightBps;
        c.active = true;
        componentCount += 1;
        componentExists[token] = true;
        emit ComponentAdded(token, weightBps);
    }

    function removeComponent(address token) external onlyOwner {
        require(componentExists[token], "Not a component");
        componentExists[token] = false;
        emit ComponentRemoved(token);
    }

    function updateWeight(address token, uint256 weightBps) external onlyOwner {
        require(componentExists[token], "Not a component");
        require(weightBps > 0 && weightBps <= 10000, "Invalid weight");
        for (uint256 i = 0; i < components.length; i++) {
            if (components[i].token == token) {
                components[i].weightBps = weightBps;
                emit WeightsUpdated(token, weightBps);
                break;
            }
        }
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Zero address");
        totalSupply += amount;
        balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        require(balances[from] >= amount, "Insufficient balance");
        balances[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    function transfer(address to, uint256 amount) external nonReentrant returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external nonReentrant returns (bool) {
        require(balances[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Insufficient allowance");
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external nonReentrant returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function balanceOf(address owner) external view returns (uint256) { return balances[owner]; }
    function allowance(address owner, address spender) external view returns (uint256) { return allowances[owner][spender]; }
    function getComponent(uint256 i) external view returns (address token, uint256 weightBps, bool active) {
        BasketComponent storage c = components[i];
        return (c.token, c.weightBps, c.active);
    }
}
