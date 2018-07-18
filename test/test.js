var Casper=artifacts.require("./CasperDeposit.sol")
var Token=artifacts.require("./StakeToken.sol")
var Transfer=artifacts.require("./TokenTransfer.sol")
contract('TokenTest',(accounts)=>{

  it('creates Tokens with the right properties', async function() {
      var  TT=await Transfer.deployed()
      var MyToken= await Token.deployed()
      var Casper1=await Casper.deployed()
      var address=Casper1.address;
      var tokenAddress=MyToken.deployed;
      var total= await Casper1.getTotalPossibleDeposits.call();
      console.log(address)
      await MyToken.addContract(address,{from:accounts[0]});
      //  await MyToken.addContract(accounts[3],{from:accounts[0]});
      await MyToken.setMintLimit(1000,address,{from:accounts[0]})
        //await MyToken.setMintLimit(1000,accounts[3],{from:accounts[0]})
      await Casper1.newTokenDeposit(accounts[3],{from:accounts[3],value:(total/4)})
      await Casper1.newTokenDeposit(accounts[3],{from:accounts[3],value:(total/4)})
      await Casper1.addInterest({value:20000,from:accounts[0]})
      var t1=await MyToken.tokenOfOwnerByIndex.call(accounts[3],0);
      var t2=await MyToken.tokenOfOwnerByIndex.call(accounts[3],1);
      console.log(t1+" first token" )
      console.log(t2+" second token")
      await Casper1.newTokenDeposit(accounts[4],{from:accounts[4],value:(total/4)})
      await Casper1.newTokenDeposit(accounts[4],{from:accounts[4],value:(total/4)})
      var t3=await MyToken.tokenOfOwnerByIndex.call(accounts[4],0);
      var t4=await MyToken.tokenOfOwnerByIndex.call(accounts[4],1);
      console.log(t3+" first token" )
      console.log(t4+" second token")
      console.log(await Casper1.getTotalOutInterest.call() +" total UnclaimedInterest")
      await Casper1.addInterest({value:20000,from:accounts[0]})
      var Depositbalance=await web3.eth.getBalance(address)
      console.log(Depositbalance + " contract balance")
      await Casper1.withdraw(t1,{from:accounts[3]});
      await Casper1.withdraw(t2,{from:accounts[3]});
      await Casper1.withdraw(t3,{from:accounts[4]});
      await Casper1.withdraw(t4,{from:accounts[4]});
      var Depositbalance1=await web3.eth.getBalance(address)
      console.log(Depositbalance1 + " updated contract balance")
      console.log(await Casper1.getTotalOutInterest.call() +" total UnclaimedInterest")
      var R=await Casper1.getRemainingDeposit.call()
      console.log(R)
      await Casper1.depositToCoin(t1,{from:accounts[3],value:(total/4)})
      await Casper1.addInterest({value:20000,from:accounts[0]})
      await Casper1.transferInterest(t1,(total/8),t2,{from:accounts[3]})
      await Casper1.withdraw(t1,{from:accounts[3]});
      console.log(await Casper1.getDeposit.call(t2)+" coin Deposit")
      await Casper1.withdraw(t2,{from:accounts[3]});
      console.log(await Casper1.getTotalOutInterest.call() +" total UnclaimedInterest")
      var Depositbalance2=await web3.eth.getBalance(address)
      console.log(Depositbalance2 + " updated contract balance")
      var total= await MyToken.balanceOf(accounts[3])
      assert.equal(total,2,'tokens not minted')

})

it('transfers a token properly', async function(){
  var MyToken= await Token.deployed()
  var Casper1=await Casper.deployed()
  var  TT=await Transfer.deployed()
  var TransferAddress=TT.address;
  var address=Casper1.address;
  var tokenAddress=MyToken.deployed;
  var total= await Casper1.getTotalPossibleDeposits.call();
  console.log(total)
  await MyToken.addContract(address,{from:accounts[0]});
  await MyToken.setMintLimit(1000,address,{from:accounts[0]})
  await Casper1.newTokenDeposit(accounts[3],{from:accounts[3],value:(total/4)})
  var t1=await MyToken.tokenOfOwnerByIndex.call(accounts[3],0);
  console.log(t1+" index")
  await TT.RegisterTransfer(100,t1,accounts[3],accounts[4],{from:accounts[3]})

  console.log("registed")
  var ID=await TT.GetTransactionID(accounts[3],0);
  console.log(ID)
  await TT.VerifyAgreement(ID,100,{from:accounts[3]})
  await TT.VerifyAgreement(ID,100,{from:accounts[4]})
  console.log("Verified")
  await TT.RecipientPay( ID,{from:accounts[4],value:100})

  await MyToken.safeTransferFrom(accounts[3],TransferAddress,t1,{from:accounts[3]})
  //await TT.SellerTransferVerify(ID)
  //await TT.Test(t1);
  //console.log(await MyToken.ownerOf(t1))
  var bool= await TT.getTokenStatus(ID);
  await TT.BuyerRedeem( ID,{from:accounts[4]})
  await TT.SellerWithDraw(ID);
  console.log( await MyToken.ownerOf.call(t1) )
  console.log(accounts[4])

})

});
