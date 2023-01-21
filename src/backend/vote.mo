module {
    public type Vote = {
        id: Nat;
        idProposal: Nat;
        voter: Principal;
        vote: Bool;
        votingPowah : Nat;
    };
    
    // This function generates a new vote id
    public func generateNewId(_proposalId : Nat) : async Nat {
        //TODO : create randomness, if needed
        (_proposalId + 1);
    };

    // This function create the vote by given data
    public func createVote(_id : Nat, _idProposal : Nat, _voter : Principal, _vote : Bool, _votingPowah : Nat) : Vote {
        {
            id = _id; 
            idProposal = _idProposal; 
            voter = _voter; 
            vote = _vote;
            votingPowah = _votingPowah;
        };    
    }

    
}
