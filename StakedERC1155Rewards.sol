pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract StakedERC1155Rewards is Ownable, ReentrancyGuard {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  // ERC-20 contract address
  address public rewardToken;

  // ERC-1155 contract address
  address public erc1155;

  // Mapping of user addresses to the number of tokens they have staked
  mapping(address => uint256) public stakes;

  // Mapping of user addresses to the number of rewards they have earned
  mapping(address => uint256) public rewards;

  // Events
  event Staked(address indexed user, uint256 amount);
  event Withdrawn(address indexed user, uint256 amount);
  event RewardsMinted(address indexed user, uint256 amount);

  constructor(address _rewardToken, address _erc1155) public {
    rewardToken = _rewardToken;
    erc1155 = _erc1155;
  }

  /**
   * Stake an ERC-1155 token
   * @param _tokenId The token ID of the ERC-1155 token to stake
   * @param _amount The amount of tokens to stake
   */
  function stake(uint256 _tokenId, uint256 _amount) public {
    // Ensure that the caller is the owner of the token
    require(IERC1155(erc1155).ownerOf(_tokenId) == msg.sender, "Token is not owned by the caller");

    // Increment the number of staked tokens for the caller
    stakes[msg.sender] = stakes[msg.sender].add(_amount);

    // Emit the Staked event
    emit Staked(msg.sender, _amount);
  }

  /**
   * Withdraw staked tokens and mint rewards
   * @param _tokenId The token ID of the ERC-1155 token to withdraw
   * @param _amount The amount of tokens to withdraw
   */
  function withdraw(uint256 _tokenId, uint256 _amount) public {
    // Ensure that the caller has staked the specified amount of tokens
    require(stakes[msg.sender] >= _amount, "Not enough staked tokens");

    // Calculate the number of hours the tokens were staked
    uint256 currentBlock = block.timestamp;
    uint256 stakedBlock = IERC1155(erc1155).getStakedBlock(_tokenId);
    uint256 hours = (currentBlock.sub(stakedBlock)) / 1 hours;

    // Calculate the number of rewards to mint
    uint256 rewardsToMint = hours.mul(_amount);

    // Mint the rewards
  IERC20(rewardToken).safeMint(msg.sender, rewardsToMint);

  // Increment the rewards balance for the caller
  rewards[msg.sender] = rewards[msg.sender].add(rewardsToMint);

  // Decrement the staked token balance for the caller
  stakes[msg.sender] = stakes[msg.sender].sub(_amount);

  // Transfer the withdrawn tokens to the caller
  IERC1155(erc1155).safeTransferFrom(msg.sender, address(this), _tokenId, _amount);

  // Emit the Withdrawn and RewardsMinted events
  emit Withdrawn(msg.sender, _amount);
  emit RewardsMinted(msg.sender, rewardsToMint);
}
