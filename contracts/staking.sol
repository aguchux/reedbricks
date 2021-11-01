

contract Stakeable{
    // Staking Application //
    //https://cryptomarketpool.com/create-a-defi-bank-that-pays-interest-yield-farm///
    // allow user to stake usdc tokens in contract

    //STACKING//
    address public usdc;
    address public usdt;
    address public bnb;
    address public busd;
    //STACKING//

    address public reed;

    uint private stakeDuration;
    uint private stakeAPR;

    struct Stake{
        address staker;
        address coin;
        uint256 amount;
        uint256 starts;
        uint256 ends;
    }
    
    Stake[] public stakes;
    mapping(address => Stake) public stakers;
        
    event Staked(
        address staker,
        address coin,
        uint256 amount,
        uint256 starts,
        uint256 ends
    );

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public canStake;

    modifier stakeBanned(){
        require(canStake[msg.sender],"Account not allowed to stake");
        _;
    }

    modifier onExpiry() {
      require(
         block.timestamp >= block.timestamp + stakeDuration * 1 days,
         "Function called too early."
      );
      _;
   }
    constructor(){
        stakeDuration = 30;
    }

    function setStakeDuration(uint _numDays) onlyOwner public returns(bool) {
        stakeDuration = _numDays;
        return true;
    }

    function setStaker(address _staker) onlyOwner public returns(bool) {
        canStake[_staker] = true;
        return true;
    }

    function unsetStaker(address _staker) onlyOwner public returns(bool) {
        canStake[_staker] = false;
        return true;
    }

    function stakeTokens(uint _amount) public {
        //Timework//
        uint _now = block.timestamp;
        uint _expire = block.timestamp + stakeDuration * 1 days;
        //Timework//

        Stake memory stake;
        stake = Stake(msg.sender,usdc,_amount,_now,_expire);

        // Trasnfer usdc tokens to contract for staking
        IERC20(usdc).transferFrom(msg.sender, address(this), _amount);

        // Update the staking balance in map
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;
        
        // Add user to stakers array if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers[msg.sender] = stake;
            stakes.push(stake);
        }

        // Update staking status to track
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;

        emit Staked(msg.sender,usdc,_amount,_now,_expire);

    }

    
     // allow user to unstake total balance and withdraw USDC from the contract
     function unstakeTokens() public {
    	// get the users staking balance in usdc
    	uint balance = stakingBalance[msg.sender];
        // reqire the amount staked needs to be greater then 0
        require(balance > 0, "staking balance can not be 0");
        // transfer usdc tokens out of this contract to the msg.sender
        IERC20(usdc).transfer(msg.sender, balance);
        // reset staking balance map to 0
        stakingBalance[msg.sender] = 0;
        // update the staking status
        isStaking[msg.sender] = false;
    }


         // allow user to unstake total balance and withdraw USDC from the contract
     function unstackBNB() public {
    	// get the users staking balance in usdc
    	uint balance = stakingBalance[msg.sender];
        // reqire the amount staked needs to be greater then 0
        require(balance > 0, "staking balance can not be 0");
        // transfer usdc tokens out of this contract to the msg.sender
        IERC20(bnb).transfer(msg.sender, balance);
        // reset staking balance map to 0
        stakingBalance[msg.sender] = 0;
        // update the staking status
        isStaking[msg.sender] = false;
    } 


     // Issue bank tokens as a reward for staking 
    function issueInterestToken() public {
        for (uint i=0; i<stakes.length; i++) {
            address recipient = stakes[i].staker;
            uint balance = stakingBalance[recipient];
            // if there is a balance transfer the SAME amount of bank tokens to the account that is staking as a reward
            if(balance >0){
                IERC20(reed).transfer(recipient, balance);
            }
        }
    }
    // Staking Application //
}
