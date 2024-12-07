const Storage = artifacts.require("Ballot");

module.exports = function (deployer) {
    deployer.deploy(Storage);
};
