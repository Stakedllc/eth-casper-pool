pragma solidity ^0.4.23;
import './ERC721Token.sol';

contract StakeToken is ERC721Token{

mapping(uint=>mapping(uint256=>address)) TokenEquityAddress;
mapping(uint=>uint) totalEquityAddress;
mapping(uint=>mapping(address=>bool)) hasEquity;
mapping(address=>bool) usingContract;
mapping(address=>uint) mintLimit;
uint tokenprice;
uint totalPurchases;
address owner;
function StateToken() {
 //ERC721Token("StakeToken","ST");
 owner=msg.sender;

}
modifier isOwner(){
require(msg.sender==owner);
_;
}
modifier isUsingContract(){
require(usingContract[msg.sender]==true);
_;
}

function addContract(address c) isOwner(){
  usingContract[c]==true;
}
function setMintLimit(uint n,address c) isOwner(){
  mintLimit[c]=n;
}
function createToken(address owner) isUsingContract() returns(uint){
//require(msg.value>=tokenprice);
totalPurchases+=msg.value;
uint t=totalSupply();
t=(t+100);
_mint(owner,t);
return t;
}




}
