// SPDX-License-Identifier: ISC
pragma solidity ^0.8.8;

contract RFID {

    uint32 public ProdCounter = 0 ;
    mapping(uint32 => mapping(string => string)) public VIN_RFID_PARTs ;   // VIN(RFID->Partname)

    struct Product {
        string modelName;
        uint32 modelYear;
        string codeInfo;
    }
    mapping(uint32 => Product) Products ;    // Mapping for VIN number and Product

    /* function to add product info for given VIN number
       VIN Format: YYYYMMxxxxx e.g-> 202303100
    */
    function add_VINfo(uint32 _vin, string memory _modelname, uint32 _modelyear, string memory _code) external {
        Product memory _prod = Product({modelName : _modelname,
                                        modelYear : _modelyear ,
                                        codeInfo  : _code});
        Products[_vin] = _prod;
        ProdCounter += 1;
    }


    // Add RFID and part info manually
    function register_RFid_parts (uint32 _vin, string memory _rfid, string memory _partname) external {
        VIN_RFID_PARTs[_vin][_rfid] = _partname ;
    }

    // Read mapping info
    function read_VINfo (uint32 _vin) public view returns (Product memory) {
        return Products[_vin] ;
    }

    // Fetch all rfid for a given VIN
    // function fetch_RFIDs(uint32 _vin) public view returns (string[] memory, string[] memory) {
    //    string [] memory = new 
    //    return VIN_RFID_PARTs[_vin] ;
    // }
}