// SPDX-License-Identifier: ISC

pragma solidity ^0.8.8;

import "hardhat/console.sol";

contract RFID {

    // Array to store all VINs used where iterations is required
    uint32 [] VINs ;

    // Structure to create a product blueprint with all fields
    struct Product {
        string modelName;
        uint32 modelYear;
        string codeInfo;
        string [] rfids;
    }

    // Mapping for VIN number and Product
    mapping(uint32 => Product) Products ;
    mapping(uint32 => bool) VIN_HASHMAP ;  // to save gas cost while searching for vin

    // Events for various purpose
    event added_newVIN(uint32 indexed vin);
    event rfid_updated(uint32 indexed _vin, string indexed _old_rfid, string indexed _new_rfid);
    

    // VIN Format: YYYYMMxxxxx e.g-> 202303100
    function add_VINfo(uint32 _vin, string memory _modelname, uint32 _modelyear, string memory _code, string[] memory _rfids) external {
        if (VIN_HASHMAP[_vin] != true) {   // avoid redundant storage of same vin
            Product memory _prod = Product({modelName : _modelname,
                                            modelYear : _modelyear ,
                                            codeInfo  : _code,
                                            rfids     : _rfids});
            Products[_vin] = _prod;
            VINs.push(_vin);            // add vin to array
            VIN_HASHMAP[_vin] = true ;  // hash table for vin to quickly search for availability
            emit added_newVIN(_vin);
        }
    }

    // Read vehicle metadata by VIN number
    function get_matadata_byVIN (uint32 _vin) public view returns (string memory, uint32, string memory) {
        require(VIN_HASHMAP[_vin] == true, "This VIN is not available !") ;
        return (Products[_vin].modelName, Products[_vin].modelYear, Products[_vin].codeInfo);
    }

    // Read all RFIDs by VIN number
    function get_all_rfids(uint32 _vin) external view returns (string [] memory) {
        require(VIN_HASHMAP[_vin] == true, "This VIN is not available !") ;
        return Products[_vin].rfids ;
    }
    
    // Total registered VINs
    function product_Count() external view returns (uint) {
        return VINs.length ;
    }

    // Read VIN logs
    function get_all_vins() external view returns (uint32[] memory) {
        return VINs ;
    }
    
    // Update RFID of a VIN
    //ToDo- Only authorized person(s) can do it and add this person's info to track who made the change
    function update_rfid_byVIN(uint32 _vin, string memory _old_rfid, string memory _new_rfid) external returns (bool success) {
        string[] memory _tempArray = Products[_vin].rfids ;
        for (uint i=0; i< _tempArray.length; i++){
            if (keccak256(abi.encodePacked(_tempArray[i])) == keccak256(abi.encodePacked(_old_rfid))){
                (Products[_vin].rfids)[i] = _new_rfid;
                emit rfid_updated(_vin, _old_rfid, _new_rfid);
                success = true;
            } 
            else success = false ;
        }
        return success;
    }

    // Add, additional RFID to an existing VIN (one at a time)
    function add_NewRfid_toVIN(uint32 _vin, string memory _add_rfid) external returns (bool){
        (Products[_vin].rfids).push(_add_rfid);
        return true;
    }

    // Remove an RFID from VIN
    // ToDo- Only authorized person(s) can do it
    function remove_rfid_fromVIN(string memory _rfid, uint32 _vin) external returns (bool success) {
        string[] memory _tempArray = Products[_vin].rfids ;
        for (uint i=0; i< _tempArray.length; i++){
            if (keccak256(abi.encodePacked(_tempArray[i])) == keccak256(abi.encodePacked(_rfid))){
                delete (Products[_vin].rfids)[i] ;
                console.log("Deleted RFID", (Products[_vin].rfids)[i]);
                success = true;
            } else success = false ;
        }
        return success ;
    }

    /*ToDo 
    : Create a whitelist 
        > Make two accounts as admin - deployer and proxy
        > Function to request access for moderator role
        > Function to approve as moderator
    : Create a BlackList
        > Function to ban users - for users no longer available/banned
    */

} //end of RFID contract