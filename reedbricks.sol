// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library SafeMathInt {
    int256 private constant MIN_INT256 = int256(1) << 255;
    int256 private constant MAX_INT256 = ~(int256(1) << 255);

    function mul(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a * b;

        // Detect overflow when multiplying MIN_INT256 with -1
        require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
        require((b == 0) || (c / b == a));
        return c;
    }
    function div(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when dividing MIN_INT256 by -1
        require(b != -1 || a != MIN_INT256);

        // Solidity already throws when dividing by 0.
        return a / b;
    }
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));
        return c;
    }
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }
    function abs(int256 a) internal pure returns (int256) {
        require(a != MIN_INT256);
        return a < 0 ? -a : a;
    }
    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}

library SafeMathUint {
  function toInt256Safe(uint256 a) internal pure returns (int256) {
    int256 b = int256(a);
    require(b >= 0);
    return b;
  }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor (){
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    modifier protectOwner() {
        require(!isOwner());
        _;
    }


    function isOwner() internal view returns (bool) {
        return msg.sender == _owner;
    }


    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(sender, recipient, amount);
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

contract Utilities {


    //This is where all your gas goes, sorry
    //Not sorry, you probably only paid 1 gwei
    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

}

contract ReedBricks is
    ERC20,
    Utilities,
    Ownable
{
    using SafeMath for uint256;
    using Address for address;
   
    string private _name = "ReedBricks v9";
    string private _symbol = "REED9";
    uint8 private _decimals = 18;

    bool isBuyFromLp;
    bool isSelltoLp;

    address private _uniswapV2Pair;
    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _blacklistTimeLimit = 21600;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
    mapping (address => bool) private _isExcludedFromMaxWalletLimit;
    mapping (address => bool) private _isBlacklisted;
    mapping (address => bool) public automatedMarketMakerPairs;
    mapping (address => uint256) private _buyTimesInLaunch;

    bool public isTradingEnabled = false;
    uint256 private _tradingPausedTimestamp;
    // initialSupply is 100 billion
    uint256 constant initialSupply = 100 * 10**9 * (10**18);
    // max wallet is 2% of initialSupply 
    uint256 public maxWalletAmount = initialSupply * 200 / 10000;
    // min wallet is 1% of initialSupply 
    uint256 public minWalletAmount = initialSupply * 100 / 10000; 
    uint256 private _totalSupply = maxWalletAmount;

    // max buy and sell tx is 0.2% of initialSupply
    uint256 public maxTxAmount = initialSupply * 20 / 10000; //200_000_000 
    bool private _swapping;
    uint256 public minimumTokensBeforeSwap = 25000000 * (10**18); 
    uint256 public gasForProcessing = 300000;
    
    bool private _isLanched;
    uint256 private _launchStartTimestamp;
    uint256 private _launchBlockNumber;
    uint256 private _launchSellMaximum =  initialSupply * 20 / 10000;
    
    bytes23 periodName = "private";
    uint8 blocksInPeriod = 3;
    uint256 timeInPeriod = 0;

    // base controller of the token contract
    address public marketingWallet;
    address public liquidityWallet;
    address public buyBackWallet;
    address public salaryWallet;

    uint256 private _liquidityTokensToSwap;
    uint256 private _marketingTokensToSwap;
    uint256 private _buyBackTokensToSwap;
    uint256 private _salaryTokensToSwap;

    // Base taxes
    uint256 public liquidityFee = 100;
    uint256 public marketingFee = 100;
    uint256 public salaryFee = 100;
    uint256 public buyBackFee = 100;

    uint256 public liquidityFeeLP = 100;
    uint256 public marketingFeeLP = 100;
    uint256 public salaryFeeLP = 100;
    uint256 public buyBackFeeLP = 100;

    event SwapEnabled(bool enabled);
    
    uint256 private maxAmount = 200;

    bool private privateSaleDropCompleted = true;
    bool private initialDistributionFinished = false;

    mapping(address => bool) allowTransfer;

    event InitiatedNewLaunch(bytes23 periodName, uint8 blocksInPeriod, uint256 timeInPeriod);
    event AutomatedMarketMakerPairChange(address indexed pair, bool indexed value);
    event DividendTrackerChange(address indexed newAddress, address indexed oldAddress);
    event UniswapV2RouterChange(address indexed newAddress, address indexed oldAddress);
    event ExcludeFromFeesChange(address indexed account, bool isExcluded);
    event LiquidityWalletChange(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
    event MarketingWalletChange(address indexed newMarketingWallet, address indexed oldMarketingWallet);
    event BuyBackWalletChange(address indexed newBuyBackWallet, address indexed oldBuyBackWallet);
    event SalaryWalletChange(address indexed newSalaryWallet, address indexed oldSalaryWallet);
    event GasForProcessingChange(uint256 indexed newValue, uint256 indexed oldValue);
    event FeeChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType);
    event CustomTaxPeriodChange(uint256 indexed newValue, uint256 indexed oldValue, string indexed taxType, bytes23 period);
    event BlacklistChange(address indexed holder, bool indexed status);
    event KodiRoarChange(bool indexed newValue, bool indexed oldValue);
    event MaxTransactionAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
    event MaxWalletAmountChange(uint256 indexed newValue, uint256 indexed oldValue);
    event MinTokenAmountBeforeSwapChange(uint256 indexed newValue, uint256 indexed oldValue);
    event ExcludeFromMaxTransferChange(address indexed account, bool isExcluded);
    event ExcludeFromMaxWalletChange(address indexed account, bool isExcluded);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);

    // administrator list (see above on what they can do)
    mapping(address => bool) public administrators;
    mapping(address => bool) internal ambassadors_;
    // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
    bool public onlyAmbassadors = true;

    constructor(address _liquidityWallet,address _marketingWallet,address _salaryWallet,address _buyBackWallet) ERC20("ReedBricks v8", "REED8") {
        
        liquidityWallet = address(_liquidityWallet);
    	marketingWallet = address(_marketingWallet);
    	salaryWallet = address(_salaryWallet);
    	buyBackWallet = address(_buyBackWallet);

        // add administrators and ambassadors //
        // Dr. Catherine O.A who is the Next of KIN to this project// 
        administrators[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = true;
        // Mr. Simeon C.U who is a big fan to this project// 
        ambassadors_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = true;
        // Mr. Samuel C.N the Operations manager for the project// 
        ambassadors_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = true;
        
        _liquidityTokensToSwap = 0;
       
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // Testnet
        //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Mainnet
        _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;
        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        _isExcludedFromMaxTransactionLimit[address(this)] = true;
        
        _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
        _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
        _isExcludedFromMaxWalletLimit[address(this)] = true;
        _isExcludedFromMaxWalletLimit[owner()] = true;

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;

        _mint(owner(), initialSupply);

    }

    receive() external payable {}

    /**
     * Retrieve the REED tokens owned by the caller.
     */
    function myTokens()
        public
        view
        returns(uint256)
    {
        address _customerAddress = msg.sender;
        return balanceOf(_customerAddress);
    }
    
    /**
     * Method to view the current Ethereum stored in the contract
     * Example: totalEthereumBalance()
     */
    function totalEthereumBalance()
        public
        view
        returns(uint)
    {
        return address(this).balance;
    }

    /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
    /**
     * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
     */
    function disableInitialStage()
        onlyOwner
        public
    {
        onlyAmbassadors = false;
    }
    
    /**
     * In case one of us dies, we need to replace ourselves.
     */
    function setAdministrator(address _identifier, bool _status)
        onlyOwner
        public
    {
        administrators[_identifier] = _status;
    }

    // administrators can:
    // -> change the name of the contract
    // -> change the name of the token
    // they CANNOT:
    // -> take funds
    // -> kill the contract
    // -> change the price of tokens
    modifier onlyAdministrator(){
        address _customerAddress = msg.sender;
        require(administrators[_customerAddress],"REED: Only Administrators allowed");
        _;
    }

    /*----------  FOR TOKEN REBRANDING ----------*/
    function setName(string memory name)
        onlyOwner
        public
    {
        _name = name;
    }
    function setSymbol(string  memory _isymbol)
        onlyOwner
        public
    {
        _symbol = _isymbol;
    }
    /*----------  FOR TOKEN REBRANDING ----------*/

    function initiateNewLaunch(bytes23 _periodName, uint8 _blocksInPeriod, uint256 _timeInPeriod) public onlyOwner {
        require(periodName != _periodName, "REED: The Name must be different from old name");
        require(blocksInPeriod != _blocksInPeriod, "REED: The Name must be different from old name");
        require(timeInPeriod != _timeInPeriod, "REED: The Name must be different from old name");
        emit InitiatedNewLaunch(periodName, blocksInPeriod, timeInPeriod);
    }

    function launch() public onlyOwner {
        _launchStartTimestamp = _getNow();
        _launchBlockNumber = block.number;
         isTradingEnabled = true;
        _isLanched = true;
    }

    function cancelLaunch() public onlyOwner {
        require(this.isInLaunch(), "REED: Launch is not set");
        _launchStartTimestamp = 0;
        _launchBlockNumber = 0;
    }

    function _getNow() private view returns (uint256) {
        return block.timestamp;
    }

    function activateTrading() public onlyOwner {
        isTradingEnabled = true;
    }

    function deactivateTrading() public onlyOwner {
        isTradingEnabled = false;
        _tradingPausedTimestamp = _getNow();
    }

    function setUniswapV2Router(address newAddress) public onlyOwner {
        require(newAddress != address(uniswapV2Router), "REED: The router already has that address");
        emit UniswapV2RouterChange(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }

    function setGasForProcessing(uint256 newValue) public onlyOwner {
        require(newValue >= 200000 && newValue <= 500000, "REED: gasForProcessing must be between 200,000 and 500,000");
        require(newValue != gasForProcessing, "REED: Cannot update gasForProcessing to same value");
        emit GasForProcessingChange(newValue, gasForProcessing);
        gasForProcessing = newValue;
    }

    function setMaxTxAmount(uint256 newValue) public onlyOwner {
        require(newValue != maxTxAmount, "REED: Cannot update maxTxAmount to same value");
        emit MaxTransactionAmountChange(newValue, maxTxAmount);
        maxTxAmount = newValue;
    }

    function setMaxWalletAmount(uint256 newValue) public onlyOwner {
        require(newValue != maxWalletAmount, "REED: Cannot update maxWalletAmount to same value");
        emit MaxWalletAmountChange(newValue, maxWalletAmount);
        maxWalletAmount = newValue;
    }

    function setMinimumTokensBeforeSwap(uint256 newValue) public onlyOwner {
        require(newValue != minimumTokensBeforeSwap, "REED: Cannot update minimumTokensBeforeSwap to same value");
        emit MinTokenAmountBeforeSwapChange(newValue, minimumTokensBeforeSwap);
        minimumTokensBeforeSwap = newValue;
    }

    function setMarketingFee(uint256 newvalue) public onlyOwner {
        require(marketingFee != newvalue, "REED: The marketingFee is already that value");
        emit FeeChange(newvalue, marketingFee, "marketingFee");
        marketingFee = newvalue;
    }

    function setBuyBackFee(uint256 newvalue) public onlyOwner {
        require(buyBackFee != newvalue, "REED: The buyBackFee is already that value");
        emit FeeChange(newvalue, buyBackFee, "buyBackFee");
        buyBackFee = newvalue;
    }

    function setSalary(uint256 newvalue) public onlyOwner {
        require(salaryFee != newvalue, "REED: The salaryFee is already that value");
        emit FeeChange(newvalue, salaryFee, "salaryFee");
        salaryFee = newvalue;
    }

    function setLiquidity(uint256 newvalue) public onlyOwner {
        require(liquidityFee != newvalue, "REED: The liquidityFee is already that value");
        emit FeeChange(newvalue, liquidityFee, "liquidityFee");
        liquidityFee= newvalue;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(automatedMarketMakerPairs[pair] != value, "REED: Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;
        emit AutomatedMarketMakerPairChange(pair, value);
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(_isExcludedFromFee[account] != excluded, "REED: Account is already the value of 'excluded'");
        _isExcludedFromFee[account] = excluded;
        emit ExcludeFromFeesChange(account, excluded);
    }

    function excludeFromMaxTransactionLimit(address account, bool excluded) public onlyOwner {
        require(_isExcludedFromMaxTransactionLimit[account] != excluded, "REED: Account is already the value of 'excluded'");
        _isExcludedFromMaxTransactionLimit[account] = excluded;
        emit ExcludeFromMaxTransferChange(account, excluded);
    }
    function excludeFromMaxWalletLimit(address account, bool excluded) public onlyOwner {
        require(_isExcludedFromMaxWalletLimit[account] != excluded, "REED: Account is already the value of 'excluded'");
        _isExcludedFromMaxWalletLimit[account] = excluded;
        emit ExcludeFromMaxWalletChange(account, excluded);
    }

    function blacklistAccount(address account) public onlyOwner {
        uint256 currentTimestamp = _getNow();
        require(!_isBlacklisted[account], "REED: Account is already blacklisted");
        if (_isLanched) {
            require(currentTimestamp.sub(_launchStartTimestamp) < _blacklistTimeLimit, "REED: Time to blacklist accounts has expired");
        }
        _isBlacklisted[account] = true;
        emit BlacklistChange(account, true);
    }
    function unBlacklistAccount(address account) public onlyOwner {
        require(_isBlacklisted[account], "REED: Account is not blacklisted");
        _isBlacklisted[account] = false;
        emit BlacklistChange(account, false);
    }
    function setLiquidityWallet(address payable newAddress) public onlyOwner {
        require(liquidityWallet != newAddress, "REED: The liquidityWallet is already that address");
        emit LiquidityWalletChange(newAddress, liquidityWallet);
        liquidityWallet = newAddress;
    }
    function setMarketingWallet(address payable newAddress) public onlyOwner {
        require(marketingWallet != newAddress, "REED: The marketingWallet is already that address");
        emit MarketingWalletChange(newAddress, marketingWallet);
        marketingWallet = newAddress;
    }
    function setBuyBackWallet(address payable newAddress) public onlyOwner {
        require(buyBackWallet != newAddress, "REED: The buyBackWallet is already that address");
        emit BuyBackWalletChange(newAddress, buyBackWallet);
        buyBackWallet = newAddress;
    }
    function setSalaryWallet(address payable newAddress) public onlyOwner {
        require(salaryWallet != newAddress, "REED: The salaryWallet is already that address");
        emit SalaryWalletChange(newAddress, salaryWallet);
        salaryWallet = newAddress;
    }

    function getFees() external view returns (uint256, uint256, uint256,uint256){
        return (liquidityFee,marketingFee, buyBackFee, salaryFee);
    }

    function isInLaunch() external view returns (bool) {
        uint256 currentTimestamp = !isTradingEnabled && _tradingPausedTimestamp > _launchStartTimestamp  ? _tradingPausedTimestamp : _getNow();
        uint256 timeSinceLaunch = currentTimestamp.sub(_launchStartTimestamp);
        uint256 blocksSinceLaunch = block.number.sub(_launchBlockNumber);
        uint256 totalLaunchTime =  timeInPeriod;
        if(_isLanched && (timeSinceLaunch < totalLaunchTime || blocksSinceLaunch < blocksInPeriod )) {
            return true;
        } else {
            return false;
        }
    }

    function _getCurrentTotalFee(bool _isBuyFromLp, uint256 amount) internal returns (uint256 returnAmount, uint256 fee) {
        
        uint256 _liquidityFee = _isBuyFromLp ? liquidityFeeLP : liquidityFee;
        uint256 _marketingFee = _isBuyFromLp ? marketingFeeLP : marketingFee;
        uint256 _salaryFee = _isBuyFromLp ? salaryFeeLP : salaryFee;
        uint256 _buyBackFee = _isBuyFromLp ? buyBackFeeLP : buyBackFee;

        uint256 _totalFee = _liquidityFee.add(_marketingFee).add(_salaryFee).add(_buyBackFee);
        fee = amount.mul(_totalFee).div(10000);
    	returnAmount = amount.sub(fee);
    	_updateTokensToSwap(amount);
    	return (returnAmount, fee);

    }
    
    function _updateTokensToSwap(uint256 amount) private {
        _liquidityTokensToSwap = _liquidityTokensToSwap.add(amount.mul(liquidityFee).div(10000));
    	_marketingTokensToSwap = _marketingTokensToSwap.add(amount.mul(marketingFee).div(10000));
    	_buyBackTokensToSwap = _buyBackTokensToSwap.add(amount.mul(buyBackFee).div(10000));
    	_salaryTokensToSwap = _salaryTokensToSwap.add(amount.mul(salaryFee).div(10000));
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if(amount == 0) {
            super._transfer(from, to, 0);
            return;
        }
        
        isBuyFromLp = automatedMarketMakerPairs[from];
        isSelltoLp = automatedMarketMakerPairs[to];

        bool _isInLaunch = this.isInLaunch();
        
        uint256 currentTimestamp = !isTradingEnabled && _tradingPausedTimestamp > _launchStartTimestamp  ? _tradingPausedTimestamp : _getNow();
        
        if(from != owner() && to != owner()) {

            require(isTradingEnabled, "REED: Trading is currently disabled.");
            require(!_isBlacklisted[to], "REED: Account is blacklisted");
            require(!_isBlacklisted[from], "REED: Account is blacklisted");
            if (_isInLaunch && currentTimestamp.sub(_launchStartTimestamp) <= 300 && isBuyFromLp) {
                require(currentTimestamp.sub(_buyTimesInLaunch[to]) > 60, "REED: Cannot buy more than once per min in first 5min of launch");
            }
            if (!_isExcludedFromMaxTransactionLimit[to] && !_isExcludedFromMaxTransactionLimit[from]) {
                require(amount <= maxTxAmount, "REED: Buy amount exceeds the maxTxBuyAmount.");
            }
            if (!_isExcludedFromMaxWalletLimit[to]) {
                require(balanceOf(to).add(amount) <= maxWalletAmount, "REED: Expected wallet amount exceeds the maxWalletAmount.");
            }

        }
        
        bool canSwap = balanceOf(address(this)) >= minimumTokensBeforeSwap;
        
        if (
            isTradingEnabled && 
            canSwap &&
            !_swapping &&
            !automatedMarketMakerPairs[from] &&
            from != liquidityWallet && to != liquidityWallet &&
            from != marketingWallet && to != marketingWallet &&
            from != buyBackWallet && to != buyBackWallet &&
            from != salaryWallet && to != salaryWallet
        ) {
            _swapping = true;
            _swapAndLiquify();
            _swapping = false;
        }
        
        bool takeFee = !_swapping && isTradingEnabled;
        
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }

        if (takeFee) {
            (uint256 returnAmount, uint256 fee) = _getCurrentTotalFee(isBuyFromLp, amount);
            amount = returnAmount;
            super._transfer(from, address(this), fee);
        }
        
        if (_isInLaunch && currentTimestamp.sub(_launchStartTimestamp) <= 300) {
            if (to != owner() && isBuyFromLp  && currentTimestamp.sub(_buyTimesInLaunch[to]) > 60) {
                _buyTimesInLaunch[to] = currentTimestamp;
            }
        }
        
        super._transfer(from, to, amount);
        
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return IERC20(tokenAddress).transfer(address(this), tokens);
    }

    function _swapAndLiquify() private {
        
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = _liquidityTokensToSwap.add(_marketingTokensToSwap).add(_salaryTokensToSwap).add(_buyBackTokensToSwap);

        // Halve the amount of liquidity tokens
        uint256 tokensInREEDForLiquidity = _liquidityTokensToSwap.div(2);
        uint256 amountToSwapForBNB = contractBalance.sub(tokensInREEDForLiquidity);
        
        // initial BNB balance
        uint256 initialBNBBalance = address(this).balance;
        // Swap the Kodi for BNB
        _swapTokensForBNB(amountToSwapForBNB); 
        // Get the balance, minus what we started with
        uint256 bnbBalance = address(this).balance.sub(initialBNBBalance);
       
        // Divvy up the BNB based on accrued tokens as % of total accrued
        uint256 bnbForMarketing = bnbBalance.mul(_marketingTokensToSwap).div(totalTokensToSwap);
        uint256 bnbForBuyBack = bnbBalance.mul(_buyBackTokensToSwap).div(totalTokensToSwap);
        uint256 bnbForSalary = bnbBalance.mul(_salaryTokensToSwap).div(totalTokensToSwap);
        uint256 bnbForLiquidity = bnbBalance.sub(bnbForMarketing).sub(bnbForBuyBack).sub(bnbForSalary);
        
        _liquidityTokensToSwap = 0;
        _marketingTokensToSwap = 0;
        _salaryTokensToSwap = 0;
        _buyBackTokensToSwap = 0;
        
        payable(buyBackWallet).transfer(bnbForBuyBack);
        payable(salaryWallet).transfer(bnbForSalary);
        payable(marketingWallet).transfer(bnbForMarketing);
        
        _addLiquidity(tokensInREEDForLiquidity, bnbForLiquidity);
        emit SwapAndLiquify(amountToSwapForBNB, bnbForLiquidity, tokensInREEDForLiquidity);

    }

    function _swapTokensForBNB(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            liquidityWallet,
            block.timestamp
        );
    }

}
