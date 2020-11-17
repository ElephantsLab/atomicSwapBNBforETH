var L2 = artifacts.require("../contracts/erc20MultySig.sol");

module.exports = function(deployer) {
    deployer.deploy(L2);
};