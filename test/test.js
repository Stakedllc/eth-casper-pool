var Casper=artifacts.require("./CasperDeposit.sol")
var Token=artifacts.require("./StakeToken.sol")

contract('TokenTest',(accounts)=>{

  it('creates Tokens with the right properties', async function() {
      var MyToken= await Token.deployed()
      var Casper1=await Casper.deployed()
      var address=Casper1.address;
      console.log(address)
      await MyToken.addContract(address,{from:accounts[0]});
      //  await MyToken.addContract(accounts[3],{from:accounts[0]});
      await MyToken.setMintLimit(1000,address,{from:accounts[0]})
        //await MyToken.setMintLimit(1000,accounts[3],{from:accounts[0]})
      await Casper1.newTokenDeposit(accounts[3],{from:accounts[3],value:1000})
      await Casper1.newTokenDeposit(accounts[3],{from:accounts[3],value:1000})
      var total= await MyToken.balanceOf(accounts[3])
      assert.equal(total,2,'tokens not minted')
})











})
