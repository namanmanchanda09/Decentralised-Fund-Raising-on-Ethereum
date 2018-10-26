var Campaign = artifacts.require("./Campaign.sol");

module.exports = function(deployer,accounts) {

deployer.deploy(Campaign,0,web3.eth.getAccounts[0]);
};

