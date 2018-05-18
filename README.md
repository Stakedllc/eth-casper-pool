# eth-casper-pool
Staking pool for Casper FFG using Tokens.
StakeTokens represent shares in interest generated from a Casper validator node.
Each single token accumulates a proportion of the interest that accumulates while it is in circulation.The proportion of this accumulated interest is equal to one divided by the total number of tokens in circulation.Coins go into circulation only when purchased from the Casper Deposit contract. 

A coin accumulates stake only in interest paid after the coin goes into circulation. The amount of interest previously paid at the time the coin goes into circulation is recorded and mapped to the coin with a paramter called val.This parameter divides batches of coins into different classes which will be redeemable for different amounts of accumulated interest.
Coins can only be brought into circulation by calling the function deposit() in the Casper Deposit contract which allows a user to buy coins.
A users balance of a single type of coin is stored in a mapping
 mapping (address => mapping(uint256=>uint256)) public balances;

This is called by balances[userAddress][val]  to give the number of coins of a single type a user owns

Other than the extra val parameter used in  calling  balances and the transfer function StakeTokens follow the ERC20 standard.
 
 The interest the  coin has stake in can be calculated by subtracting val from the total amount of interest generated from the Casper node  and sent to the Casper Deposit contract.

This is done in the following line of code:
uint interest=((uint(totalInterestAdded)-val)*amount)/inCirculation
where totalInterestAdded is the total amount of interest added to the Casper Deposit Contract
amount is the number of coins owned by the user being redeemed
Incirculation is the total number of coins currently in circulation.

Coins can be  transferred between users and will continue to accumulate interest value until redeemed in the Casper Deposit contract will then take them out of circulation.
This is done in the function withdraw(uint val,address to) which takes the coin type and an address which the redeemed eth will be sent to. 
This function is the only way coins can be taken out of circulations.
