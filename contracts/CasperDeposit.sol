
pragma solidity ^0.4.23;
import './StakeToken.sol';


contract CasperDeposit {

mapping(uint=>int) public intialInterest;
mapping(uint256=>uint) public deposits;
mapping(address=>address) withdrawalAddress;
mapping(uint=>uint) validator_Index;
mapping(uint=>uint) depositTime;
StakeToken ST;
uint totalValidators;
uint totalDeposits;
int totalInterestAdded;
uint minDeposit;
uint userRatio;
uint recipientRatio;
uint interval;
address recipient;
address owner;

  function CasperDeposit(uint _minDeposit,uint _interval,address _recipient,uint ratio,address _Token){
    minDeposit=_minDeposit;
    interval=_interval;
    owner=msg.sender;
    recipient=_recipient;
    userRatio=ratio;
    recipientRatio=10000-ratio;
    ST=StakeToken(_Token);
  }
 modifier isOwner(){
   require(msg.sender==owner);
   _;
 }
 modifier tokenExistsandOwned(uint _token){
    require(msg.sender==ST.ownerOf(_token));
    _;
 }
 modifier tokenExists(uint _token){
    require(ST.existStatus(_token)==true);
    _;
 }
  function newTokenDeposit( address withdrawal_addr) payable {
    require(msg.value>=minDeposit);

    uint coin=ST.createToken(msg.sender);
    intialInterest[coin]=totalInterestAdded;
    deposits[coin]=msg.value;
    withdrawalAddress[msg.sender]=withdrawal_addr;
    depositTime[coin]=now;
    totalDeposits+=msg.value;
}
function depositToCoin( uint coinId)  tokenExistsandOwned(coinId) payable{
  require(msg.value>=minDeposit);
  require(deposits[coinId]==0);
  intialInterest[coinId]=totalInterestAdded;
  deposits[coinId]=msg.value;
  //withdrawalAddress[msg.sender]=withdrawal_addr;
  depositTime[coinId]=now;
}
  function  withdraw(uint256 coinId) tokenExistsandOwned(coinId){
    //require(msg.sender==validator_Index);
    //require(now-depositTime[msg.sender]>=interval);
    //require(deposits[msg.sender]>minDeposit);
    address to=withdrawalAddress[msg.sender];
    //if(to==0) revert();
    uint d=deposits[coinId];
    int interest=((totalInterestAdded-int(intialInterest[coinId]))*int(d))/int(totalDeposits);
    if( interest>0){

    uint valInterest=uint((int(userRatio)*(interest))/10000);
    uint rInterest=uint((int(recipientRatio)*(interest))/10000);
    valInterest+=d;

    deposits[coinId]=0;
    totalDeposits-=d;
    to.transfer(valInterest);
    recipient.transfer(rInterest);
 }
}

function addInterest() payable isOwner() {
  int val=int(msg.value);
  totalInterestAdded+=val;
}
function transferInterest(uint coinId,uint deposit,uint ToCoinId) tokenExistsandOwned(coinId) tokenExists(ToCoinId) {
uint d=deposits[coinId];

}

function setInterval(uint _newinterval) isOwner(){
  interval=_newinterval;
}
function setminDeposit(uint _newminDeposit) isOwner(){
  minDeposit=_newminDeposit;
}
function getDeposit(uint c) returns(uint){
  return deposits[c];
}
function getInterestAdded() returns(int){
  return totalInterestAdded;
}
function getTotalDeposit() returns(uint){
  return totalDeposits;
}
//function getBalance(address user) returns(uint){
  //return balances[user];
//}

}
