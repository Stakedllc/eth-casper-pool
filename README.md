# Staked's staking pool for Casper FFG

Ethereum's Casper FFG release allows you to receive "interest" on your ETH by participating in staking. You stake your ETH and run a server that validates blocks and helps to secure the Ethereum network. You can earn up to 5% if you do this correctly, but to earn this you need to ensure that your servers have 100% uptime, successfully validate nodes, and keep your servers secure from hackers.  
  
Staked's staking pools allow you to earn the yield from staking while Staked handles the technical responsibilities. There are two ways you can participate:   

1) Staking Pools: We offer a simple staking pool where you will get paid up to 4.50%. You can join at any time, and contribute as much or as little as you like. When you want to withdraw your funds, however, Ethereum requires a 4-month waiting period.   
2) Staked Casper Tokens: These tokens represent proportional interest in a staking pool run by Staked with one added benefit: they can be resold to another ETH-holder. Selling to another ETH-holder allows you to avoid the 4 month withdrawal delay, though it's important to note that the sale price isn't guaranteed and you will need to find a buyer for the tokens(we will try to help!). 

# Staking Pools 
Staked runs staking pools that allow you to earn the yield available from Casper FFG validation without the technical responsibilities or the need to have a minimum of 1500 ETH. You deposit your ETH to our staking pool

### Depositing to a pool
You deposit ETH to our staking pool by doing the following: 
[ NEED TO OUTLINE HOW TO DEPOSIT TO A SIMPLE POOL, AS ORIGINALLY OUTLINED] 

With the Casper contract, you define the Withdrawal address where the contract proceeds will be deposited. This means that we, as the pool operator, cannot steal or redirect your funds.   
[CONFIRM THIS IS ACCURATE, EVEN WITH REVENUE SPLIT?] 


## How the pool works
The pool deposits the accumulated ETH from all pool members and deposits it in the Casper contract. 


### Withdrawing from a pool
You Withdraw ETH from the staking pool by submitting a withdrawal request:  
[ NEED TO OUTLINE HOW TO DEPOSIT TO A SIMPLE POOL, AS ORIGINALLY OUTLINED] 
 
Casper imposes a four month delay on withdrawals. This is to prevent long-range attacks from dishonest validators. Since Staked is an honest validator, we are not concerned about this risk. This allows us to offer the Staked Casper Tokens described below that will allow you to avoid the withdrawal delay by selling your ownership to another investor.
 
# Staked Casper Tokens 
Staked Casper Tokens ("SCT") are an extension of staking pools with an added feature: the ability to buy or sell your interest at any time. So rather than withdrawing from the Casper contract, you can simply sell your proportional shares in the Staking Pool to another ETH-holder and avoid the four month withdrawal delay. 

SCT represent proportional ownership in a Casper staking pool run by Staked. You can purchase SCT at any time by by calling the function deposit() in the Casper Deposit contract to the contract. This adds new tokens to the circulation and deposits your ETH into the Casper contract.
 
After your ETH has been deposited to the Casper contract, the SCT tokens are eligible to earn interest. You will earn interest equal to your proportional ownership of the total number of SCT tokens that are circulating (e.g. If you own 10% of the circulating tokens, you will be entitled to 10% of the earned interest).  

We keep track of the interest you have earned by marking tokens with a parameter called val. [THINK val SHOULD BECOME interestEarnedBeforeYourDeposit]? This allows us to track the interest owed to each depositor - you are only entitled to the interest generated since you deposited your ETH to the contract. 

[How is the val parameter calculated? When is it updated?]
The val parameter tracks the total interest earned by the pool before your tokens were deposited. You're entitled to the interest that has accumulated since that time. [The term "class" feels incorrect. Isn't this just a variable on the token? Or is it a different token altogether?]

Balances are stored in the balances mapping. [Will balances[userAddress] give you your balance if you deposited coins of the same age?, or do I need to specify the interestEarnedBeforeYourDeposit] [Is balances the total of deposit + interest earned?]

This is called by balances[userAddress][val] to give the number of SCT deposited at the same time. 

SCT follows the ERC20 standard, except for the interest_earned_before_your_deposit parameter used in calling  balances and the transfer function SCT follow the ERC20 standard.
 
We calculate the interest you've earned by determining how much interest the pool has earned since you deposited: totalInterestAdded - interestEarnedBeforeYourDeposit. [totalInterestAdded should change to totalInterestEarned]. The current value of each token (interest_earned/balances[userAddress]) can be determined by [FILL IN?]


where totalInterestAdded is the total amount of interest added to the Casper Deposit Contract. [How do we update this? Do we still need to work through this?] 
amount is the number of SCT owned by the user being redeemed [Where is this used? Is this the first reference in the document?] 
Incirculation is the total number of SCT currently in circulation. [Please change Incirculation to circulatingTokenSupply. We should also have maxTokenSupply] 

SCT can be transferred between users, allowing the SCT to continue to accumulating interest until they are withdrawn from the Casper Deposit contract. Withdrawal requests will remove the SCT from the circulatingTokenSupply and initiate a withdrawal request in the Casper contract.
This is done in the function withdraw(uint val,address to) which takes the coin type and an address which the redeemed eth will be sent to. [Why do we need val? Don't we need an amount for withdrawal? If they are withdrawing all at once, we don't need val. If not, we need an amount, no?]
Depositing to the Casper contract is the only way SCT can be added to the circulating supply. Withdrawal is the only way SCT can be removed from the supply. 

