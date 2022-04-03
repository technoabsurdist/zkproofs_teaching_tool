import './App.css';

function App() {
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

      <h3>Try it out:</h3>
      <form>
        <label>
          First Number:
          <input type="text" name="name" />
        </label>
        <label>
          Second Number:
          <input type="text" name="name" /> <br />
          <br />
        </label>
        <input type="submit" value="Submit" />
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
