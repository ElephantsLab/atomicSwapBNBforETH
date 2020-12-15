pragma solidity ^0.4.0;

contract swapRopstenETH {

    string secretEther;

    struct Description {
        address initiator;
        uint amount;
        bytes32 secretHash;
        uint256 startTime;
        uint256 lockTime;
    }

    address public owner;

    Description description;

    constructor(address _initiator, bytes32 _secretHash) payable {
        description.initiator = _initiator;
        description.amount = msg.value;
        description.secretHash = _secretHash;
        owner = msg.sender;
        description.startTime = now;
        description.lockTime = 24 hours;
    }


    function getSecret() public view returns(string) {
        return secretEther;
    }


    function redeem(string _secret) external returns(bool) {
        require(keccak256(_secret) == description.secretHash, "wrong secret");
        require(description.amount == this.balance, "Inappropriate balance");
        secretEther = _secret;
        description.initiator.transfer(description.amount);
        return true;
    }

    function auditcontract() public view returns (address, uint, bytes32) {
        return (description.initiator, description.amount, description.secretHash);
    }

    function refund() external returns(bool) {
        require(now > description.startTime + description.lockTime, "Too early");
        owner.transfer(description.amount);
        return true;
    }

    function getBalance() public view returns (uint) {
        return this.balance;
    }

}
