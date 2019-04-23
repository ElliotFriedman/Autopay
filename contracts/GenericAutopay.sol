pragma solidity ^0.5.4;

contract Autopay {


    /*
    
        Data Structures
    
    */
	struct Employee {
		address payable paymentAddress;
		uint32	paymentAmount;
	}

	Employee[] private _allEmployees;
	
	// map an employee's address to their index in the struct array
	//_allEmployees for O(1) lookup times instead of O(n)
	mapping (address => uint256) private _employeeByAddress;

    //index 0 of _allEmployees is set to zero to so that if someone has an 
    //index 0, we know that this is an error
	constructor() public {
	    Employee memory makeIndexNotZero;
	    makeIndexNotZero.paymentAmount = 0;
	    makeIndexNotZero.paymentAddress = address(0);
	    _allEmployees.push(makeIndexNotZero);
	}

	/*

	   Getters

	 */
	 
	 function getEmployeeByAddress(address employeeAdddress) public view returns (uint256, address) {
	     return (
	         _allEmployees[_employeeByAddress[employeeAdddress]].paymentAmount,
	         _allEmployees[_employeeByAddress[employeeAdddress]].paymentAddress
	         );
	 }
	 
	 function getEmployeeByIndex(uint256 employeeIndex) public view returns (uint256, address) {
	     require(employeeIndex < _allEmployees.length, "Index out of bounds");
	     return (
	         _allEmployees[employeeIndex].paymentAmount,
	         _allEmployees[employeeIndex].paymentAddress
	     );
	  }
	  
	  function getAmountOfEmployees() public view returns (uint256) {
	      return _allEmployees.length;
	  }

	/*

	   Setters

	 */

	function removeEmployeeByIndex(uint256 index) public  {
		require(index < _allEmployees.length, "Error, out of bounds index");
		delete _allEmployees[index];
	}


	function removeEmployeeByAddress(address employeeAddress) public  {
		if (_employeeByAddress[employeeAddress] != 0) {
			delete _allEmployees[_employeeByAddress[employeeAddress]];
			delete _employeeByAddress[employeeAddress];
		}
	}

	function addEmployee(address payable employeeAddress, uint32 paymentAmount) public  {
		require(employeeAddress != address(0), "Error, must specify non-zero address");
		Employee memory newEmployee;

		newEmployee.paymentAddress = employeeAddress;
		newEmployee.paymentAmount = paymentAmount;

		//save to storage
		_allEmployees.push(newEmployee);
		_employeeByAddress[employeeAddress] = _allEmployees.length - 1;
	}

	function changeEmployeeSalaryByIndex(uint256 index, uint32 newSalary) public  {
		require(index < _allEmployees.length, "Error, out of bounds index");
		_allEmployees[index].paymentAmount = newSalary;
	}

	function changeEmployeeSalaryByAddress(address employee, uint32 newSalary) public  {
		require(_employeeByAddress[employee] != 0, "Error, no such address exists");
		_allEmployees[_employeeByAddress[employee]].paymentAmount = newSalary;
	}

	function changeEmployeeAddressByAddress(address employee, address payable newAddress) public {
		require(_employeeByAddress[employee] != 0, "Error, no such address exists");

		require(newAddress != address(0), "Error, must specify non-zero address");
		_allEmployees[_employeeByAddress[employee]].paymentAddress = newAddress;
	}

	function changeEmployeeAddressByIndex(uint256 index, address payable newAddress) public {
		require(index < _allEmployees.length, "Error, out of bounds index");
		require(newAddress != address(0), "Error, must specify non-zero address");
		_allEmployees[index].paymentAddress = newAddress;
	}
	
	/*
	   This function will burn lots of gas if you have lots of employees,
	   call at your own riskf

	   Send money to all employees

	 */
	function payEmployees(uint256 weiPerDollar) public payable {
	    // start at index 1 because index 0 is a garbage value
		for (uint256 i = 1; i < _allEmployees.length; i++)  {
			_allEmployees[i].paymentAddress.transfer(_allEmployees[i].paymentAmount * weiPerDollar);
		}
	}

}
