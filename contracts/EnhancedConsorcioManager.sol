// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract RandomNumberOracle {
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));
    }
}

contract Token {
    mapping(address => uint) public balances;

    function mint(address to, uint amount) public {
        balances[to] += amount;
    }
}

contract EnhancedConsorcio {
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

    function defaultParticipant(address participant) public {
        require(participants[participant], "Not a participant");
        require(contributions[participant] > 0, "No contributions from participant");
        participants[participant] = false;
        contributions[participant] = 0;  // Forfeit the contributions
    }
}

contract EnhancedConsorcioManager {
    mapping(uint => address) public consorcios;
    uint public consorcioCount;

    function createConsorcio(uint duration, uint contributionAmount, uint participantCount) public {
        EnhancedConsorcio newConsorcio = new EnhancedConsorcio(duration, contributionAmount, participantCount, msg.sender);
        consorcios[consorcioCount] = address(newConsorcio);
        emit ConsorcioCreated(consorcioCount, address(newConsorcio));
        consorcioCount++;
    }

    function joinConsorcio(uint consorcioId) public {
        EnhancedConsorcio(consorcios[consorcioId]).join(msg.sender);
        emit ParticipantJoined(consorcioId, msg.sender);
    }

    function getConsorcioDetails(uint consorcioId) public view returns (address) {
        return consorcios[consorcioId];
    }

    function contributeToConsorcio(uint consorcioId) public payable {
        EnhancedConsorcio(consorcios[consorcioId]).contribute{value: msg.value}();
        emit ContributionMade(consorcioId, msg.sender, msg.value);
    }

    function selectRecipient(uint consorcioId) public {
        EnhancedConsorcio(consorcios[consorcioId]).selectRecipient();
        address recipient = EnhancedConsorcio(consorcios[consorcioId]).recipients(EnhancedConsorcio(consorcios[consorcioId]).currentMonth() - 1);
        emit RecipientSelected(consorcioId, recipient);
    }

    function distributeFunds(uint consorcioId) public {
        address recipient = EnhancedConsorcio(consorcios[consorcioId]).recipients(EnhancedConsorcio(consorcios[consorcioId]).currentMonth() - 1);
        uint amount = address(consorcios[consorcioId]).balance;
        EnhancedConsorcio(consorcios[consorcioId]).distributeFunds();
        emit FundsDistributed(consorcioId, recipient, amount);
    }

    function defaultParticipant(uint consorcioId, address participant) public {
        EnhancedConsorcio(consorcios[consorcioId]).defaultParticipant(participant);
        emit ParticipantDefaulted(consorcioId, participant);
    }

    // Add events for better tracking and frontend integration
    event ConsorcioCreated(uint indexed consorcioId, address consorcioAddress);
    event ParticipantJoined(uint indexed consorcioId, address participant);
    event ContributionMade(uint indexed consorcioId, address participant, uint amount);
    event RecipientSelected(uint indexed consorcioId, address recipient);
    event FundsDistributed(uint indexed consorcioId, address recipient, uint amount);
    event ParticipantDefaulted(uint indexed consorcioId, address participant);
}
