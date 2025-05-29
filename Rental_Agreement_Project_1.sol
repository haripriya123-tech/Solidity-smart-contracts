// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title PropertyRental
 * @dev A smart contract for managing property rental agreements
 */
contract PropertyRental {
    address public landlord;
    uint256 public securityDeposit;
    
    constructor(uint256 _securityDeposit) {
        landlord = msg.sender;
        securityDeposit = _securityDeposit;
    }
    
    modifier onlyLandlord() {
        require(msg.sender == landlord, "Only landlord can call this.");
        _;
    }
    
    modifier onlyTenant(address _tenant) {
        require(msg.sender == _tenant, "Only tenant can call this.");
        _;
    }
    
    struct RentalAgreement {
        string propertyAddress;
        address tenant;
        uint256 rentAmount;
        uint256 leaseStartDate;
        uint256 leaseEndDate;
        uint256 securityDeposit;
        bool active;
        bool depositPaid;
        bool depositReturned;
    }
    
    mapping(uint256 => RentalAgreement) public rentalAgreements;
    uint256 public agreementCounter;
    
    // Events
    event NewAgreement(uint256 agreementId, address tenant, uint256 rentAmount);
    event RentPaid(uint256 agreementId, uint256 amount, uint256 timestamp);
    event LeaseTerminated(uint256 agreementId, uint256 timestamp);
    event SecurityDepositPaid(uint256 agreementId, address tenant, uint256 amount);
    event SecurityDepositReturned(uint256 agreementId, address tenant, uint256 amount);
    event FundsWithdrawn(uint256 amount, uint256 timestamp);
    
    /**
     * @dev Creates a new rental agreement
     * @param _propertyAddress Physical address of the rental property
     * @param _tenant Address of the tenant
     * @param _rentAmount Monthly rent amount in wei
     * @param _leaseStartDate Start date of the lease (UNIX timestamp)
     * @param _leaseEndDate End date of the lease (UNIX timestamp)
     */
    function createRentalAgreement(
        string memory _propertyAddress,
        address _tenant,
        uint256 _rentAmount,
        uint256 _leaseStartDate,
        uint256 _leaseEndDate
    ) public onlyLandlord {
        require(_leaseEndDate > _leaseStartDate, "Lease end date must be after start date");
        require(_tenant != address(0), "Invalid tenant address");
        require(_rentAmount > 0, "Rent amount must be greater than zero");
        
        agreementCounter++;
        rentalAgreements[agreementCounter] = RentalAgreement({
            propertyAddress: _propertyAddress,  
            tenant: _tenant,
            rentAmount: _rentAmount,
            leaseStartDate: _leaseStartDate,
            leaseEndDate: _leaseEndDate,
            securityDeposit: securityDeposit,
            active: true,
            depositPaid: false,
            depositReturned: false
        });
        
        emit NewAgreement(agreementCounter, _tenant, _rentAmount);
    }
    
    /**
     * @dev Allows tenant to pay security deposit
     * @param _agreementId ID of the rental agreement
     */
    function paySecurityDeposit(uint256 _agreementId) public payable {
        require(_agreementId > 0 && _agreementId <= agreementCounter, "Invalid agreement ID");
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        require(agreement.active, "Lease agreement is not active");
        require(msg.sender == agreement.tenant, "Only tenant can pay security deposit");
        require(!agreement.depositPaid, "Security deposit already paid");
        require(msg.value == agreement.securityDeposit, "Incorrect security deposit amount");
        
        agreement.depositPaid = true;
        emit SecurityDepositPaid(_agreementId, msg.sender, msg.value);
    }
    
    /**
     * @dev Allows tenant to pay rent
     * @param _agreementId ID of the rental agreement
     */
    function payRent(uint256 _agreementId) public payable {
        require(_agreementId > 0 && _agreementId <= agreementCounter, "Invalid agreement ID");
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        require(agreement.active, "Lease agreement is not active");
        require(msg.sender == agreement.tenant, "Only tenant can pay rent");
        require(agreement.depositPaid, "Security deposit must be paid first");
        require(msg.value == agreement.rentAmount, "Incorrect rent amount");
        require(block.timestamp <= agreement.leaseEndDate, "Lease period has ended");
        
        emit RentPaid(_agreementId, msg.value, block.timestamp);
    }
    
    /**
     * @dev Terminates a lease agreement
     * @param _agreementId ID of the rental agreement
     */
    function terminateLease(uint256 _agreementId) public onlyLandlord {
        require(_agreementId > 0 && _agreementId <= agreementCounter, "Invalid agreement ID");
        require(rentalAgreements[_agreementId].active, "Lease agreement is not active");
        
        rentalAgreements[_agreementId].active = false;
        emit LeaseTerminated(_agreementId, block.timestamp);
    }
    
    /**
     * @dev Returns security deposit to tenant
     * @param _agreementId ID of the rental agreement
     */
    function returnSecurityDeposit(uint256 _agreementId) public onlyLandlord {
        require(_agreementId > 0 && _agreementId <= agreementCounter, "Invalid agreement ID");
        RentalAgreement storage agreement = rentalAgreements[_agreementId];
        
        require(!agreement.active, "Lease must be terminated first");
        require(agreement.depositPaid, "Security deposit was never paid");
        require(!agreement.depositReturned, "Security deposit already returned");
        
        address tenant = agreement.tenant;
        uint256 amount = agreement.securityDeposit;
        
        require(address(this).balance >= amount, "Insufficient contract balance");
        
        agreement.depositReturned = true;
        payable(tenant).transfer(amount);
        emit SecurityDepositReturned(_agreementId, tenant, amount);
    }
    
    /**
     * @dev Allows landlord to withdraw funds from the contract
     */
    function withdrawFunds() public onlyLandlord {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(landlord).transfer(balance);
        emit FundsWithdrawn(balance, block.timestamp);
    }
    
    /**
     * @dev Gets details of a rental agreement
     * @param _agreementId ID of the rental agreement
     * @return All fields of the rental agreement
     */
    function getAgreementDetails(uint256 _agreementId)
        public
        view
        returns (
            string memory,
            address,
            uint256,
            uint256,
            uint256,
            uint256,
            bool,
            bool,
            bool
        )
    {
        require(_agreementId > 0 && _agreementId <= agreementCounter, "Invalid agreement ID");
        RentalAgreement memory agreement = rentalAgreements[_agreementId];
        return (
            agreement.propertyAddress,
            agreement.tenant,
            agreement.rentAmount,
            agreement.leaseStartDate,
            agreement.leaseEndDate,
            agreement.securityDeposit,
            agreement.active,
            agreement.depositPaid,
            agreement.depositReturned
        );
    }
    
    /**
     * @dev Gets current contract balance
     * @return Contract balance in wei
     */
    function getContractBalance() public view onlyLandlord returns (uint256) {
        return address(this).balance;
    }
}