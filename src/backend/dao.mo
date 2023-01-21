import Principal "mo:base/Principal";
import Proposal "./proposal";
import List "mo:base/List";
import Array "mo:base/Array";

actor dao{
    type Proposal = Proposal.Proposal;
    type List<T> = List.List<T>;
    var counter : Nat = 0;
    var proposalList : List<Proposal> = null;

    // This function tracks the counter of the IDs
    public func generateNewId() : async Nat {
        counter += 1;
        return counter;
    };

    public shared ({caller}) func submit_proposal(_title : Text, _description : Text) : async Nat{
        // I generate a new proposal Id
        let _id : Nat = await generateNewId();
        
        // I create a new proposal with the input data and the Id
        let p : Proposal = Proposal.createProposal(_id, _title, _description, caller);

        // I add the proposal to the list
        proposalList :=  List.push(p, proposalList);

        // I return the proposalId to the user
        _id;
    };

    // Returns an array of size 1 if the proposal is found given the input Id, size 0 otherwise.
    public query func get_proposal(proposalId : Nat) : async [Proposal]{
        let findId = func (x : Proposal) : Bool { x.id  == proposalId };
    
        //I return the filtered array
        Array.filter(List.toArray(proposalList), findId);
    };

    // Returns an array with size 0 if no proposals are set, size n otherwise, depending on the number of the proposals
    public query func get_all_proposals() : async [Proposal]{
        List.toArray(proposalList);
    };

    public func vote(proposalId : Nat, user : Principal, vote: Bool) : (){
    };

   
};