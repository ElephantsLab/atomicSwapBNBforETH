pragma solidity ^0.4.24;

contract LolToken {



    string public constant name = "Lol Token";
    string public constant symbol = "LoL";
    uint8 public constant decimals = 18;


    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_;
    using SafeMath for uint256;

    constructor(uint256 total) public {
        totalSupply_ = total*(10**decimals);
        balances[msg.sender] = totalSupply_;
    }

    //возвращает количество всех токенов, выделенных по этому контракту, независимо от владельца.
    //отвечает за общую эмиссию токенов, обеспечивая невозможность создания новых токенов по достижении максимального числа.
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }


    //вернет текущий остаток токенов со счета, идентифицированного по адресу его владельца.
    //пределяет изначальное количество токенов, приписанных к определенному адресу
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    //перемещения суммы токенов со счета одного владельца на счет другого владельца, или получателя.
    //обеспечивает передачу токенов пользователю, который инвестировал в проект во время ICO
    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    //не очень понятно зачем. позволить владельцу, т. е. msg.sender, утвердить счет делегата — возможно, сам рынок, — для снятия токенов со своего счета и перевода их на другие счета.
    //служит для проверки того, что смарт-контракт, исходя из общей эмиссии, может осуществлять дистрибуцию токенов
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    //возвращает подтвержденное на текущий момент владельцем счета количество токенов для конкретного делегата, как установлено функцией approve.
    //необходима для проверки того, на адресе имеется достаточный баланс для отправки токенов на другой адрес.
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    //позволяет делегату, одобренному для вывода средств, переводить средства владельца счета на сторонний счет.
    //необходима для совершения транзакций между пользователями.
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}


library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}