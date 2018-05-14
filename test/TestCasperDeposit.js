
var Casper = artifacts.require("./CasperDeposit.sol");
//var Web3 = require('web3')
//var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))
contract('Casper', (accounts) => {

  it('deposits successfully', async function() {
   var Instance=await Casper.deployed();
   var address=await Instance.address;
   var balance= await web3.eth.getBalance(accounts[9]);
   console.log(await web3.eth.getBalance(accounts[5])+ "account 5")
   console.log(balance + " balance ");
   await Instance.deposit(accounts[3],{value:10*10**18,from:accounts[2]})
   //c= await web3.eth.getBalance(accounts[2]);
    await Instance.deposit(accounts[5],{value:10*10**18,from:accounts[4]})
   await Instance.deposit(accounts[7],{value:10*10**18,from:accounts[6]})


   //await Instance.withdraw({from:accounts[2]});

   await Instance.addInterest({value:3*10**18,from:accounts[0]});
   console.log(await Instance.getInterestAdded.call() + " added");

   await Instance.withdraw({from:accounts[4]});
   console.log(await web3.eth.getBalance(accounts[5])+ "account 5")
   var newbalance= await web3.eth.getBalance(accounts[9]);
   console.log(newbalance + " new")


   var r1=((3*10**18)/3)*(500/10000)+Number(balance);
   await Instance.penalize(4*10**18,{from:accounts[0]});
   var cb=await web3.eth.getBalance(address);
   await Instance.withdraw({from:accounts[6]});
   var cb1=await web3.eth.getBalance(address);
   console.log(cb-cb1)
   assert.equal(r1,newbalance,'withdraw does not payout properly')


 })


})
