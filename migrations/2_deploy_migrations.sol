var Campaign = artifacts.require("./Campaign.sol");

module.exports = function(deployer,network,accounts) {
const userAddress = accounts[0];
deployer.deploy(Campaign,0,userAddress);
};

