var Deposit=artifacts.require('./CasperDeposit.sol');
var Token=artifacts.require('./StakeToken.sol');
var math=artifacts.require('./SafeMath.sol');

module.exports = function(deployer) {

deployer.then(async () => {

await deployer.deploy(math);
await deployer.link(math,Token);
await deployer.deploy(Token);
let H=await Token.deployed();
H=H.address;
await deployer.deploy(Deposit,5,0,"0x5aeda56215b167893e80b4fe645ba6d5bab767de",9500,H);

  })
}
