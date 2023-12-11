// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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

    address owner;

    uint256 private counter;

    mapping(uint256 => Proposal) proposal_history;

    address[] private voted_addresses;

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    modifier isNewVoter(address _address) {
        require(isVoted(_address), "Address allready voted");
        _;
    }

    modifier isActive() {
        require(
            proposal_history[counter].is_active == true,
            "The proposal is not active"
        );
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function create(
        string calldata title,
        string calldata _description,
        uint256 _total_vote_to_end
    ) external onlyOwner {
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

    function calculateCurrentState() private view returns (bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 approve = proposal.approve;
        uint256 reject = proposal.reject;
        uint256 pass = proposal.pass;

        if (pass % 2 == 1) {
            pass += 1;
        }

        pass = pass / 2;

        if (approve > reject + pass) {
            return true;
        } else {
            return false;
        }
    }

    function isVoted(address _address) internal view returns (bool) {
        bool check = false;
        for (uint8 i = 0; i < voted_addresses.length; i++) {
            if (voted_addresses[i] == _address) {
                check = true;
                return check;
            }
        }
        return check;
    }

    function vote(uint8 choice) external isActive {
        // 1 - approve // 2 - reject // 0 - pass
        Proposal storage proposal = proposal_history[counter];
        uint total_vote = proposal.approve + proposal.reject + proposal.pass;

        voted_addresses.push(msg.sender);

        if (choice == 1) {
            proposal.approve += 1;
        } else if (choice == 2) {
            proposal.reject -= 1;
        } else if (choice == 0) {
            proposal.pass += 1;
        }

        proposal.current_state = calculateCurrentState();

        if (
            (proposal.total_vote_to_end - total_vote == 1) &&
            (choice == 1 || choice == 2 || choice == 0)
        ) {
            proposal.is_active = false;
            voted_addresses = [owner];
        }
    }
}
