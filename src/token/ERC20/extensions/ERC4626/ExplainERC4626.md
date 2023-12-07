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

deposit() - Transfers assets from user to vault and mint shares to user

mint() - Mints shares to user amd may or may not require user to deposit assets.

withdraw()/redeem() - Burns user's shares and transfers assets from vault to user. Both withdraw() and redeem() are very similar functions and are basically two sides of the same coin.

_decimalsOffset() - Returns 0 by default unless overriden to specify an offset value between underlying asset's decimals and vault's decimals.


## Unknown tradeoffs/assumptions

## Links
 - [Example Implementation](./ExampleERC3156.sol)
 - [Tests for example implementation](../../../../test/token/ERC20/extensions/ERC3156/)

## [EIP4626 spec](https://eips.ethereum.org/EIPS/eip-4626) maintained?
 - Yes/No

### Where does it not adhere to the spec