// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
pragma solidity 0.8.16;

import "hardhat/console.sol";
import "./interfaces/IProtocolDataProvider.sol";
import "./interfaces/ILendingPool.sol";

contract GetAaveData {
    struct usersTokenData {
        uint256 currentATokenBalance;
        uint256 currentStableDebt;
        uint256 currentVariableDebt;
        uint256 principalStableDebt;
        uint256 scaledVariableDebt;
        uint256 stableBorrowRate;
        uint256 liquidityRate;
        uint256 stableRateLastUpdated;
        uint256 usageAsCollateralEnabled;
        uint256 decimals;
        uint256 ltv;
        uint256 liquidationThreshold;
        uint256 reserveFactor;
    }

    function getUserData(address user)
        public
        view
        returns (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        address LENDING_POOL = 0x9198F13B08E299d85E096929fA9781A1E3d5d827;
        (
            totalCollateralETH,
            totalDebtETH,
            availableBorrowsETH,
            currentLiquidationThreshold,
            ltv,
            healthFactor
        ) = ILendingPool(LENDING_POOL).getUserAccountData(user);
    }

    function getAaveData(address owner, address[] memory tokens)
        external
        view
        returns (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor,
            address[] memory userData
        )
    {
        address DATA_PROVIDER = 0xFA3bD19110d986c5e5E9DD5F69362d05035D045B;

        (
            totalCollateralETH,
            totalDebtETH,
            availableBorrowsETH,
            currentLiquidationThreshold,
            ltv,
            healthFactor
        ) = getUserData(user);

        address[] userData = new address[](tokens.length);

        for (uint256 i = 0; i < tokens.length; i++) {
            usersTokenData memory data;
            address token = tokens[i];
            (
                asset.decimal,
                asset.ltv,
                asset.liquidationThreshold,
                ,
                asset.reserveFactor,
                ,
                ,
                ,
                ,

            ) = IProtocolDataProvider(DATA_PROVIDER)
                .getReserveConfigurationData(token);
            (
                data.currentStableDebt,
                data.currentVariableDebt,
                data.principalStableDebt,
                data.scaledVariableDebt,
                data.stableBorrowRate,
                data.liquidityRate,
                data.stableRateLastUpdated,
                data.usageAsCollateralEnabled
            ) = IProtocolDataProvider(DATA_PROVIDER).getUserReserveData(
                token,
                owner
            );
            userData[i] = data;
        }
        return (
            totalCollateralETH,
            totalDebtETH,
            availableBorrowsETH,
            currentLiquidationThreshold,
            ltv,
            healthFactor,
            userData
        );
    }
}
