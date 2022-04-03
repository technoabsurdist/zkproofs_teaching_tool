require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.4.17",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/1L1Cya6GfzkhYOV4oDWG8H32KEWDUkwB",
      accounts: ["15f014fd95cb41bb7defd095cfefb245cf567d8c1dda6d71c8d5de9b7c828842"]
    }
  }
};
