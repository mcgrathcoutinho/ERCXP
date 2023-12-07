# ERC4626

## Introduction

ERC4626 is a standard that provides a generalized vault implementation. Generalizing vaults to a specific standard has allowed different protocols to integrate with each other seamlessly, while keeping their yield generation separate from the basic functionality required by a vault.

## Explanation of functions

_tryGetAssetDecimals() - This function is called during the construction of the ERC4626 contract. It is used to retrieve the decimals of the underlying asset being set.

decimals() - Returns decimals of the underlying asset. If any offset is present between underlying asset's decimals and the vault's decimals, the offset is added to the asset's underlying decimals. The default being 18.

asset() - Returns address of underlying asset

totalAssets() - Returns underlying asset balance of the vault (since the tokens are transferred to the vault by a user during deposit)

convertToShares() - Converts assets to shares. The formula used is s = aT/B, where s = shares to mint, a = amount to deposit, T = total shares before mint, B = balance of vault before deposit.

convertToAssets() - Converts shares to assets. The formula used in a = sB/T, where a = amount to withdraw, s = shares to burn, B = balance of vault before withdraw, T = total shares before burn.

deposit()/mint() - Transfers assets from user to vault and mint shares to user. Both functions are similar and are two sides of the same coin. One takes assets as the input while the other takes shares

withdraw()/redeem() - Burns user's shares and transfers assets from vault to user. Both withdraw() and redeem() are very similar functions and are basically two sides of the same coin.

_decimalsOffset() - Returns 0 by default unless overriden to specify an offset value between underlying asset's decimals and vault's decimals.


## Unknown tradeoffs/assumptions
 - The ERC4626 contract by OZ describes the specific cases at the top of the contract. Make sure you go through them.
 - Numerous issues arise based on how fees and strategies are implemented in the logic of the protocol, thus the tradeoffs/assumptions are external.
 - Inflation attacks, missing slippage protection and first depositor issues are very common when it comes to vaults. Make sure to go through them once the logic is implemented for fees/strategies.
 - Incorrect calculations can occur when converting to shares/assets if the decimal offset is not considered. Several tokens have 6 decimals or some even have 24 decimals. Overriding decimalOffset() to ensure the decimals() of the vault are aligned is crucial.
 - Check [Security Considerations](https://eips.ethereum.org/EIPS/eip-4626#security-considerations)
 - Section will be updated as necessary

## Links
 - [Example Implementation](./ExampleERC4626.sol)
 - [Tests for example implementation](../../../../test/token/ERC20/extensions/ERC4626/)

## [EIP4626 spec](https://eips.ethereum.org/EIPS/eip-4626) maintained?
 - No, though the spec can be broken by integrators if not implemented correctly