// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Utils/operations.sol";
import "./Interface/INftExchange.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


// For OrderDetials.Type

// 1 = Nft -> Nft
// 2 = Nft -> Erc20
// 3 = Nft -> ETH

// 4 = Nft -> Nft + Erc20
// 5 = Nft -> Nft + Erc20 + ETH
// 6 = Nft -> Nft + ETH
// 7 = Nft -> ERC20 + ETH

// 8 = Nft -> Multi *

contract NftExchange is INftExchange, Operations {
    
    event newOrder(
        address ListserTokenAddress,
        uint256 ListerTokenId,
        address BuyerAddress,
        address BuyerTokenAddress,
        uint256 BuyerTokenId,
        bytes32 OrderID
    );

    struct OrderDetials {
        address ListerTokenAddress;
        uint256 ListerTokenId;
        address BuyerTokenAddress;
        uint256 BuyerTokenId;
        address ERC20Address;
        uint256 ERC20Amount;
        uint256 EthAmount;
        uint256 Type;
    }

    mapping(address => mapping(bytes32 => OrderDetials)) public OrderInfo;

    function makeNftToNft(
        address Lister,
        address BuyerContract,
        uint256 BuyerID,
        address ListerContract,
        uint256 ListerID
    ) public override returns (bytes32 orderID) {
        require(
            IERC721(BuyerContract).getApproved(BuyerID) == address(this),
            "not approved, cannot create order"
        );
        require(
            IERC721(BuyerContract).ownerOf(BuyerID) == msg.sender,
            "not owner, cannot create order"
        );

        bytes32 OrderID = _createOrderId(Lister, ListerContract, ListerID);

        OrderInfo[msg.sender][OrderID].ListerTokenAddress = ListerContract;
        OrderInfo[msg.sender][OrderID].ListerTokenId = ListerID;
        OrderInfo[msg.sender][OrderID].BuyerTokenAddress = BuyerContract;
        OrderInfo[msg.sender][OrderID].BuyerTokenId = BuyerID;
        OrderInfo[msg.sender][OrderID].Type = 1;

        emit newOrder(
            ListerContract,
            ListerID,
            msg.sender,
            BuyerContract,
            BuyerID,
            OrderID
        );

        return(OrderID);
    }

    function makeNftToERC20(
        address Lister,
        address ListerContract,
        uint256 ListerID,
        address Erc20Contract,
        uint256 Amount
    ) public override payable returns (bytes32 orderID) {
        //Add Check to make sure Erc20Contract address passes is Valid
        require(
            IERC20(Erc20Contract).balanceOf(msg.sender) >= Amount,
            "sender does not have enought coins"
        );

        bytes32 OrderID = _createOrderId(Lister, ListerContract, ListerID);

        OrderInfo[msg.sender][OrderID].ListerTokenAddress = ListerContract;
        OrderInfo[msg.sender][OrderID].ListerTokenId = ListerID;
        OrderInfo[msg.sender][OrderID].ERC20Address = Erc20Contract;
        OrderInfo[msg.sender][OrderID].ERC20Amount = Amount;
        OrderInfo[msg.sender][OrderID].Type = 2;

        return (OrderID);
    }

    function makeNftToETH(
        address Lister,
        address ListerContract,
        uint256 ListerID
    ) public override payable returns (bytes32 orderID) {
        bytes32 OrderID = _createOrderId(Lister, ListerContract, ListerID);

        OrderInfo[msg.sender][OrderID].ListerTokenAddress = ListerContract;
        OrderInfo[msg.sender][OrderID].ListerTokenId = ListerID;
        OrderInfo[msg.sender][OrderID].EthAmount = msg.value;
        OrderInfo[msg.sender][OrderID].Type = 3;

        return(OrderID);
    }

    function takeOrder(address Buyer, address payable Reciver, bytes32 OrderID)
        public
        override
        returns (bool)
    {
        if (OrderInfo[Buyer][OrderID].Type == 1) {
            _takeNftToNft(Buyer, OrderID);
        } else if (OrderInfo[Buyer][OrderID].Type == 2) {
            _takeNftToErc20(Buyer, OrderID);
        } else if (OrderInfo[Buyer][OrderID].Type == 3) {
            _takeNftToEth(Buyer, Reciver, OrderID);
        }

        delete OrderInfo[Buyer][OrderID];
        return(true);
    }

    function _transferListerNft(address _buyer, bytes32 _orderID) internal {
        require(
            IERC721(OrderInfo[_buyer][_orderID].ListerTokenAddress).ownerOf(
                OrderInfo[_buyer][_orderID].ListerTokenId
            ) == msg.sender,
            "not owner, cannot excute order"
        );

        IERC721(OrderInfo[_buyer][_orderID].ListerTokenAddress).transferFrom(
            msg.sender,
            _buyer,
            OrderInfo[_buyer][_orderID].ListerTokenId
        );
    }

    function _takeNftToEth(address _buyer, address payable _reciver, bytes32 _orderID) internal {
        require(msg.sender == _reciver);
        _transferListerNft(_buyer, _orderID);

        _reciver.transfer(OrderInfo[_buyer][_orderID].EthAmount);
    }

    function _takeNftToNft(address _buyer, bytes32 _orderID) internal {
        _transferListerNft(_buyer, _orderID);

        IERC721(OrderInfo[_buyer][_orderID].BuyerTokenAddress).transferFrom(
            _buyer,
            msg.sender,
            OrderInfo[_buyer][_orderID].BuyerTokenId
        );
    }

    function _takeNftToErc20(address _buyer, bytes32 _orderID) internal {
        _transferListerNft(_buyer, _orderID);

        IERC20(OrderInfo[_buyer][_orderID].ERC20Address).transferFrom(
            _buyer,
            msg.sender,
            OrderInfo[_buyer][_orderID].ERC20Amount
        );
    }
}