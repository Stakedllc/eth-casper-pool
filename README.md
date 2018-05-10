# eth-casper-pool
Staking pool for Casper FFG
 
Objective is to closely follow the "Centrally Managed but Trust Reduced" pool described in section 5 of the [Casper Research Paper](https://github.com/ethereum/research/blob/master/papers/casper-economics/casper_economics_basic.pdf):

Users send coins to a pool contract. The contract sends a few deposit transactions containing their combined balances, assigning Staked control over the Prepare and Commit process, and the task of keeping track of Withdrawal requests. Staked occasionally withdraws one of their deposits to accomodate users wishing to withdraw their deposits. The withdrawals go directly into the contract, which ensures each user's right to withdraw a proportional share. Users need to trust Staked not to get their deposits penalized, but Staked cannot steal the coins. 
