# ERC721

## Introduction

ERC721 token introduces the notion of Non-Fungible assets in the Ethereum ecosystem.

## Explanation of functions

1. balanceOf() - Returns the number of NFTs owned by the owner. Throws/reverts with error if owner is address(0).
   
2. ownerOf() - Returns address who owns the NFT

3. name() and symbol() - Returns the name and symbol of the NFT token

4. tokenURI() - Returns the baseURI appended with the tokenId, provided the baseURI exists and the tokenId is owned by someone other than address(0)

5. _baseURI() - Returns "" by default. Needs to be overridden by child contract to retrieve value.

6. approve() - Allows owner to approve an address to spend a tokenId

7. setApprovalForAll() - Allows owner to set an operator address, granting all permissions to operate on tokens (includes access to function approve() as well)

8. transferFrom() - Allows owner or approved operator to transfer a tokenId

9. safeTransferFrom() - Two of these functions available. One that does not take in a bytes memory data parameter and one that does. This is different from transferFrom() since an additional _checkOnERC721Received() call is made to the recipient contract to ensure it has implemented onERC721Received()

10. ownerOf() - Returns the owner of the tokenId. Does not revert if the token doesn't exist.

11. _mint() - Mints a tokenId to "to" address, provided "to" is not address(0) and tokenId hasn't been minted already to another address. This function needs to be overridden to be used.

12. _safeMint() - Similar to _mint() except if "to" is a smart contract, it needs to implement onERC721Received()

13. _burn() - Burns a tokenId, provided it exists

14. _safeTransfer() - Allows owner of tokenId to transfer to "to". If "to" is contract, check onERC721Received() existence. This function needs to be overridden to be used.

## Unknown tradeoffs/assumptions
1. If an operator is approved as well as another address separately for the specific tokenId, then frontrunning among them is possible.
2. _mint() and _burn() functions are internal, thus exposing them to external visibility is required else tokens cannot be minted. Make sure to restrict these functions with admin modifiers.

## Links
 - [Example Implementation](./ExampleERC721.sol)
 - [Tests for example implementation](../../../test/token/ERC721/testExampleERC721.t.sol)

## [EIP721 spec](https://eips.ethereum.org/EIPS/eip-721) maintained?
 - Yes