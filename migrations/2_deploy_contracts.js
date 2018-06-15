var StakeToken = artifacts.require('./StakeToken.sol');
var Math= artifacts.require('./SafeMath.sol')
var AddressUtils=artifacts.require('./AddressUtils.sol')
var Casper=artifacts.require('./CasperDeposit.sol')
module.exports = function(deployer) {
  deployer.then(async () => {
await deployer.deploy(Math)
await deployer.deploy(AddressUtils)
await deployer.link(AddressUtils,StakeToken)
await deployer.link(Math,StakeToken)
let H=await deployer.deploy(StakeToken,"StakeToken","ST");
H=H.address;
await deployer.deploy(Casper,0,0,web3.eth.accounts[0],500,H)
});
}
