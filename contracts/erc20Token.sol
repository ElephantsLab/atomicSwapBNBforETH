pragma solidity ^0.4.0;


interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);
}


contract erc20Token is ERC20 {

    string public constant name = "L2 Token";
    string public constant symbol = "L2";
    //uint8 public constant decimals = 18;

    mapping (address => uint) balances;
    mapping(address => mapping (address => uint256)) allowances;

    uint256 _totalSupply;
    address public owner;

    constructor() public {
        owner = msg.sender;
        _totalSupply = 14000000;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _account) external view returns (uint256) {
        return balances[_account];
    }

    function transfer(address _recipient, uint256 _amount) external returns (bool) {
        require(balances[msg.sender] >= _amount);
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function _transfer(address _sender, address _recipient, uint _amount ) private {
        require(_recipient != address(0x0));
        require(balances[_sender] >= _amount);
        balances[_sender] = safeExhaustion(balances[_sender], _amount);
        balances[_recipient] = safeOverflow(balances[_recipient], _amount);
        emit Transfer(_sender, _recipient, _amount);
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return allowances[_owner][_spender];
    }
    function approve(address _spender, uint256 _value) external returns (bool) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool) {
        //не очень понятный require
        require(allowances[_sender][msg.sender] >= _amount);
        _transfer(_sender, _recipient, _amount);
        return true;
    }

    function safeOverflow(uint256 a, uint256 b) internal pure returns(uint256) {
//        require(a + b < ((2**256)-1));
        require(a + b >= a);
        return a + b;
    }

    function safeExhaustion(uint256 a, uint256 b) internal pure returns(uint256) {
        //require(a - b >= 0);
        require(b <= a);
        return a - b;
    }
}
