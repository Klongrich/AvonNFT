// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface INftExchange {
    // Considering moving OrderID creation to be within the function

    /**
     * @dev Creates an Offer of One NFT for One other NFT  
        @param BuyerContract Address of the NFT being preposed to the lister.
        @param BuyerID ID of the NFT being preposed to the lister.
        @param ListerContract Address of the NFT that is Listed or Being asked for.
        @param ListerID ID of the NFT that is Listed or Being asked for.
        @param orderID Unqiue number that will save the order on chain.
        
        Emits: 
    */

    function makeNftToNft(
        address BuyerContract,
        uint256 BuyerID,
        address ListerContract,
        uint256 ListerID
    ) external returns (bytes32 orderID);

    /**
     * @dev Creates an Offer of One NFT for a static amount of ERC20 tokens  
        @param ListerContract Address of the NFT that is Listed or Being asked for.
        @param ListerID ID of the NFT that is Listed or Being asked for.
        @param Erc20Contract Address of the ERC20 Token that is being offered
        @param Amount The total number of ERC20 tokens being offered
        @param orderID Unqiue number that will save the order on chain.
        
        Emits: 
    */

    function makeNftToERC20(
        address ListerContract,
        uint256 ListerID,
        address Erc20Contract,
        uint256 Amount
    ) external payable returns (bytes32 orderID);

    /**
     * @dev Creates an Offer of One NFT for a static amount of ERC20 tokens  
        @param ListerContract Address of the NFT that is Listed or Being asked for.
        @param ListerID ID of the NFT that is Listed or Being asked for.
        @param orderID Unqiue number that will save the order on chain.
        
        Emits: 
    */

    function makeNftToETH(
        address ListerContract,
        uint256 ListerID
    ) external payable returns (bytes32 orderID);

    /**
     * @dev Triggers the trasnfer of assests for between the two parties once aggreed
        upon terms are matched. This is only callable by the person who owns the NFT
        that is being asked for.
        @param Buyer Address of the person submiting the offer
        @param orderID Unqiue ID that is given the the order stored on chain
        
        Emits: 
    */

    function takeOrder(address Buyer, address payable Reciver, bytes32 orderID) external returns (bool);
}
