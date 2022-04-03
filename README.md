# ZK Proofs Teaching Tool

### We'll create a circuit that tries to prove we are able to factor a number.

1. The circuit will have 2 private inputs and 1 output.
2. The output signal c must be the value of signal a times signal b.
3. We instantiate the circuit and assign it to the main component. The component main must always exist.

### We'll also try to connect it to our front-end

1. Which will let the user input the two numbers and it will return true and false and a tutorial explaining mathematically how the zksnark did it. 
2. It would also provide resources after the puzzle, giving the user an entrance to the rabbit hole with good resources. 

## Contract Link

https://rinkeby.etherscan.io/tx/0x62a808b2ad1d7a2c8584cafdff779569addaf069ede4f3bf6cfa8c7a2eed162d

## To Run 

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
