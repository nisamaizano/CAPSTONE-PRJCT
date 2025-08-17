// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElectronicHealthRecord {

    struct Patient {
        uint256 id;
        string name;
        Record[] records; // Changed from mapping to array
    }

    struct Record {
        uint256 id;
        string treatment;
        string documentsHash; // Assuming documents are stored off-chain and only their hashes are stored here
        string description;
        address addedBy;
        string place;
        uint256 timestamp;
        string allergyInfo; // Optional allergy information
    }

    mapping(uint256 => Patient) public patients;
    uint256 public nextPatientId;

    modifier onlyAuthorizedRole(address _role) {
        // Implement authorization logic here, e.g., check if _role is a doctor, pharmacist, etc.
        // This is a placeholder for the actual authorization mechanism.
        require(isAuthorizedRole(_role), "Unauthorized role");
        _;
    }

    function isAuthorizedRole(address _role) internal pure returns (bool) {
    return _role != address(0);
}


    function addRecord(uint256 _patientId, string memory _treatment, string memory _documentsHash, string memory _description, address _addedBy, string memory _place, string memory _allergyInfo) public onlyAuthorizedRole(_addedBy) {
        require(_patientId > 0, "Invalid patient ID");
        require(patients[_patientId].id > 0, "Patient does not exist");

        Record memory newRecord = Record({
            id: nextRecordId++,
            treatment: _treatment,
            documentsHash: _documentsHash,
            description: _description,
            addedBy: _addedBy,
            place: _place,
            timestamp: block.timestamp,
            allergyInfo: _allergyInfo
        });

        // Push the new record into the patient's records array
        patients[_patientId].records.push(newRecord);
    }

    function getPatientRecords(uint256 _patientId) public view returns (Record[] memory) {
        require(_patientId > 0, "Invalid patient ID");
        require(patients[_patientId].id > 0, "Patient does not exist");
        return patients[_patientId].records;
    }

    // Helper function to get the next record ID
    uint256 private nextRecordId;

    constructor() {
        nextRecordId = 0;
    }
}