const Autopay = artifacts.require("Autopay.sol");

module.exports = function(deployer) {
  deployer.deploy(Autopay);
};
