// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CertificateManager {
    struct Certificate {
        uint certificateId;
        string studentName;
        string degreeType;
        string issuingInstitution;
    }

    mapping(uint => Certificate) public certificates;

    event CertificateGranted(uint indexed certificateId, string studentName, string degreeType, string issuingInstitution);
    event CertificateRecalled(uint indexed certificateId, string reason);

    function grantCertificate(uint _certificateId, string memory _studentName, string memory _degreeType, string memory _issuingInstitution) public {

        certificates[_certificateId] = Certificate({
            certificateId: _certificateId,
            studentName: _studentName,
            degreeType: _degreeType,
            issuingInstitution: _issuingInstitution
        });

        emit CertificateGranted(_certificateId, _studentName, _degreeType, _issuingInstitution);
    }

    function recallCertificate(uint _certificateId, string memory _reason) public {

        delete certificates[_certificateId];

        emit CertificateRecalled(_certificateId, _reason);
    }
}
