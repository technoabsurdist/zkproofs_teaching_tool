import './App.css';
import React, { useEffect, useState } from 'react';
import { ethers } from "ethers";
import abi from "./utils/Verifier.json";

function App() {
  const [currentAccount, setCurrentAccount] = useState("");

  const contractAddress = "0x02153E75Fa557879a4E0309fA0f920B5dE25C727";
  const contractABI = abi.abi;

  const checkIfWalletIsConnected = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        console.log("Make sure you have metamask!");
        return;
      } else {
        console.log("We have the ethereum object", ethereum);
      }

      const accounts = await ethereum.request({ method: "eth_accounts" });

      if (accounts.length !== 0) {
        const account = accounts[0];
        console.log("Found an authorized account:", account);
        setCurrentAccount(account);
      } else {
        console.log("No authorized account found")
      }
    } catch (error) {
      console.log(error);
    }
  }

  /**
  * Implement your connectWallet method here
  */
  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }

      const accounts = await ethereum.request({ method: "eth_requestAccounts" });

      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error)
    }
  }

  const verify2 = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const vContract = new ethers.Contract(contractAddress, contractABI, signer);

        const r = await vContract.mint(0xfdCe59613b071a96338349FAd6e147E41fCf94Aa, 0.000001);

        console.log("Mining...", r.hash);
        await r.wait();

        console.log("Mined --", r.hash);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error);
    }
  }
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  return (
    <div className="App">
      <h1>ZKProofs Interactive</h1>
      <br />
      <p>
        Zero-Knowledge proofs were invented at MIT in 1982, but for years, they were seen as "moon math" <br />
        and as incomprehensible by virtually everyone but a handful of PhDs at the forefront of cryptography <br />
        and mathematics. Some 20 years later, there's been discovered applications of ZK proofs in the emerging <br />
        blockchain community, but it's still an almost-incomprehensible area for most, even, in some cases, <br />
        for people who work with these daily.
      </p>
      <p>
        Because of this, we decided to build a smart contract that implements zkSnarks using Circom and SnarkJS <br />
        which receives two private inputs and one output proving that it can factor a number. <br />
        This is an interactive gateway that we believe can serve as the "rabbit hole" entrance for people wanting <br />
        to learn about this amazing technology. After running the smart contract, the user is instantly provided with <br />
        an explanation of what happened step by step in simple mathematical language and links to continue his learning journey. <br />
      </p>
      <p>
        While this can seem like a minor application of zkSnarks, we believe small things like this to be raw <br />
        power in terms of getting people involved with blockchain, something crucial for massive adoption and <br />
        organic scalability of blockchains in the future. <br />

      </p>
      {/*
        * If there is no currentAccount render this button
        */}
      {!currentAccount && (
        <button className="metaButton" onClick={connectWallet}>
          Connect Wallet
        </button>
      )}
      <h3>Try it out:</h3>
      <form>
        <label>
          <input placeholder="first number" type="text" name="name" />
        </label>
        <label>
          <input placeholder="second number" type="text" name="name" /> <br />
          <br />
        </label>
        <button type="submit" value="Submit" onClick={verify2}>Submit</button>
        <br />
        <br />
      </form>

      <a href="https://rinkeby.etherscan.io/tx/0x62a808b2ad1d7a2c8584cafdff779569addaf069ede4f3bf6cfa8c7a2eed162d">
        Link to Contract Ethscan
      </a>
    </div>
  );
}

export default App;
