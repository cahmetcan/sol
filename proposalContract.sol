// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./counterLib.sol";

contract ProposalContract {
    struct Proposal {
        string title;
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
    }

    uint256 private counter;

    mapping(uint256 => Proposal) proposal_history;

    function create(
        string calldata title,
        string calldata _description,
        uint256 _total_vote_to_end
    ) external {
        counter += 1;
        proposal_history[counter] = Proposal(
            title,
            _description,
            0,
            0,
            0,
            _total_vote_to_end,
            false,
            true
        );
    }
}
