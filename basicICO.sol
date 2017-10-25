/*
Simple smart contract of initial coin offering
https://ethereum.github.io/browser-solidity/
*/
pragma solidity ^0.4.0;

contract BasicICO {

    bytes32 public standard = 'BasicICO 1.0';
    bytes32 public name;
    bytes32 public symbol;
    uint8 public decimals;
    uint256 public supplyLimit;

    address[] public stackholderList;
    mapping (address => uint256) public stakeholderID;
    address[] activestackholderList;
    // balances:
    mapping (address => uint256) public balanceOf;
  
    function BasicICO() public {
        uint256 initialSupplyLimit = 1000000;
        balanceOf[msg.sender] = initialSupplyLimit; 
        supplyLimit = initialSupplyLimit;
        name = "ANGS";
        symbol = "angs";
        decimals = 0;

        stakeholderID[this] = stackholderList.push(this) - 1;
        stakeholderID[msg.sender] = stackholderList.push(msg.sender) - 1;
        activestackholderList.push(msg.sender); // add current address to active stackholderList
    }

    // Raise public event on blockchain to notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    function getCurrentstackholderList() public returns (address[]) {
        delete activestackholderList;
        for (uint256 i=0; i < stackholderList.length; i++) {
            if (balanceOf[stackholderList[i]] > 0) {
                activestackholderList.push(stackholderList[i]);
            }
        } 
        return activestackholderList;
    }

    function getStakeHolderAdressByID(uint256 _id) public view returns (address) {
        return stackholderList[_id];
    }

    function getBalanceByAdress(address _address) public view returns (uint256) {
        return balanceOf[_address];
    }

    function getMyStakeholderID() public view returns (uint256) {
        return stakeholderID[msg.sender];
    }

    function getMyCoins() public view returns (uint256) {
        return balanceOf[msg.sender];
    }

    //Transfer coins to another address from current stakeholder
    function transfer(address _to, uint256 _value) public {
        //assertions
        if (_value < 1) revert();
        if (this == _to) revert();
        if (balanceOf[msg.sender] < _value) revert();

        // make transaction: substract from Stakeholder to Recepient
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        // Add new address to stock ledger:
        if (stakeholderID[_to] == 0) {
            stakeholderID[_to] = stackholderList.push(_to) - 1;
        }

        // Notify all listeners about this transfer
        Transfer(msg.sender, _to, _value);
    }

    /* This function calls to prevent accidential send of ethers */
    function () public {
        revert();
    }
}
