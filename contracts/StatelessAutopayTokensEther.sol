pragma solidity ^0.5.4;

import "./IERC20.sol";

contract StatelessAutopay {
    
    function payoutInTokens(
        address contractAddress,
        address[] memory employees,
        uint256[] memory paymentAmount
        ) public {
        for (uint i = 0; i < employees.length; i++) {
            IERC20(contractAddress).transfer(
                employees[i], 
                paymentAmount[i]
                );
        }
    }
    
    function payoutInEther(
        address payable[] memory employees,
        uint256[] memory paymentAmount
        ) public payable {
        for (uint i = 0; i < employees.length; i++) {
            employees[i].transfer(paymentAmount[i]);
        }
    }
}
