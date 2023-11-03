// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CertificateVerifier {
    struct VerificationRecord {
        address verifier;
        uint certificateId;
        bool isValid;
        uint verificationTime;
    }

    mapping(address => mapping(uint => VerificationRecord)) public verificationRecords;

    event CertificateVerified(address indexed verifier, uint indexed certificateId, bool isValid, uint verificationTime);

    function verifyCertificate(uint _certificateId, bool _isValid) public {

        verificationRecords[msg.sender][_certificateId] = VerificationRecord({
            verifier: msg.sender,
            certificateId: _certificateId,
            isValid: _isValid,
            verificationTime: block.timestamp
        });

        emit CertificateVerified(msg.sender, _certificateId, _isValid, block.timestamp);
    }

}