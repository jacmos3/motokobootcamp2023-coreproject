module {
    public type Proposal = {
        id: Nat;
        title: Text;
        description: Text;
        author: Principal;
    };

    // This function generates a new proposal id
    public func generateNewId(_proposalId : Nat) : async Nat {
        //TODO : create randomness, if needed
        (_proposalId + 1);
    };

    // This function create the proposal by given data
    public func createProposal(_id : Nat, _title : Text, _description : Text, _author: Principal) : Proposal {
        {
            id = _id; 
            title = _title; 
            description = _description; 
            author = _author
        };
    }

    
}
