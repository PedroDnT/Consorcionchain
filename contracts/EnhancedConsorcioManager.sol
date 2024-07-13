// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RandomNumberOracle {
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }
}

contract Token {
    mapping(address => uint) public balances;

    function mint(address to, uint amount) public {
        balances[to] += amount;
    }
}

contract EnhancedConsórcio {
    uint public duration;
    uint public contributionAmount;
    uint public participantCount;
    uint public totalFunds;
    address public manager;
    mapping(address => bool) public participants;
    mapping(address => uint) public contributions;
    mapping(uint => address) public recipients;
    uint public currentMonth;
    RandomNumberOracle oracle;
    Token token;

    constructor(uint _duration, uint _contributionAmount, uint _participantCount, address _manager) {
        duration = _duration;
        contributionAmount = _contributionAmount;
        participantCount = _participantCount;
        manager = _manager;
        oracle = new RandomNumberOracle();
        token = new Token();
    }

    function join(address participant) public {
        require(participants[participant] == false, "Already a participant");
        participants[participant] = true;
    }

    function contribute() public payable {
        require(participants[msg.sender], "Not a participant");
        require(msg.value == contributionAmount, "Incorrect contribution amount");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        if (totalFunds <= 20 * contributionAmount * participantCount * duration / 100) {
            token.mint(msg.sender, 2);  // Double reward for early participants
        } else {
            token.mint(msg.sender, 1);
        }
    }

    function selectRecipient() public {
        uint random = oracle.getRandomNumber();
        address recipient = address(uint160(random % participantCount));
        recipients[currentMonth] = recipient;
        currentMonth++;
    }

    function distributeFunds() public {
        address recipient = recipients[currentMonth - 1];
        payable(recipient).transfer(address(this).balance);
    }

    function default(address participant) public {
        require(participants[participant], "Not a participant");
        require(contributions[participant] > 0, "No contributions from participant");
        participants[participant] = false;
        contributions[participant] = 0;  // Forfeit the contributions
    }
}

contract EnhancedConsórcioManager {
    mapping(uint => address) public consórcios;
    uint public consórcioCount;

    function createConsórcio(uint duration, uint contributionAmount, uint participantCount) public {
        EnhancedConsórcio newConsórcio = new EnhancedConsórcio(duration, contributionAmount, participantCount, msg.sender);
        consórcios[consórcioCount] = address(newConsórcio);
        consórcioCount++;
    }

    function joinConsórcio(uint consórcioId) public {
        EnhancedConsórcio(consórcios[consórcioId]).join(msg.sender);
    }

    function getConsórcioDetails(uint consórcioId) public view returns (address) {
        return consórcios[consórcioId];
    }

    function contributeToConsórcio(uint consórcioId) public payable {
        EnhancedConsórcio(consórcios[consórcioId]).contribute{value: msg.value}();
    }

    function selectRecipient(uint consórcioId) public {
        EnhancedConsórcio(consórcios[consórcioId]).selectRecipient();
    }

    function distributeFunds(uint consórcioId) public {
        EnhancedConsórcio(consórcios[consórcioId]).distributeFunds();
    }

    function defaultParticipant(uint consórcioId, address participant) public {
        EnhancedConsórcio(consórcios[consórcioId]).defaultParticipant(participant);
    }
}
