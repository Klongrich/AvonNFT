// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Operations {
    function _toBytes(uint256 x) internal pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function _createOrderId(address _listerPublicKey, address _listerContractPublicKey, uint256 _listerId) internal view returns (bytes32) {
        return keccak256(abi.encode(_listerPublicKey, _listerContractPublicKey, _listerId, keccak256(_toBytes(block.timestamp))));
    }
}