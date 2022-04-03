const main = async () => {
    const VerifierFactory = await hre.ethers.getContractFactory("Verifier");
    const verifier = await VerifierFactory.deploy();
    await verifier.deployed();
    console.log("Contract deployed to: ", verifier.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error)
        process.exit(1)
    }
};

runMain(); 
