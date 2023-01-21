module {
    public type Proposal = {
        id: Nat;
        title: Text;
        description: Text;
        author: Principal;
        winner: ?Bool;
    };

    // This function generates a new proposal id
    public func generateNewId(_proposalId : Nat) : async Nat {
        //TODO : create randomness, if needed
        (_proposalId + 1);
    };

    // This function create the proposal by given data
    //winner is null when the proposal is created and untill it is not closed. When it gets closed, then it finalizes to true (passed) or false (rejected)
    public func createProposal(_id : Nat, _title : Text, _description : Text, _author: Principal, _winner : ?Bool) : Proposal {
        {
            id = _id; 
            title = _title; 
            description = _description; 
            author = _author;
            winner = _winner;
        };
    }

    
}
