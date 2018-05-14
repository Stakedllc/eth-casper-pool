var Deposit=artifacts.require('./CasperDeposit.sol');



module.exports = function(deployer) {

deployer.deploy(Deposit,5,0,"0x5aeda56215b167893e80b4fe645ba6d5bab767de",9500);

}
