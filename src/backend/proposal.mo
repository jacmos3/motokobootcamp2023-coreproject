module {
    public type Proposal = {
        id: Nat;
        title: Text;
        description: Text;
        author: Principal;
    };
    public func create_book(_id : Nat, _title : Text, _description : Text, _author: Principal) : Proposal {
        {id = _id; title = _title; description = _description; author = _author};    
    }

    
}
