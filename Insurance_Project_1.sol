// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract InsuranceContract {
    address public insurer; 

    struct PolicyAgreement {
        string policyAddress;
        address policyholder;
        uint256 premiumAmount;
        uint256 coverage;
        uint256 duration;
    }

    mapping(uint256 => PolicyAgreement) public policyAgreements;
    uint256 public agreementCounter;

    event NewPolicyAgreement(uint256 policyId, address policyholder, uint256 premiumAmount);
    event PolicyPaid(uint256 policyId, uint256 amountPaid, uint256 timestamp);
    event PolicyTerminated(uint256 policyId, uint256 timestamp);

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can call this.");
        _;
    }

    modifier onlyPolicyholder(uint256 _policyId) {
        require(
            msg.sender == policyAgreements[_policyId].policyholder,
            "Only policyholder can call this."
        );
        _;
    }

    constructor() {
        insurer = msg.sender;
    }

    function createPolicyAgreement(
        string memory _policyAddress,
        address _policyholder,
        uint256 _premiumAmount,
        uint256 _coverage,
        uint256 _duration
    ) public onlyInsurer {
        agreementCounter++;
        policyAgreements[agreementCounter] = PolicyAgreement({
            policyAddress: _policyAddress,
            policyholder: _policyholder,
            premiumAmount: _premiumAmount,
            coverage: _coverage,
            duration: _duration
        });

        emit NewPolicyAgreement(agreementCounter, _policyholder, _premiumAmount);
    }

    function payPremium(uint256 _policyId) public payable onlyPolicyholder(_policyId) {
        require(
            msg.value == policyAgreements[_policyId].premiumAmount,
            "Incorrect premium amount."
        );

        emit PolicyPaid(_policyId, msg.value, block.timestamp);
    }

    function terminatePolicy(uint256 _policyId) public onlyInsurer {
        require(policyAgreements[_policyId].policyholder != address(0), "Policy does not exist.");

        emit PolicyTerminated(_policyId, block.timestamp);
        delete policyAgreements[_policyId];
    }

    function getPolicyDetails(uint256 _policyId)
        public
        view
        returns (
            string memory,
            address,
            uint256,
            uint256,
            uint256
        )
    {
        PolicyAgreement memory policy = policyAgreements[_policyId];
        require(policy.policyholder != address(0), "Policy does not exist.");

        return (
            policy.policyAddress,
            policy.policyholder,
            policy.premiumAmount,
            policy.coverage,
            policy.duration
        );
    }
}