
contract CasperDeposit{

mapping(address=>int) public intialInterest;
mapping(address=>uint) public deposits;
mapping(address=>address) withdrawalAddress;
mapping(address=>uint) validator_Index;
mapping(address=>uint) depositTime;
uint totalValidators;
uint totalDeposits;
int totalInterestAdded;
uint minDeposit;
uint userRatio;
uint recipientRatio;
uint interval;
address recipient;
address owner;

  function CasperDeposit(uint _minDeposit,uint _interval,address _recipient,uint ratio){
    minDeposit=_minDeposit;
    interval=_interval;
    owner=msg.sender;
    recipient=_recipient;
    userRatio=ratio;
    recipientRatio=10000-ratio;
  }
 modifier isOwner(){
   require(msg.sender==owner);
   _;
 }
  function deposit( address withdrawal_addr) payable {
    require(msg.value>=minDeposit);
    intialInterest[msg.sender]=totalInterestAdded;
    deposits[msg.sender]=msg.value;
    withdrawalAddress[msg.sender]=withdrawal_addr;
    depositTime[msg.sender]=now;
    if(validator_Index[msg.sender]==0){
    totalValidators+=1;
    validator_Index[msg.sender]=totalValidators;

    }
    totalDeposits+=msg.value;
}

  function  withdraw() {
    //require(msg.sender==validator_Index);
    require(now-depositTime[msg.sender]>=interval);
    require(deposits[msg.sender]>minDeposit);
    address to=withdrawalAddress[msg.sender];
    //if(to==0) revert();
    uint d=deposits[msg.sender];
    int interest=((totalInterestAdded-int(intialInterest[msg.sender]))*int(deposits[msg.sender]))/int(totalDeposits);
    if( interest>0){

    uint valInterest=uint( (int(userRatio)*(interest))/10000);
    uint rInterest=uint((int(recipientRatio)*(interest))/10000);
    valInterest+=deposits[msg.sender];

    deposits[msg.sender]=0;
    totalDeposits-=d;
    to.transfer(valInterest);
    recipient.transfer(rInterest);
    }
    else{
      totalDeposits-=d;
      deposits[msg.sender]=0;

      if(int(d)+interest>0)
      d=uint(int(d)+interest);
      to.transfer(d);

    }

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
function getDeposit(address user) returns(uint){
  return deposits[user];
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
function getID(address user) returns(uint){
  return validator_Index[user];
}
}
