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

    function defaultParticipant(address participant) public {
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
        emit ConsórcioCreated(consórcioCount, address(newConsórcio));
        consórcioCount++;
    }

    function joinConsórcio(uint consórcioId) public {
        EnhancedConsórcio(consórcios[consórcioId]).join(msg.sender);
        emit ParticipantJoined(consórcioId, msg.sender);
    }

    function getConsórcioDetails(uint consórcioId) public view returns (address) {
        return consórcios[consórcioId];
    }

    function contributeToConsórcio(uint consórcioId) public payable {
        EnhancedConsórcio(consórcios[consórcioId]).contribute{value: msg.value}();
        emit ContributionMade(consórcioId, msg.sender, msg.value);
    }

    function selectRecipient(uint consórcioId) public {
        EnhancedConsórcio(consórcios[consórcioId]).selectRecipient();
        address recipient = EnhancedConsórcio(consórcios[consórcioId]).recipients(EnhancedConsórcio(consórcios[consórcioId]).currentMonth() - 1);
        emit RecipientSelected(consórcioId, recipient);
    }

    function distributeFunds(uint consórcioId) public {
        address recipient = EnhancedConsórcio(consórcios[consórcioId]).recipients(EnhancedConsórcio(consórcios[consórcioId]).currentMonth() - 1);
        uint amount = address(consórcios[consórcioId]).balance;
        EnhancedConsórcio(consórcios[consórcioId]).distributeFunds();
        emit FundsDistributed(consórcioId, recipient, amount);
    }

    function defaultParticipant(uint consórcioId, address participant) public {
        EnhancedConsórcio(consórcios[consórcioId]).defaultParticipant(participant);
        emit ParticipantDefaulted(consórcioId, participant);
    }

    // Add events for better tracking and frontend integration
    event ConsórcioCreated(uint indexed consórcioId, address consórcioAddress);
    event ParticipantJoined(uint indexed consórcioId, address participant);
    event ContributionMade(uint indexed consórcioId, address participant, uint amount);
    event RecipientSelected(uint indexed consórcioId, address recipient);
    event FundsDistributed(uint indexed consórcioId, address recipient, uint amount);
    event ParticipantDefaulted(uint indexed consórcioId, address participant);
}
