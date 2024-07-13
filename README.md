## Description
This is a decentralized Consórcio (DConsórcio), which is a blockchain-based version of the traditional Brazilian consórcio. Consórcio is a popular group savings scheme where participants contribute monthly payments to a pool, and one or more participants are selected to receive the pooled funds each month. This decentralized model leverages smart contracts to automate the process, ensuring transparency, security, and fairness without the need for intermediaries.

## Simplified Structure
### A. Enhanced ConsórcioManager Contract
Purpose: Manages the creation and overall management of multiple consórcios.

Functions:
- createConsórcio: Allows users to create a new consórcio with specific parameters (e.g., total duration, monthly contribution amount, number of participants).
- joinConsórcio: Allows users to join an existing consórcio, with additional rewards for early participants.
- getConsórcioDetails: Fetches details of a specific consórcio.

### B. Enhanced Consórcio Contract
Purpose: Manages a single consórcio, handling contributions, participant selection, fund distribution, and penalties for defaults.

Functions:
- contribute: Allows participants to make their monthly contributions, with double rewards for early participants.
- selectRecipient: Uses a secure random function with increased probability for early contributors until 20% of the total required funds is reached.
- distributeFunds: Automatically distributes the pooled funds to the selected recipient.
- default: If a participant misses a payment, they are excluded from the group and their contributions are forfeited.
- withdraw: Allows participants to withdraw their funds if they leave the consórcio before completion (following specific rules).

### C. RandomNumberOracle Contract
Purpose: Provides a secure random number for selecting the recipient each period.

Functions:
- getRandomNumber: Generates and returns a random number to ensure fair recipient selection.
- callback: Used by the Consórcio contract to receive the random number.

### D. Token Contract (ERC20 or ERC721)
Purpose: Represents the contributions and the right to receive funds within the consórcio.

Functions:
- mint: Mints new tokens representing a participant’s share in the consórcio.
- transfer: Allows the transfer of tokens between participants.

## Relationships and Interactions
Enhanced ConsórcioManager and Enhanced Consórcio Contracts:
- Creation: The Enhanced ConsórcioManager contract is responsible for creating new Enhanced Consórcio contracts.
- Management: It keeps track of all active consórcios and provides functions to fetch their details.

Enhanced Consórcio and Participants:
- Joining: Participants interact with the Enhanced Consórcio contract to join a consórcio, receiving additional rewards for early participation.
- Contributing: Each month, participants call the contribute function to make their payments, with early contributors receiving double the rewards.
- Selection and Distribution: The Enhanced Consórcio contract interacts with the RandomNumberOracle to select a recipient, with early contributors having double the chance of being selected until 20% of the total funds is reached.
- Default: If a participant misses a payment, they are excluded from the group and their contributions are forfeited.