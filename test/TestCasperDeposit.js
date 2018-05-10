
var Casper = artifacts.require("./CasperDeposit.sol");
//var Web3 = require('web3')
//var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:9545'))
contract('Casper', (accounts) => {

  it('deposits successfully', async function() {
   var Instance=await Casper.deployed();
   //var c= await web3.eth.getBalance(accounts[2]);
   //console.log(c)
   await Instance.deposit(accounts[2],accounts[3],{value:10*10**18,from:accounts[2]})
   //c= await web3.eth.getBalance(accounts[2]);
    await Instance.deposit(accounts[4],accounts[5],{value:10*10**18,from:accounts[4]})
   await Instance.deposit(accounts[6],accounts[7],{value:10*10**18,from:accounts[6]})
   var r1=await web3.eth.getBalance(accounts[9])
   var balance= await Instance.getBalance.call(accounts[2]);
   var Id=await Instance.getID.call(accounts[4]);
   console.log(Id)
   await Instance.withdraw(0,{from:accounts[2]});
   var otherbalance= await Instance.getBalance.call(accounts[2]);
   await Instance.addInterest(accounts[4],1*10**18,{value:1*10**18,from:accounts[0]});
   var b= await Instance.getBalance.call(accounts[4]);
   console.log(b + " this is b")
   await Instance.withdraw(1,{from:accounts[4]});
   var r= await web3.eth.getBalance(accounts[9]);
   var result=r-r1;
   console.log(result + " difference")
   console.log(otherbalance);
   await Instance.penalize(accounts[6],1*10**18)
   r1=await web3.eth.getBalance(accounts[9]);
   r=r1-r
   console.log(r)
   assert.equal(10*10**18,balance,'balance update failed');
   assert.equal(0,otherbalance,'balance update failed');
   assert.equal(((1*10**18)/20),result,"transfer to recipient failed")
   assert.equal((1*10**18),r,"transfer to recipient failed")
 })


})
