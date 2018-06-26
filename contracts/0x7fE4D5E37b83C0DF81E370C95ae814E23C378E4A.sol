
//Address: 0x7fE4D5E37b83C0DF81E370C95ae814E23C378E4A
//Contract name: Fundraiser
//Balance: 0 Ether
//Verification Date: 7/12/2017
//Transacion Count: 2

// CODE STARTS HERE

pragma solidity 0.4.11;

contract Fundraiser {

  /* State */

  address public signer1;
  address public signer2;

  enum Action {
    None,
    Withdraw
  }
  
  struct Proposal {
    Action action;
    address destination;
    uint256 amount;
  }
  
  Proposal public signer1_proposal;
  Proposal public signer2_proposal;

  /* Constructor, choose signers. Those cannot be changed */
  function Fundraiser(address init_signer1,
                      address init_signer2) {
    signer1 = init_signer1;
    signer2 = init_signer2;
    signer1_proposal.action = Action.None;
    signer2_proposal.action = Action.None;
  }

  /* Entry points for signers */

  function Withdraw(address proposed_destination,
                    uint256 proposed_amount) {
    /* check amount */
    if (proposed_amount > this.balance) { throw; }
    /* update action */
    if (msg.sender == signer1) {
      signer1_proposal.action = Action.Withdraw;
      signer1_proposal.destination = proposed_destination;
      signer1_proposal.amount = proposed_amount;
    } else if (msg.sender == signer2) {
      signer2_proposal.action = Action.Withdraw;
      signer2_proposal.destination = proposed_destination;
      signer2_proposal.amount = proposed_amount;
    } else { throw; }
    /* perform action */
    MaybePerformWithdraw();
  }

  function MaybePerformWithdraw() internal {
    if (signer1_proposal.action == Action.Withdraw
        && signer2_proposal.action == Action.Withdraw
        && signer1_proposal.amount == signer2_proposal.amount
        && signer1_proposal.destination == signer2_proposal.destination) {
      signer1_proposal.action = Action.None;
      signer2_proposal.action = Action.None;
      signer1_proposal.destination.transfer(signer1_proposal.amount);
    }
  }

}