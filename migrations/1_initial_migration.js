const Exchange = artifacts.require("NftExchange");

module.exports = function (deployer) {
  deployer.deploy(Exchange);
};
