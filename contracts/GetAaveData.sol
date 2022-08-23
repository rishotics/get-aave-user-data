// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

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
        uint40 stableRateLastUpdated;
        bool usageAsCollateralEnabled;
        uint256 decimal;
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
            usersTokenData[] memory userData
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
        ) = getUserData(owner);

        userData = new usersTokenData[](tokens.length);

        for (uint256 i = 0; i < tokens.length; i++) {
            usersTokenData memory data;
            address token = tokens[i];
            (
                data.decimal,
                data.ltv,
                data.liquidationThreshold,
                ,
                data.reserveFactor,
                ,
                ,
                ,
                ,

            ) = IProtocolDataProvider(DATA_PROVIDER)
                .getReserveConfigurationData(token);
            (
                data.currentATokenBalance,
                data.currentStableDebt,
                data.currentVariableDebt,
                data.principalStableDebt,
                data.scaledVariableDebt,
                data.stableBorrowRate,
                ,
                ,
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
