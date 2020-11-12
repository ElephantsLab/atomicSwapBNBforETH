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

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint256)) allowances;
    //    mapping(address => uint) votes;
    //    mapping(address => address[]) votesAccounts;
    mapping(address => VotingOwners) votesAccounts;


    uint256 _totalSupply;
    uint totalReward;
    address[] public owners;
    address[] public ownersVoting;
    address[] allHolders;

    struct VotingOwners {
        uint votes;
        mapping(address => bool) voters;
        bool isHolder;
    }

    //    VotingOwners[] ownersVotes;

    uint256 startTime = now;

    constructor() public {
        owners.push(msg.sender);
        owners.push(0xa2f926618D2C4AD77262C66b3ae7B836d3a783A6);
        _totalSupply = 14000000;
        balances[owners[0]] = 7000000;
        balances[owners[1]] = 7000000;
    }

    event Burn(uint256 value);
    event Voting(address account);
    event newOwner(address account);

    modifier someOwner(uint _amount) {
        bool tmp = false;
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                tmp = true;
                require(msg.sender == owners[i], "Only owner can call this function.");
                require(balances[owners[i]] >= _amount, "Owner's balance is not inappropriate");
                break;
            }
        }
        require(tmp == true);
        require(now > startTime + 5 minutes);
        _;
    }



    modifier isOwner(address _user) {
        bool tmp = false;
        for (uint i = 0; i < owners.length; i++) {
            //            if (owners[i] == _user) {
            //                require(_user != owners[i], "This account already is owner.");
            //            }
            if (owners[i] == msg.sender) {
                tmp = true;
                require(msg.sender == owners[i], "Only owner can call this function.");
                break;
            }

        }
        require(tmp == true);
        require(votesAccounts[_user].voters[msg.sender] == false, "One owner can vote only once");
        _;
    }

    modifier userIsOwner(address _user) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _user) {
                require(_user != owners[i], "This account already is owner.");
            }
        }
        _;
    }

    function() public payable {
        totalReward = address(this).balance;
        withdrawReward();
    }

    function withdrawReward() private {
        for (uint i = 0; i < allHolders.length; i++) {
            if (balances[allHolders[i]] > 0) {
                uint reward = totalReward * balances[allHolders[i]] / _totalSupply;
                allHolders[i].transfer(reward);
            }
        }
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function votesAmount(address _account) external view returns (uint256) {
        return votesAccounts[_account].votes;
    }

    function balanceOf(address _account) external view returns (uint256) {
        return balances[_account];
    }

    function transfer(address _recipient, uint256 _amount) external returns (bool) {
        require(balances[msg.sender] >= _amount);
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function _transfer(address _sender, address _recipient, uint _amount) private {
        require(_recipient != address(0x0));
        require(balances[_sender] >= _amount);
        balances[_sender] = safeExhaustion(balances[_sender], _amount);
        balances[_recipient] = safeOverflow(balances[_recipient], _amount);

        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == _recipient) {
                emit Transfer(_sender, _recipient, _amount);
                return;
            }
        }
        if (votesAccounts[_recipient].isHolder == false) {
            allHolders.push(_recipient);
            votesAccounts[_recipient].isHolder == true;
        }

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

    //    function burn(uint _amount) someOwner(_amount) returns (bool) {
    ////        require(owner == msg.sender);
    //        _totalSupply = safeExhaustion(_totalSupply, _amount);
    //        balances[msg.sender] = safeExhaustion(balances[msg.sender], _amount);
    //        emit Burn(_amount);
    //        return true;
    //    }

    function burn(uint _amount) someOwner(_amount) returns (bool) {
        _totalSupply = safeExhaustion(_totalSupply, _amount);
        balances[msg.sender] = safeExhaustion(balances[msg.sender], _amount);
        emit Burn(_amount);
        return true;
    }

    //    function voting(address _user) isOwner() public{
    //        votes[_user] += 1;
    //        Voting(_user);
    //        if (votes[_user] > (owners.length / 2)) {
    //            owners.push(_user);
    //            newOwner(_user);
    //            for (uint i = 0; i < ownersVoting.length; i++) {
    //                if (ownersVoting[i] == _user) {
    //                    remove(i);
    //                    votes[_user] = 0;
    //                }
    //            }
    //
    //        }
    //        if (ownersVoting.length == 0) {
    //            ownersVoting.push(_user);
    //        }
    //        else {
    //            for (uint j = 0; j < ownersVoting.length; j++) {
    //                if (ownersVoting[j] == _user) {
    //                    require(ownersVoting[j] == _user);
    //                }
    //            }
    //            ownersVoting.push(_user);
    //        }
    //    }

    function voting(address _user) isOwner(_user) userIsOwner(_user) public {
        votesAccounts[_user].votes += 1;
        votesAccounts[_user].voters[msg.sender] = true;
        emit Voting(_user);
        if (votesAccounts[_user].votes > (owners.length / 2)) {
            owners.push(_user);
            emit newOwner(_user);
            for (uint i = 0; i < ownersVoting.length; i++) {
                if (ownersVoting[i] == _user) {
                    remove(i);
                    votesAccounts[_user].votes = 0;
                }
            }

        }
        if (ownersVoting.length == 0) {
            ownersVoting.push(_user);
        }
        else {
            for (uint j = 0; j < ownersVoting.length; j++) {
                if (ownersVoting[j] == _user) {
                    require(ownersVoting[j] == _user);
                }
            }
            ownersVoting.push(_user);
        }
    }

    function remove(uint index)  returns (address[]) {
        if (index >= ownersVoting.length) return;

        for (uint i = index; i < ownersVoting.length - 1; i++) {
            ownersVoting[i] = ownersVoting[i + 1];
        }
        ownersVoting.length--;
        return ownersVoting;
    }

    function safeOverflow(uint256 a, uint256 b) internal pure returns (uint256) {
        //        require(a + b < ((2**256)-1));
        require(a + b >= a);
        return a + b;
    }

    function safeExhaustion(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(a - b >= 0);
        require(b <= a);
        return a - b;
    }
}
