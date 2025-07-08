# 🔗 Solidity Smart Contract Projects

This repository contains decentralized applications (dApps) built using Solidity and deployed on the Ethereum blockchain. Each project demonstrates real-world use cases in supply chain, finance, insurance, rentals, and agriculture. These projects were built using Remix IDE, MetaMask, and tested in a local development environment.

---

## 🌾 1. Agricultural Commodity Tracking

A transparent blockchain-based tracking system for agricultural goods. It ensures trust by recording product movement at every stage in the supply chain.

### ✨ Features
- Registers roles like farmers, distributors, retailers
- Tracks product journey to prevent counterfeiting
- Ensures data integrity with immutable records

### 🛠 Technologies Used
- Solidity
- Remix IDE
- MetaMask

### 🧠 Smart Contract Functions
- registerUser(): Registers participants like farmers, sellers
- addItem(): Adds new agricultural product with unique ID
- updateLocation(): Tracks product movement
- getItemHistory(): Fetches complete trace of product

### 📌 Future Improvements
- Add QR code integration
- Real-time price tracking with oracles
- ---

## 💰 2. Blockchain-Based Loan Application

A decentralized lending system where users can apply for loans, and smart contracts handle eligibility, approval, and repayment tracking — all without intermediaries.

### ✨ Features
- Accepts loan applications via wallet address
- Automatically checks eligibility and stores borrower data
- Tracks loan repayment with time-based conditions

### 🛠 Technologies Used
- Solidity
- Remix IDE
- MetaMask

### 🧠 Smart Contract Functions
- applyForLoan(): Submit loan application with required details
- approveLoan(): Admin function to approve loans
- repayLoan(): Allows users to repay loans
- getLoanStatus(): Checks current loan status

### 📌 Future Improvements
- Add credit score logic using decentralized identity
- Integrate with Chainlink for real-time interest rate updates
- ---

## 🛡️ 3. Insurance Claim Automation

A smart contract that automates the entire insurance claim process — from submission to payout — based on predefined rules and conditions.

### ✨ Features
- Policy registration and claim submission by users
- Automatic validation of claim eligibility
- Instant payout triggered by smart contract logic

### 🛠 Technologies Used
- Solidity
- Remix IDE
- MetaMask

### 🧠 Smart Contract Functions
- registerPolicy(): Adds a new insurance policy
- submitClaim(): Users submit insurance claims
- approveClaim(): Validates and processes the claim
- getPolicyDetails(): Returns policy and claim status

### 📌 Future Improvements
- Integrate external data oracles for accident/weather verification
- Add multi-signature approval for higher claim amounts
- ---

## 🏠 4. Rental Agreement Contract

A blockchain-based rental system for managing lease agreements, rent payments, and contract termination securely between landlords and tenants.

### ✨ Features
- Digital signing of rental agreements
- Transparent rent payment tracking
- Auto-termination after lease period or breach

### 🛠 Technologies Used
- Solidity
- Remix IDE
- MetaMask

### 🧠 Smart Contract Functions
- createAgreement(): Initiates a rental agreement
- payRent(): Allows tenants to pay rent securely
- terminateAgreement(): Ends the contract upon lease completion or violation
- getAgreementDetails(): Displays contract terms and rent status

### 📌 Future Improvements
- Integrate with real estate APIs for property data
- Add KYC for tenant and landlord identity verification
- ---

## 🚚 5. Supply Chain Management

A blockchain-powered supply chain application for tracking product flow from manufacturer to retailer, ensuring authenticity and transparency.

### ✨ Features
- Registers roles: manufacturer, distributor, retailer
- Tracks asset transfer at each supply chain stage
- Maintains immutable product history on-chain

### 🛠 Technologies Used
- Solidity
- Remix IDE
- MetaMask

### 🧠 Smart Contract Functions
- registerParticipant(): Adds new supply chain participants
- createProduct(): Adds a new product with metadata
- transferOwnership(): Moves product to next supply chain role
- getProductDetails(): Views full product history

### 📌 Future Improvements
- Integrate barcode scanning for real-time updates
- Add user-friendly dashboard for visual product tracking
- ---

## 📫 Contact

Feel free to connect with me:  
- 🔗 [LinkedIn](https://www.linkedin.com/in/haripriyachiravuri)  
- 💻 [GitHub](https://github.com/haripriya123-tech)  
- 📧 Email: haripriyachiravuri@gmail.com
