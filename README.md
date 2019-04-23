# Contract Deployment
To deploy the contracts, start ganache (gui or cli but make sure to specify which port you are using in the config file)

then run this command:

```
truffle migrate
```

then enter truffle console

```
truffle console
```

let's talk to the contract to make sure it works

```
(await Autopay.deployed()).addEmployee('insert your address here', insert dollar amount here)
```

Time to call the payout function to make sure the contract functions properly.

```
(await Autopay.deployed()).payEmployees(insert dollar amount here, {value: 1 ether})
```


## Data Structures Used

First a struct was used to keep track of each employee individually. This struct holds the employee's address and the amount they should be paid.

```
struct Employee {
		address payable paymentAddress;
		uint32	paymentAmount;
}
```

Now we need to keep track of all these employees so we will make a dynamic array of all of our employees

```
Employee[] private _allEmployees;
```

The problem with this array comes in when we want to retrieve an employee. We will have to iterate through the whole array or remember where this employee's index is. Both of these are not good solutions.

We will make a mapping that maps an address to an employee struct so that we can easily retrieve and update an employee in O(1) time.

```
mapping (address => Employee) private _employeeByAddress;
```

That's all for our data structures.

### Files Explained

There are both generic and specialized use cases included in this repository. Autopay.sol is customized for a single owner while the stateless versions are for when you would like to transfer tokens and ether without having a contract owner.

#### Caution

If you use stateless erc20 token transfer be warned as you will have to send tokens to the contract before you can send them to your recipients which opens you up to COMPLETE LOSS of funds if someone can get their transaction to transfer your tokens confirmed before you can.
