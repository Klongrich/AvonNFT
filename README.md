# nft_exchnage
Quickly put together NFT exchange

## Simple NFT Exchange

The main smart contract on the back end is written and tested, it has 3 main functions to create orders then one function to call to take the order.

## Creating Order Functions

### 1.) createNftToNft() -> allows the creation of a NFT to NFT transfers

### 2.) createNftToERC20() -> Allows the creation of NFT to ERC20 transfers

### 3.) createNftToEth() -> Allows the creation of NFT to ETH transfers

Each of these functions can be called to create an offer and list a NFT. The details of the offer are then stored withing the smart contract on chain
for the lister to see. Once the lister decieds he aggess with the offer, only then the fucntion is called in order to excute the exchange.

## Filing Order Function

### 1.) takeOrder() -> Will not fire unless the creator of the order calls it, the transfer is done once it is called.

# Also Note:

For paramters plz refencerce the INftExchange.sol (Interface) in "./contracts/Interface/INftExchange.sol" for what paramters are passed to each 
of the smart contract functions.

## Rinkeby Exchange Contract: 0x58648d95A6884c81AD3541cfb255af810Cb09031
