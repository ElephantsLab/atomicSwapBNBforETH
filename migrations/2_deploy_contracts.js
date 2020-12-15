var swapBNB = artifacts.require("../contracts/swapBNB.sol");
var swapRopstenETH  = artifacts.require("../contracts/swapRopstenETH.sol");

// module.exports = function(deployer) {
//     deployer.deploy(L2, '0xB5C77955AA1237A30039DA33c69eeBb27e2937FB', 100, '0x09e104be3e5fbd7d3274a9944019fcabb682fdcfe47f1e627b7d296812cc0a40', {from: '0xe7f85e8Fba63C41c5187F0b10410A607cD3C5BF4', value: 3000000000000000000});
// };
//
// module.exports = function(deployer) {
//     deployer.deploy(L2, '0xB5C77955AA1237A30039DA33c69eeBb27e2937FB');
// };

// module.exports = function(deployer) {
//     deployer.deploy(swapBNB, '0xB5C77955AA1237A30039DA33c69eeBb27e2937FB', {from: '0x44aa6Df282bE869bcD681dCb289e53f55fC87468', value: 3000000000000000000});
// };


module.exports = function(deployer) {
    deployer.deploy(swapRopstenETH, "0xB5C77955AA1237A30039DA33c69eeBb27e2937FB", "0x09e104be3e5fbd7d3274a9944019fcabb682fdcfe47f1e627b7d296812cc0a40", {from: "0x37e33f78a20c1E966676074E89Ae6575578f6a23", value: 1000000000000000000});
};
