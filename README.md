# ERCXP - ERC Experimental

ERCXP is a repository created to experiment, play and review the OZ v0.5 contracts. 

## What do I intend to learn

1. Understand OZ v0.5 contract implementations in depth
2. Testing using foundry (for specific contracts). This is to test edge case scenarios or issues I was looking forward to but was disproved by a test. If a test proves an issue to exist, it will be reported to the bounty program on ImmuneFi. Any minor QA issues will be opened as a issue on the OZ repository itself.
3. Performing a security review on each contract to see if any bugs exist. Check out my [Audit Portfolio](https://github.com/mcgrathcoutinho/audit-portfolio) for more information on my experience in the smart contract security space.

## What do I unintentionally learn
1. OZ contract implementations used by other projects, which will help me fasten my security review process
2. Enforcing practice with different types of testing
3. Foundry itself

## Why do this now?

1. Although I have a good grasp of most OZ implementations, I intend to leave no stone unturned in understanding and reviewing the core infrastructure that most projects rely on today, the OZ contracts.
2. Overall, breaking version changes occur every 5-6 months, thus this time-frame window is perfect to start diving deep into the v0.5 contracts to ensure OZ implementations are correct and adhere to EIP standards.

## What contracts does the repository contain?

1. Known and less known ERCs
2. Contracts that are not ERCs/EIPs but implemented by OZ for the community
3. Differences between ERCs that are extremely similar and their tradeoffs

## How should each explanation be structured?

1. Intro - To briefly explain what contract is used for
2. Explanation for each function internal workings 
   - Brief explanation for easy to understand functions
   - Deep explanation for difficult to understand functions
3. Unknown tradeoffs/assumptions 
   - Assumptions end devs using this contract have to make
   - Tradeoffs or Additions compared to any similar contracts previously explained
4. Links 
   - Example implementation
   - Tests for the example implementation
5. EIP spec maintained in all instances of implementation: Yes/No
   - Stating EIP spec violations, if any
6. Any additional fields as required to keep the aspect of experimentation intact during the process

## Structure

The repository will follow a hierarchical tree structure for both the src and test folders.

For src:
1. Level 0 - Contract Type: OZ structure followed such as tokens, governance, proxy etc.
2. Level 1 - Grouping each ERC separately with explanation and example implementation

For test:
1. Level 0 - Contract Type: OZ structure followed such as tokens, governance, proxy etc.
2. Level 1 - Grouping each ERC separately with different types of tests. Difficult to understand contracts will receive more emphasis.