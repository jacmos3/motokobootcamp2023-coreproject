import Principal "mo:base/Principal";
import Proposal "proposal";
import List "mo:base/List";
import Array "mo:base/Array";
import Vote "vote";
import Random "mo:base/Random";
import Option "mo:base/Option";
import Float "mo:base/Float";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";

actor dao{
    type Proposal = Proposal.Proposal;
    type Vote = Vote.Vote;
    type List<T> = List.List<T>;
    var proposalId : Nat = 0;
    var voteId : Nat = 0;
    var proposalList : List<Proposal> = null;
    var voteList : List<Vote> = null;

    // This function get in inputs the proposal data and add it to the list
    public shared ({caller}) func submit_proposal(_title : Text, _description : Text) : async Nat{
        
        if (Text.size(Text.trim(_title, #text " ")) == 0 or Text.size(Text.trim(_description, #text " ")) == 0 ){
            return 0;
        };

        proposalId := await Proposal.generateNewId(proposalId);
        let p : Proposal = Proposal.createProposal(proposalId, _title, _description, caller, null);
        proposalList :=  List.push(p, proposalList);
        
        proposalId;
    };

    // Returns an array of size 1 if the proposal is found given the input Id, size 0 otherwise.
    public query func get_proposal(_proposalId : Nat) : async [Proposal]{
        let findId = func (p : Proposal) : Bool { p.id  == _proposalId };
        Array.filter(List.toArray(proposalList), findId);
    };

    // Returns an array with size 0 if no proposals are set, size n otherwise, depending on the number of the proposals
    public query func get_all_proposals() : async [Proposal]{
        List.toArray(proposalList);
    };

    public query func getVote(_voteId : Nat) : async [Vote]{
        let findId = func (x : Vote) : Bool { x.id  == _voteId };
        Array.filter(List.toArray(voteList), findId);
    };
    public shared ({caller}) func getVoteFromPrincipal(_proposalId : Nat) : async [Vote]{
         return await getVoteFrom(caller, _proposalId);
    };

    private func getVoteFrom(caller:Principal, _proposalId : Nat) : async [Vote]{
        let findId = func (v : Vote) : Bool { v.voter  == caller and v.idProposal == _proposalId};
        Array.filter(List.toArray(voteList), findId);
    };

    // This function casts the user vote to a specific proposal
    public shared ({caller}) func vote(_proposalId : Nat, _vote: Bool) : async ?Nat{
        // avoid voting to not existing proposals
        let prop :[Proposal] = await get_proposal(_proposalId);
        if (Array.equal([],prop, func (p1 :Proposal, p2 :Proposal) : Bool{return p1.id == p1.id })){
            return null;
        };

        // avoid voting from callers with less than 1 votingPowah
        let _votingPowah : Nat = await getVotingPowah(caller);
        if (_votingPowah <= 1)
            return null;

        // avoid voting from users already voted on the given proposal
        let vot :[Vote] = await getVoteFrom(caller, _proposalId);
        for(v in vot.vals()){
            if (v.idProposal == _proposalId)
            return null;
        };
 
        let proposalPowah : Nat = checkProposalPowah(_proposalId);
        if (proposalPowah >= 100){
            return null;
        };

        voteId := await Vote.generateNewId(voteId);
        let v : Vote = Vote.createVote(voteId, _proposalId, caller, _vote, _votingPowah);
        
        voteList :=  List.push(v, voteList);
        
        if (proposalPowah + _votingPowah >= 100){
             closeProposal(_proposalId, _vote);
        };

        ?voteId;
    };

    func checkProposalPowah(_proposalId : Nat) : Nat {
        var index : Nat = 0;
        let findId = func (v : Vote) : Bool {
            if (v.idProposal  == _proposalId) { 
                index += 1; 
                return true
            } 
            else{ 
                return false 
            }
        };
        let proposals :[Vote] = Array.filter(List.toArray(voteList), findId);
        var counter : Nat = 0;
        var sum : Nat = 0;

        while(index > counter){
            sum += proposals[counter].votingPowah;
            counter += 1;
        };

        return sum;
    };

    func closeProposal(_proposalId : Nat, _vote : Bool) : (){
        var counter : Nat = 0;
        //var exit : Bool = false;
        var brandNewList : List<Proposal> = null;
        while(List.get(proposalList,counter) != null){
            var prop : ?Proposal = List.get(proposalList, counter);
            switch(prop) {
                case(null){
                    return (); 
                };
                case(? something){
                    if (something.id == _proposalId){
                        brandNewList := List.push(Proposal.createProposal(something.id, something.title, something.description, something.author, ?_vote), brandNewList);
                    }
                    else{
                      brandNewList := List.push(something,brandNewList);
                    }
                };
            };

            counter +=1;
        };

        proposalList := brandNewList;
    };

    let Ledger : actor { 
        icrc1_balance_of: {owner : Principal;} -> async Nat;
    } = actor("w3j54-iaaaa-aaaak-aeagq-cai");

    func getVotingPowah (caller : Principal) : async Nat {
        //MOCKED
        return Nat8.toNat(Option.get<Nat8>(Random.Finite(await Random.blob()).byte(), 0));
        //return await Ledger.icrc1_balance_of({ owner = caller; });
        //return 2;
    };

    public query func get_all_votes() : async [Vote]{
        List.toArray(voteList);
    };
};