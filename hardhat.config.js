require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

// ------- Start --------
const { TASK_COMPILE_SOLIDITY_GET_SOLC_BUILD } = require("hardhat/builtin-tasks/task-names");
const path = require("path");

subtask(TASK_COMPILE_SOLIDITY_GET_SOLC_BUILD, async (args, hre, runSuper) => {
if (args.solcVersion === "0.8.19") {
const compilerPath = path.join(__dirname, "soljson-v0.8.19+commit.7dd6d404.js");

return {
  compilerPath,
  isSolcJs: true, // if you are using a native compiler, set this to false
  version: args.solcVersion,
  // this is used as extra information in the build-info files, but other than
  // that is not important
  longVersion: "soljson-v0.8.19+commit.7dd6d404"
}
}
// we just use the default subtask if the version is not 0.8.5
return runSuper();
})
// ------ End ----------

module.exports = {
  solidity: "0.8.19",
  networks: {
    ganache: {
      url: process.env.URL,
      accounts: [process.env.PRIVATE_KEY],
    }
  },
};
