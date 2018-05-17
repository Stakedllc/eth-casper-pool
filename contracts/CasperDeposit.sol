
import './StakeToken.sol';
pragma solidity ^0.4.10;
contract CasperDeposit{


mapping(address=>uint) depositTime;

int totalInterestAdded;
uint minDeposit;
uint userRatio;
uint recipientRatio;
uint interval;
uint totalDeposits;
uint price;
address recipient;
address owner;
StakeToken token;

  function CasperDeposit(uint _minDeposit,uint _interval,address _recipient,uint ratio,address _token){
    minDeposit=_minDeposit;
    interval=_interval;
    owner=msg.sender;
    recipient=_recipient;
    userRatio=ratio;
    recipientRatio=10000-ratio;
    token=StakeToken(_token);
  }
 modifier isOwner(){
   require(msg.sender==owner);
   _;
 }

  function deposit() payable {
      require(msg.value>=minDeposit);
      require(msg.value<=token.getOutOfCirculation());
      uint amount=msg.value/price;
      totalDeposits+=msg.value;
      token.TakeIntoCirculation(amount,uint(totalInterestAdded),msg.sender);

    }






function withdraw(uint val,address to){

  uint amount=token.balanceOf(msg.sender,val);
  address from=msg.sender;
  require(amount>0);
  uint interest=((uint(totalInterestAdded)-val)*amount)/token.totalSupply();
  uint valInterest=uint( ((userRatio)*(interest))/10000);
  uint rInterest=uint(((recipientRatio)*(interest))/10000);
  valInterest=valInterest+amount;
  token.TakeOutOfCirculation(amount,val,from);
  to.transfer(valInterest);
  recipient.transfer(rInterest);
}

function addInterest() payable isOwner() {
  int val=int(msg.value);
  totalInterestAdded+=val;
}

function penalize(uint amount) isOwner(){

  totalInterestAdded=totalInterestAdded-int(amount);
  recipient.transfer(amount);
}

function setInterval(uint _newinterval) isOwner(){
  interval=_newinterval;
}

function setminDeposit(uint _newminDeposit) isOwner(){
  minDeposit=_newminDeposit;
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
