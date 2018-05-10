
contract CasperDeposit{

 mapping(address=>uint) public balances;
 mapping(address=>uint) public deposits;
mapping(address=>address) withdrawalAddress;
mapping(address=>uint) validator_Index;
mapping(address=>uint) depositTime;
uint totalValidators;
uint minDeposit;

uint interval;
address recipient;
address owner;

  function CasperDeposit(uint _minDeposit,uint _interval,address _recipient){
    minDeposit=_minDeposit;
    interval=_interval;
    owner=msg.sender;
    recipient=_recipient;
  }
 modifier isOwner(){
   require(msg.sender==owner);
   _;
 }
  function deposit(address validation_addr, address withdrawal_addr) payable {
    require(msg.value>=minDeposit);
    balances[validation_addr]=msg.value;
    deposits[validation_addr]=msg.value;
    withdrawalAddress[validation_addr]=withdrawal_addr;
    depositTime[validation_addr]=now;
    validator_Index[validation_addr]=totalValidators;
    totalValidators+=1;
}

  function  withdraw( uint validator_index) {
    //require(msg.sender==validator_Index);
    require(now-depositTime[msg.sender]>=interval);
    address to=withdrawalAddress[msg.sender];

    if(balances[msg.sender]>=deposits[msg.sender]){
    uint interest=balances[msg.sender]-deposits[msg.sender];
    uint valInterest=(95*interest)/100;
    uint rInterest=(5*interest)/100;
    valInterest+=deposits[msg.sender];
    balances[msg.sender]=0;
    deposits[msg.sender]=0;
    to.transfer(valInterest);
    recipient.transfer(rInterest);
    }
    else{
      deposits[msg.sender]=0;
      uint b=balances[msg.sender];
      balances[msg.sender]=0;
      if(b>0)
      to.transfer(b);

    }

}
function addInterest(address user,uint amount) payable isOwner() {
  require(msg.value==amount);
  balances[user]+=amount;
}

function penalize(address user,uint amount ) isOwner(){
  require(amount<balances[user]);
  balances[user]-=amount;
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
function getBalance(address user) returns(uint){
  return balances[user];
}
function getID(address user) returns(uint){
  return validator_Index[user];
}
}
