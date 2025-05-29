// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title LoanApplicationManager
 * @dev Smart contract to manage loan applications between applicants and lenders.
 */
contract LoanApplicationManager {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this.");
        _;
    }

    enum LoanStatus { Applied, Approved, Rejected, Disbursed, Closed }

    struct LoanApplication {
        address applicant;
        uint256 amount;
        uint256 duration; // in months
        uint256 interestRate; // in basis points (e.g., 500 = 5%)
        LoanStatus status;
        string reason;
    }

    uint256 public applicationCounter = 0;
    mapping(uint256 => LoanApplication) public applications;

    // Events
    event LoanApplied(uint256 applicationId, address indexed applicant, uint256 amount, uint256 interestRate, uint256 duration);
    event LoanApproved(uint256 applicationId);
    event LoanRejected(uint256 applicationId, string reason);
    event LoanDisbursed(uint256 applicationId);
    event LoanClosed(uint256 applicationId);

    /**
     * @dev Submit a new loan application
     * @param _amount Requested loan amount
     * @param _duration Duration in months
     * @param _interestRate Interest rate in basis points (e.g., 500 = 5%)
     */
    function applyForLoan(uint256 _amount, uint256 _duration, uint256 _interestRate) public {
        require(_amount > 0, "Loan amount must be greater than zero");
        require(_duration > 0, "Loan duration must be greater than zero");

        applicationCounter++;
        applications[applicationCounter] = LoanApplication({
            applicant: msg.sender,
            amount: _amount,
            duration: _duration,
            interestRate: _interestRate,
            status: LoanStatus.Applied,
            reason: ""
        });

        emit LoanApplied(applicationCounter, msg.sender, _amount, _interestRate, _duration);
    }

    /**
     * @dev Approve a loan application
     * @param _applicationId ID of the loan application
     */
    function approveLoan(uint256 _applicationId) public onlyOwner {
        LoanApplication storage application = applications[_applicationId];
        require(application.status == LoanStatus.Applied, "Loan must be in Applied state");

        application.status = LoanStatus.Approved;
        emit LoanApproved(_applicationId);
    }

    /**
     * @dev Reject a loan application
     * @param _applicationId ID of the loan application
     * @param _reason Reason for rejection
     */
    function rejectLoan(uint256 _applicationId, string memory _reason) public onlyOwner {
        LoanApplication storage application = applications[_applicationId];
        require(application.status == LoanStatus.Applied, "Loan must be in Applied state");

        application.status = LoanStatus.Rejected;
        application.reason = _reason;
        emit LoanRejected(_applicationId, _reason);
    }

    /**
     * @dev Disburse loan funds (simulated here, actual fund transfer is off-chain)
     * @param _applicationId ID of the loan application
     */
    function disburseLoan(uint256 _applicationId) public onlyOwner {
        LoanApplication storage application = applications[_applicationId];
        require(application.status == LoanStatus.Approved, "Loan must be approved to disburse");

        application.status = LoanStatus.Disbursed;
        emit LoanDisbursed(_applicationId);
    }

    /**
     * @dev Close a loan after full repayment
     * @param _applicationId ID of the loan application
     */
    function closeLoan(uint256 _applicationId) public onlyOwner {
        LoanApplication storage application = applications[_applicationId];
        require(application.status == LoanStatus.Disbursed, "Loan must be disbursed to close");

        application.status = LoanStatus.Closed;
        emit LoanClosed(_applicationId);
    }

    /**
     * @dev Get details of a specific loan application
     * @param _applicationId ID of the loan application
     */
    function getLoanDetails(uint256 _applicationId)
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            LoanStatus,
            string memory
        )
    {
        require(_applicationId > 0 && _applicationId <= applicationCounter, "Invalid application ID");
        LoanApplication memory app = applications[_applicationId];
        return (app.applicant, app.amount, app.duration, app.interestRate, app.status, app.reason);
    }
}
