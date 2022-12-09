// index.js
const contractAddress = "0x12345..."; // Address of the StakedERC1155Rewards contract

const web3 new Web3(Web3.givenProvider || new Web3.providers.HttpProvider(yourinfuraaddress));
			if(websocketAddress) {
				this.web3.setProvider(new Web3.providers.WebsocketProvider(ws://yourinfuraaddress));
			}
const contract = new web3.eth.Contract(
  // ABI of the StakedERC1155Rewards contract
  [
    {
      constant: false,
      inputs: [
        {
          internalType: "uint256",
          name: "_tokenId",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "_amount",
          type: "uint256",
        },
      ],
      name: "stake",
      outputs: [],
      payable: false,
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      constant: false,
      inputs: [
        {
          internalType: "uint256",
          name: "_tokenId",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "_amount",
          type: "uint256",
        },
      ],
      name: "withdraw",
      outputs: [],
      payable: false,
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      constant: true,
      inputs: [],
      name: "rewards",
      outputs: [
        {
          internalType: "mapping(address => uint256)",
          name: "",
          type: "uint256",
        },
      ],
      payable: false,
      stateMutability: "view",
      type: "function",
    },
  ],
  contractAddress
);

// Stake tokens
async function stakeTokens() {
  // Get the token ID and amount of tokens to stake from the form
  const tokenId = document.getElementById("tokenId").value;
  const amount = document.getElementById("amount").value;

  // Call the stake function on the contract
  await contract.methods.stake(tokenId, amount).send({ from: web3.eth.defaultAccount });

  alert("Tokens staked successfully!");
}

// Withdraw staked tokens
async function withdrawTokens() {
  // Get the token ID and amount of tokens to withdraw from the form
  const tokenId = document.getElementById("tokenId").value;
  const amount = document.getElementById("amount").value;

  // Call the withdraw function on the contract
  await contract.methods.withdraw(tokenId, amount).send({ from: web3.eth.defaultAccount });

  alert("Tokens withdrawn successfully!");
}

// View rewards balance
async function viewRewardsBalance() {
  // Call the rewards function on the contract
  const rewards = await contract.methods.rewards().call();

  // Get the rewards balance for the default account
  const rewardsBalance = rewards[web3.eth.defaultAccount];

  alert(`Your rewards balance is: ${rewardsBalance}`);
}
