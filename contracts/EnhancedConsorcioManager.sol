// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract EnhancedConsórcio {
    address public admin;
    uint public duration;
    uint public contributionAmount;
    uint public participantCount;

    constructor(uint _duration, uint _contributionAmount, uint _participantCount, address _admin) {
        admin = _admin;
        duration = _duration;
        contributionAmount = _contributionAmount;
        participantCount = _participantCount;
    }

    function join(address participant) public {
        // Implementation for joining a consórcio
        // This is a placeholder and needs to be implemented based on specific requirements
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
}
