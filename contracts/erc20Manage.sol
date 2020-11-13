pragma solidity ^0.4.0;

contract Erc20Interface {
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);
    function burn(uint _amount, address _address) returns (bool);
}


contract erc20Manage {
    address erc20InterfaceAddress = 0xaa63c72D17795e0412420eaD1F4b3fBf2d2CD654;
    Erc20Interface erc20Contract = Erc20Interface(erc20InterfaceAddress);

    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool) {
        erc20Contract.transferFrom(_sender, _recipient, _amount);
        return true;
    }
    function burn(uint _amount) returns (bool){
        erc20Contract.burn(_amount, msg.sender);
        return true;
    }
}
