// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

interface ILendingPoolAddressesProvider {
  function getPriceOracle() external view returns (address);
  function setAssetPrice(address asset, uint256 price) external;
}