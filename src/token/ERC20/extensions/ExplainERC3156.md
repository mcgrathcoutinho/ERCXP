# ERC3156

## Introduction

ERC3156 is a standard that implements the concept of flash loans. Flash loans are loans that are borrowed and paid back in one single atomic transaction (hence the "Flash"). This unlocks new opportunities to individuals in DeFi to take up a loan without providing any collateral (other than maybe a small fee). Additionally, the security risks posed by the concept itself are almost close to 0 since it is derived from the atomicity of a transaction on the blockchain network.

## Explanation of functions

1. [All functions from ERC20.sol](./ExplainERC3156.md/#explanation-of-functions)

2. maxFlashLoan() returns max amount of tokens available for loan. Make sure to read the comments above this function in case you are using `ERC20Capped`.

3. flashFee() returns fees required to be paid for the flash loan

4. _flashFee() returns value to flashFee() as an internal function

5. _flashFeeReceiver() returns the address of the fee recipient

6. flashLoan() allows user to take up a loan, use it and return it in the same transaction along with a fee. If loan + fee amount is not returned, the whole transaction reverts.

## Unknown tradeoffs/assumptions

1. If building a cross-chain flash loan system, make sure to verify/perform some validation in your application to ensure that an account collision (assuming some virtual account system is implemented in a root chain and branch chains create virtual accounts on this root chain using their addresses) cannot occur, which could allow an entity to use up another user's (with the same address on root chain) extra approved value (provided to cover up future fees) by calling the function flashLoan() using the virtual account. Basically, two similar addresses on chains A and B can have the same virtual account if the virtual accounts are created solely based on nonce instead of using something like chainId and nonce as the salt value.
2. _flashFee() and _flashReceiver() return 0 by default and require overloading to set non-zero values
3. maxFlashLoan() is 0 for any other token except for the current token address. To support multiple tokens, override the function to implement the required logic.
4. [Issues mentioned in ERC20.sol](../ExplainERC20.md/#unknown-tradeoffsassumptions) apply here as well.
5. Since the concept of flash loans depends on the atomicity of a transaction on the blockchain network, if in any way this atomicity is removed (intentionally/unintentionally) through future upgrades, it can pose a risk to this concept of flash loans. This is a highly unlikely scenario but just making aware of the possibility.
6. Referring to the [Security Considerations](https://eips.ethereum.org/EIPS/eip-3156#security-considerations) section in EIP can be beneficial to avoid unintended bugs

## Links
 - [Example Implementation](./ExampleERC3156.sol)
 - [Tests for example implementation](../../../../test/token/ERC20/extensions/ERC3156/)

## [EIP3156 spec](https://eips.ethereum.org/EIPS/eip-3156) maintained?
 - Yes