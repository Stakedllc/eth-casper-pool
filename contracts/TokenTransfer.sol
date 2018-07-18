pragma solidity ^0.4.23;
import './StakeToken.sol';
import './ERC721Receiver.sol';
contract TokenTransfer{

//mapping(address=>mapping(address=>mapping(uint=>bytes32)))CoinExchangeID;

mapping(address=>mapping(bytes32=>mapping(uint=>bool)))Verify;
mapping(address=>mapping(bytes32=>uint)) sellerBalances;
mapping(bytes32=>Transaction) Agreements;
mapping(address=>mapping(uint=>bytes32)) createdTransactions;
mapping(bytes32=>bool) tokenSent;
mapping(address=>uint) totalCreated;
mapping(uint=>uint) CoinOrderCreated;
StakeToken ST;
uint counter;
 constructor(address _token){
  ST=StakeToken(_token);
  counter=0;
}
struct Transaction{
  uint price;
  uint CoinID;
  uint Time;
  address from;
  address to;
  bool paid;
  bool completed;
  bool Verified;
  bytes32 ID;
}


function RegisterTransfer(uint price,uint coinID,address from,address to ) returns(bytes32){
   counter+=1;
   bytes32 ID=sha3(from,to,coinID,counter);
   Agreements[ID]= Transaction(price,coinID,now,from,to,false,false,false,ID);
   uint t=totalCreated[msg.sender];
   createdTransactions[msg.sender][t]=ID;
   CoinOrderCreated[t]=coinID;
   totalCreated[msg.sender]+=1;
   return ID;
}


function RecipientPay(bytes32 ID) payable {
 Transaction storage TR=Agreements[ID];
 uint price=Agreements[ID].price;
 address seller=Agreements[ID].from;
 address buyer=Agreements[ID].to;
 require((Verify[seller][ID][price]==true)&&(Verify[buyer][ID][price]==true));
 if(msg.value>=price){

    sellerBalances[seller][ID]+=msg.value;
    TR.paid=true;
  }
}

function SellerTransferVerify( bytes32 ID) {
    uint T=Agreements[ID].CoinID;
   require(ST.ownerOf(T) ==address(this));

  tokenSent[ID]=true;


}
function VerifyAgreement(bytes32 ID,uint price) {
  Transaction storage TR=Agreements[ID];
  require((msg.sender==Agreements[ID].to)||(msg.sender==Agreements[ID].from));
  Verify[msg.sender][ID][price]=true;
  if((Verify[Agreements[ID].to][ID][price]==true)&&(Verify[Agreements[ID].from][ID][price]==true))
     TR.Verified=true;
}
function SellerWithDraw(bytes32 ID){

  require(tokenSent[ID]==true);
  uint B=sellerBalances[msg.sender][ID];
  sellerBalances[msg.sender][ID]=0;
  msg.sender.transfer(B);
}
function BuyerRedeem(bytes32 ID){
  require(msg.sender==Agreements[ID].to);
  require(Agreements[ID].paid==true);
  uint C = Agreements[ID].CoinID;
  ST.transferFrom(this,msg.sender,C);

}

function onERC721Received(
  address _from,
  uint256 _tokenId,
  bytes _data
)
  public
  returns(bytes4){
  uint t=CoinOrderCreated[_tokenId];
  bytes32 ID=createdTransactions[_from][t];
  tokenSent[ID]=true;
  return 0xf0b9e5ba;
  }
function GetTransactionID(address user,uint index) constant returns(bytes32){
  return createdTransactions[user][index];
}
function getTokenStatus(bytes32 ID) constant returns(bool){
  return tokenSent[ID];
}
function Test(uint ID)returns(bool){
   return ST.exists(ID);
}

}
