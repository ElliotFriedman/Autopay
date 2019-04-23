pragma solidity ^0.5.4;

import "./Ownable.sol";

contract Autopay is Ownable {

	struct Employee {
		address payable paymentAddress;
		uint32	paymentAmount;
	}

	Employee[] private _allEmployees;
	mapping (address => Employee) private _employeeByAddress;

	constructor() Ownable() public {}


	/*

	   Setters

	 */

	function removeEmployeeByIndex(uint256 index) public onlyOwner {
		require(index < _allEmployees.length, "Error, out of bounds index");
		delete _allEmployees[index];
	}

	function removeEmployeeByAddress(address employeeAddress) public onlyOwner {
		if (_employeeByAddress[employeeAddress].paymentAddress == employeeAddress) {
			delete _employeeByAddress[employeeAddress];
		}
	}

	function addEmployee(address payable employeeAddress, uint32 paymentAmount) public onlyOwner {
		require(employeeAddress != address(0), "Error, must specify non-zero address");
		Employee memory newEmployee;

		newEmployee.paymentAddress = employeeAddress;
		newEmployee.paymentAmount = paymentAmount;

		//save to storage
		_allEmployees.push(newEmployee);
		_employeeByAddress[employeeAddress] = newEmployee;
	}

	function changeEmployeeSalaryByIndex(uint256 index, uint32 newSalary) public onlyOwner {
		require(index < _allEmployees.length, "Error, out of bounds index");
		_allEmployees[index].paymentAmount = newSalary;
	}

	function changeEmployeeSalaryByAddress(address employee, uint32 newSalary) public onlyOwner {
		require(_employeeByAddress[employee].paymentAddress != address(0), "Error, no such address exists");
		_employeeByAddress[employee].paymentAmount = newSalary;
	}

	function changeEmployeeAddressByAddress(address employee, address payable newAddress) public onlyOwner {
		require(_employeeByAddress[employee].paymentAddress != address(0), "Error, no such address exists");

		require(newAddress != address(0), "Error, must specify non-zero address");
		_employeeByAddress[employee].paymentAddress = newAddress;
	}

	function changeEmployeeAddressByIndex(uint256 index, address payable newAddress) public onlyOwner {
		require(index < _allEmployees.length, "Error, out of bounds index");
		require(newAddress != address(0), "Error, must specify non-zero address");
		_allEmployees[index].paymentAddress = newAddress;
	}

	/*

	   Send money to all employees

	 */
	function payEmployees(uint256 weiPerDollar) public payable onlyOwner {
		for (uint256 i = 0; i < _allEmployees.length; i++)  {
			_allEmployees[i].paymentAddress.transfer(_allEmployees[i].paymentAmount * weiPerDollar);
		}
	}

}
