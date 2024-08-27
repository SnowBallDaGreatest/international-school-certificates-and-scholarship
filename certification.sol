// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract InternationalSchool {

    // Define a structure for student certification
    struct Certificate {
        bool isCertified;
        string issuedBy;
        uint256 issuedDate;
    }

    // Define a structure for scholarships
    struct Scholarship {
        string scholarshipName;
        uint256 amount;
        bool isAwarded;
    }

    // Define an enum for roles
    enum Role { None, School, Admin }

    // Mapping from student address to their certification
    mapping(address => Certificate) public certificates;

    // Mapping from student address to scholarships
    mapping(address => Scholarship) public scholarships;

    // Mapping from addresses to their roles
    mapping(address => Role) public roles;

    // Event for certificate issuance
    event CertificateIssued(address indexed student, string issuedBy, uint256 issuedDate);

    // Event for scholarship award
    event ScholarshipAwarded(address indexed student, string scholarshipName, uint256 amount);

    // Modifier to restrict access to only schools
    modifier onlySchool() {
        require(roles[msg.sender] == Role.School, "Only schools can perform this action");
        _;
    }

    // Modifier to restrict access to only administrators
    modifier onlyAdmin() {
        require(roles[msg.sender] == Role.Admin, "Only admins can perform this action");
        _;
    }

    // Function to set roles for addresses (Admin only)
    function setRole(address _address, Role _role) public onlyAdmin {
        roles[_address] = _role;
    }

    // Function to issue a certificate to a student
    function issueCertificate(address _student, string memory _issuedBy) public onlySchool {
        require(!certificates[_student].isCertified, "Student is already certified");
        certificates[_student] = Certificate({
            isCertified: true,
            issuedBy: _issuedBy,
            issuedDate: block.timestamp
        });
        emit CertificateIssued(_student, _issuedBy, block.timestamp);
    }

    // Function to award a scholarship to a student
    function awardScholarship(address _student, string memory _scholarshipName, uint256 _amount) public onlyAdmin {
        require(certificates[_student].isCertified, "Student must be certified to receive a scholarship");
        require(!scholarships[_student].isAwarded, "Scholarship has already been awarded");

        scholarships[_student] = Scholarship({
            scholarshipName: _scholarshipName,
            amount: _amount,
            isAwarded: true
        });
        emit ScholarshipAwarded(_student, _scholarshipName, _amount);
    }

    // Function to get student certification details
    function getCertificate(address _student) public view returns (Certificate memory) {
        return certificates[_student];
    }

    // Function to get student scholarship details
    function getScholarship(address _student) public view returns (Scholarship memory) {
        return scholarships[_student];
    }
}
