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

