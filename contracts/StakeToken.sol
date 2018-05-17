pragma solidity ^0.4.10;
import "./HumanStandardToken.sol";
import "./SafeMath.sol";
import "./CasperDeposit.sol";
contract StakeToken is HumanStandardToken{
using SafeMath for *;
//mapping(address=>uint)  localCoin;
uint OutOfCirculation;
uint outCurrentInterest;
uint totalOutInterest;
uint inCirculation;
address owner;
CasperDeposit StakeContract;
mapping(address=>bool) owners;

function StakeToken()
HumanStandardToken(10000,"StakeToken",18,"ST"){
    owners[msg.sender]=true;
    owner=msg.sender;
    OutOfCirculation=10000;
}

modifier isOwner() {
  require(owners[msg.sender]==true);
  _;
}
modifier isOriginalOwner() {
  require(msg.sender==owner);
  _;
}
function addOwner(address a) isOriginalOwner(){
  owners[a]=true;
}
function TakeOutOfCirculation(uint amount,uint val,address user) isOwner(){
  balances[user][val]=balances[user][val].sub(amount);
  //balances[owner][0]= balances[owner][0].add(amount);
  uint accumulatedInterest=((val-outCurrentInterest)*OutOfCirculation)/(OutOfCirculation+inCirculation);
  totalOutInterest+=accumulatedInterest;
  outCurrentInterest=val;
  OutOfCirculation=OutOfCirculation.add(amount);
  inCirculation=  inCirculation.sub(amount);
}

function TakeIntoCirculation(uint amount,uint val,address to) isOwner(){
  //  StakeContract=CasperDeposit(a);
    require(amount<OutOfCirculation);
    //uint val=StakeContract.getInterestAdded();
    uint accumulatedInterest=((val-outCurrentInterest)*OutOfCirculation)/(OutOfCirculation+inCirculation);
    totalOutInterest+=accumulatedInterest;
    outCurrentInterest=val;
    balances[owner][0]= balances[owner][0].sub(amount);
    balances[to][val]= amount;
    OutOfCirculation=OutOfCirculation.sub(amount);
    inCirculation=  inCirculation.add(amount);
}
function getinCirculation() returns(uint){
  return inCirculation;
}
function getOutOfCirculation() returns(uint){
  return OutOfCirculation;
}
}
