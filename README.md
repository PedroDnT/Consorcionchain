# Decentralized Consórcio (DConsórcio)

## Description

DConsórcio is a blockchain-based version of the traditional Brazilian consórcio. It's a decentralized group savings scheme where participants contribute monthly payments to a pool, and one or more participants are selected to receive the pooled funds each month. This model leverages smart contracts to automate the process, ensuring transparency, security, and fairness without intermediaries.

## Smart Contract Structure

### 1. Enhanced ConsórcioManager Contract

**Purpose:** Manages the creation and overall management of multiple consórcios.

**Key Functions:**
- `createConsórcio`: Create a new consórcio with specific parameters (e.g., duration, monthly contribution, number of participants).
- `joinConsórcio`: Join an existing consórcio, with rewards for early participants.
- `getConsórcioDetails`: Fetch details of a specific consórcio.

### 2. Enhanced Consórcio Contract

**Purpose:** Manages a single consórcio, handling contributions, participant selection, fund distribution, and default penalties.

**Key Functions:**
- `contribute`: Make monthly contributions, with double rewards for early participants.
- `selectRecipient`: Use a secure random function to select recipients, with higher probability for early contributors until 20% of total funds is reached.
- `distributeFunds`: Automatically distribute pooled funds to the selected recipient.
- `default`: Exclude participants who miss payments and forfeit their contributions.
- `withdraw`: Allow participants to withdraw funds if leaving early (subject to rules).

### 3. RandomNumberOracle Contract

**Purpose:** Provide a secure random number for recipient selection.

**Key Functions:**
- `getRandomNumber`: Generate and return a random number for fair selection.
- `callback`: Receive the random number in the Consórcio contract.

### 4. Token Contract (ERC20 or ERC721)

**Purpose:** Represent contributions and rights to receive funds within the consórcio.

**Key Functions:**
- `mint`: Create new tokens representing a participant's share.
- `transfer`: Allow token transfers between participants.

## Contract Interactions

### ConsórcioManager and Consórcio Contracts
- ConsórcioManager creates new Consórcio contracts.
- ConsórcioManager tracks active consórcios and provides access to their details.

### Consórcio Contract and Participants
- **Joining:** Participants join via the Consórcio contract, with early participation rewards.
- **Contributing:** Monthly payments are made through the contribute function, with early contributors receiving double rewards.
- **Selection and Distribution:** The Consórcio contract uses the RandomNumberOracle for recipient selection, favoring early contributors until 20% of total funds is reached.
- **Defaults:** Missed payments result in exclusion and forfeiture of contributions.
