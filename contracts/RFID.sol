// SPDX-License-Identifier: ISC

pragma solidity ^0.8.8;

import "hardhat/console.sol";

contract RFID {

    // Array to store all VINs
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

    // ToDo Create an event for
    // + New VIN added
    // + RFID updated for a given VIN
    // + 

    /* function to add product info for given VIN number
       VIN Format: YYYYMMxxxxx e.g-> 202303100
    */
    function add_VINfo(uint32 _vin, string memory _modelname, uint32 _modelyear, string memory _code, string[] memory _rfids) external {
        Product memory _prod = Product({modelName : _modelname,
                                        modelYear : _modelyear ,
                                        codeInfo  : _code,
                                        rfids     : _rfids});
        Products[_vin] = _prod;
        VINs.push(_vin);
    }

    // Read vehicle metadata by VIN number
    // ToDo - Check if VIN exists and returns an error message if not found
    function get_matadata_byVIN (uint32 _vin) public view returns (string memory, uint32, string memory) {
        return (Products[_vin].modelName, Products[_vin].modelYear, Products[_vin].codeInfo);
    }

    // Read all RFIDs by VIN number
    // ToDO - check if VIN exits
    function get_all_rfids(uint32 _vin) external view returns (string [] memory) {
        return Products[_vin].rfids ;
    }
    
    // Total registered VINs
    function product_Count() external view returns (uint) {
        return VINs.length ;
    }
    
    // Update RFID of a VIN
    //ToDo- Only authorized person(s) can do it
    function update_rfid_byVIN(uint32 _vin, string memory _old_rfid, string memory _new_rfid) external returns (bool) {
        string[] memory _tempArray = Products[_vin].rfids ;
        for (uint i=0; i< _tempArray.length; i++){
            if (keccak256(abi.encodePacked(_tempArray[i])) == keccak256(abi.encodePacked(_old_rfid))){
                (Products[_vin].rfids)[i] = _new_rfid;
                return true;
            } else {
                return false ;
            }
        }
    }

    // Add, additional RFID to an existing VIN (one at a time)
    function add_NewRfid_toVIN(uint32 _vin, string memory _add_rfid) external returns (bool){
        (Products[_vin].rfids).push(_add_rfid);
        return true;
    }

    // Remove an RFID from VIN
    // ToDo- Only authorized person(s) can do it
    function remove_rfid_fromVIN(string memory _rfid, uint32 _vin) external returns (bool) {
        string[] memory _tempArray = Products[_vin].rfids ;
        for (uint i=0; i< _tempArray.length; i++){
            if (keccak256(abi.encodePacked(_tempArray[i])) == keccak256(abi.encodePacked(_rfid))){
                delete (Products[_vin].rfids)[i] ;
                console.log("Deleted RFID", (Products[_vin].rfids)[i]);
                return true;
            } else {
                return false ;
            }
        }
    }

    // 

}