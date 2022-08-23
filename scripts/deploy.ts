import { Signer, utils } from "ethers";
import { ethers } from "hardhat";

const main = async () => {
  let accounts: Signer[];

  accounts = await ethers.getSigners();
  const GetAaveDataFactory = await ethers.getContractFactory("GetAaveData");
  const GetAaveData = await GetAaveDataFactory.deploy();
  await GetAaveData.deployed();
  console.log("GetAaveData address: ", GetAaveData.address);

  const user = '0x15C6b352c1F767Fa2d79625a40Ca4087Fab9a198';
  var tokenAddresses = [
      '0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F',
      '0x2058A9D7613eEE744279e3856Ef0eAda5FCbaA7e',
      '0xBD21A10F619BE90d6066c941b04e340841F1F989',
      '0x0d787a4a1548f673ed375445535a6c7A1EE56180',
      '0x3C68CE8504087f89c640D02d133646d98e64ddd9',
      '0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889',
      '0x341d1f30e77D3FBfbD43D17183E2acb9dF25574E'
    ];
  
  var res = await GetAaveData.getAaveData(user.toLowerCase(), tokenAddresses);
  var result = [];
  result.push({totalSupplyInETH: (res.totalCollateralETH)/1e18});
  console.log(`Result: `)
  console.log(result);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(`err`, err);
    process.exit(1);
  }
};

runMain();