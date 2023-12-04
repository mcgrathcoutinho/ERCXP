| Property                                                                          | Tested |
|-----------------------------------------------------------------------------------|--------|
| User cannot call `flashLoan()` when it is paused                                  | Yes    |
| Any time a flashLoan is taken, `totalSupply()` should be incremented by flashFee  | Yes    |
| Fee recipient always receives flashFee provided it is non-zero                    | Yes    |