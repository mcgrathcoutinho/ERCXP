# ERC20

## Introduction

ERC20 token is used to introduce the notion of fungible assets in the Ethereum ecosystem.

## Explanation of functions

1. Functions name(), symbol() and decimals() return the respective name and symbol provided during construction of the contract and the decimals used for the denomination of the ERC20 token (18 decimals by default unless overridden to set another denomination).

2. totalSupply() returns the totalSupply of tokens currently in existence, which is incremented/decremented every mint/burn

3. balanceOf() returns the token balance of a specific address

4. transfer() transfers tokens from A to B and returns true on success. Balances of both A and B are updated in the state mapping `balances`.

5. transferFrom() allows the owner of the tokens (A) and the approved spender (C) to transfer tokens from A to B. Balances of both A and B are updated in the state mapping `balances`.

6. approve() allows owners to approve spenders to spend tokens on behalf of them. The approval amounts are stored in a different mapping to allow double spending.

7. allowance() returns the allowed amount an owner has granted to the spender

8. _mint() and _burn() functions are marked internal and need to be exposed to by wrapping it with external functions in the implementation contract such as [ExampleERC20](./ExampleERC20.sol). These functions mint and burn tokens into circulation. 

## Unknown tradeoffs/assumptions

1. Use SafeERC20.sol instead of the transfer() and transferFrom() functions directly since these functions can also return false. If the return value of these functions is not checked in the implementation contract, it would be a problem and cause unintended behaviour in the application. **Teams should be especially careful with this when using extensions such as ERC20Votes.sol since they inherit from ERC20.sol directly**.
2. _mint() and _burn() functions are internal, thus exposing them to external visibility is required else tokens cannot be minted. Make sure to restrict these functions with admin modifiers since they're the crux of the supply mechanism in an application.

## Links
 - [Example Implementation](./ExampleERC20.sol)
 - [Tests for example implementation](../../../test/token/ERC20/)

## [EIP20 spec](https://eips.ethereum.org/EIPS/eip-20) maintained?
 - No

### Where does it not adhere to the spec
1. In function transferFrom(), an additional Approval event is emitted, which is not required by the EIP20 spec.
```solidity
File: ERC20.sol
141:      * Emits an {Approval} event indicating the updated allowance. This is not
142:      * required by the EIP. See the note at the beginning of {ERC20}.
```
2. The [second note](https://eips.ethereum.org/EIPS/eip-20#methods) mentioned by EIP20 spec (i.e. callers must handle false for functions returning bool success) in the beginning is not added as a comment or warning for users to avoid assuming that those functions always return true.
![](https://github.com/OpenZeppelin/openzeppelin-contracts/assets/109625274/47b1574b-9458-4e4e-9813-ebfe6fa9c6b9)