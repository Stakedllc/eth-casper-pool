
pragma solidity ^0.4.23;
import './StakeToken.sol';
import './SafeMath.sol';

contract CasperDeposit {
using SafeMath for *;
mapping(uint=>uint) public intialInterest;
mapping(uint256=>uint) public deposits;
mapping(address=>address) withdrawalAddress;
mapping(uint=>uint) validator_Index;
mapping(uint=>uint) depositTime;
StakeToken ST;
uint totalValidators;
uint totalPossibleDeposits;
uint RemainingDeposits;
uint totalInterestAdded;
uint minDeposit;
uint userRatio;
uint recipientRatio;
uint interval;
uint outCurrentInterest;
uint totalOutInterest;
address recipient;
address owner;

  function CasperDeposit(uint _minDeposit,uint _interval,address _recipient,uint ratio,address _Token,uint _totalPossibleDeposits){
    minDeposit=_minDeposit;
    interval=_interval;
    owner=msg.sender;
    recipient=_recipient;
    userRatio=ratio;
    recipientRatio=10000-ratio;
    ST=StakeToken(_Token);
    totalPossibleDeposits=_totalPossibleDeposits;
    RemainingDeposits=_totalPossibleDeposits;
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
    require(RemainingDeposits>=msg.value);
    uint coin=ST.createToken(msg.sender);

    uint accumulatedInterest=((totalInterestAdded-outCurrentInterest)*RemainingDeposits)/(totalPossibleDeposits);
    totalOutInterest=totalOutInterest.add(accumulatedInterest);
    outCurrentInterest=totalInterestAdded;

    intialInterest[coin]=totalInterestAdded;
    deposits[coin]=msg.value;
    withdrawalAddress[msg.sender]=withdrawal_addr;
    depositTime[coin]=now;
    RemainingDeposits=RemainingDeposits.sub(msg.value);
}
function depositToCoin( uint coinId)  tokenExistsandOwned(coinId) payable{
  require(msg.value>=minDeposit);
  require(RemainingDeposits>=msg.value);
  require(deposits[coinId]==0);

  uint accumulatedInterest=((totalInterestAdded.sub(outCurrentInterest))*RemainingDeposits)/(totalPossibleDeposits)+((totalInterestAdded.sub(outCurrentInterest))*RemainingDeposits)%(totalPossibleDeposits);
  totalOutInterest=totalOutInterest.add(accumulatedInterest);
  outCurrentInterest=totalInterestAdded;

  intialInterest[coinId]=totalInterestAdded;
  deposits[coinId]=msg.value;
  //withdrawalAddress[msg.sender]=withdrawal_addr;
  depositTime[coinId]=now;
  RemainingDeposits=RemainingDeposits.sub(msg.value);
}
  function  withdraw(uint256 coinId) tokenExistsandOwned(coinId){
    //require(msg.sender==validator_Index);
    //require(now-depositTime[msg.sender]>=interval);
    //require(deposits[msg.sender]>minDeposit);
    address to=withdrawalAddress[msg.sender];
    //if(to==0) revert();
    uint accumulatedInterest=((totalInterestAdded.sub(outCurrentInterest))*RemainingDeposits)/(totalPossibleDeposits);
    totalOutInterest+=accumulatedInterest;
    outCurrentInterest=totalInterestAdded;
    uint d=deposits[coinId];
    uint interest=((totalInterestAdded-intialInterest[coinId])*d)/totalPossibleDeposits;
    if( interest>0){

    uint valInterest=uint((uint(userRatio)*(interest))/10000);
    uint rInterest=uint((uint(recipientRatio)*(interest))/10000);
    valInterest=valInterest.add(d);

    deposits[coinId]=0;
    RemainingDeposits=RemainingDeposits.add(d);
    to.transfer(valInterest);
    recipient.transfer(rInterest);
    }
 else{
  deposits[coinId]=0;
  to.transfer(d);

  }
}

function addInterest() payable isOwner() {

  totalInterestAdded+=msg.value;
}
function transferInterest(uint coinId,uint amount,uint ToCoinId) tokenExistsandOwned(coinId) tokenExists(ToCoinId) {
  require(deposits[ToCoinId]==0);
  require(deposits[coinId]>=amount);
  uint d=deposits[coinId];

  uint I=intialInterest[coinId];
  deposits[coinId]=d.sub(amount);
//intialInterest[coinId]=totalInterestAdded;
  deposits[ToCoinId]=amount;
  intialInterest[ToCoinId]=I;
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
function getInterestAdded() returns(uint){
  return totalInterestAdded;
}
function getTotalDeposit() returns(uint){
  return totalPossibleDeposits-RemainingDeposits;
}
function getRemainingDeposit() returns(uint){
  return RemainingDeposits;
}
function getTotalOutInterest() returns(uint){
  return  totalOutInterest;
}
function getTotalPossibleDeposits() returns(uint){
  return totalPossibleDeposits;
}

function getMyInterest(uint coinID) returns(uint){
    uint amount=deposits[coinID];
    uint interest=((totalInterestAdded.sub(intialInterest[coinID]))*amount)/(totalPossibleDeposits) ;
    return interest;
}
function Test(uint ID) returns(address){
  address t= ST.ownerOf(ID);
  return t;
}
//function getBalance(address user) returns(uint){
  //return balances[user];
//}

}
