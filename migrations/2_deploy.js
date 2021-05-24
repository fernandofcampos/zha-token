// migrations/2_deploy.js
const ZHAToken = artifacts.require("ZHAToken");

module.exports = async function (deployer) {
  await deployer.deploy(ZHAToken);
};
