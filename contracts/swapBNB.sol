pragma solidity ^0.4.0;

contract swapBNB {
    struct Description {
        address participant;
        uint amount;
        bytes32 secretHash;
        uint256 startTime;
        uint256 lockTime;
    }

    Description description;

    address public owner;

    constructor(address _participant) public payable{
        description.amount = msg.value;
        description.participant = _participant;
        description.secretHash = 0x09e104be3e5fbd7d3274a9944019fcabb682fdcfe47f1e627b7d296812cc0a40;
        description.startTime = now;
        description.lockTime = 48 hours;
        owner = msg.sender;
    }


    function redeem(string _secret) external returns(bool) {
        // require(msg.value == description.amount, "amount of ether is not correctly");
        require(keccak256(_secret) == description.secretHash, "secret is not correctly");
        require(description.amount == this.balance, "Inappropriate balance");
        description.participant.transfer(description.amount);
        return true;
    }


    function auditcontract() public view returns (address, uint, bytes32) {
        return (description.participant, description.amount, description.secretHash);
    }

    function getBalance() public view returns (uint) {
        return this.balance;
    }

    function refund() external returns(bool) {
        require(now > description.startTime + description.lockTime, "Too early");
        owner.transfer(description.amount);
        return true;
    }

}
