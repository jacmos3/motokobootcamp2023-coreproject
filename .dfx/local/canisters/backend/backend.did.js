export const idlFactory = ({ IDL }) => {
  const Vote = IDL.Record({
    'id' : IDL.Nat,
    'votingPowah' : IDL.Nat,
    'voter' : IDL.Principal,
    'vote' : IDL.Bool,
    'idProposal' : IDL.Nat,
  });
  const Proposal = IDL.Record({
    'id' : IDL.Nat,
    'title' : IDL.Text,
    'winner' : IDL.Opt(IDL.Bool),
    'description' : IDL.Text,
    'author' : IDL.Principal,
  });
  return IDL.Service({
    'getVote' : IDL.Func([IDL.Nat], [IDL.Vec(Vote)], ['query']),
    'getVoteFromPrincipal' : IDL.Func(
        [IDL.Principal, IDL.Nat],
        [IDL.Vec(Vote)],
        ['query'],
      ),
    'get_all_proposals' : IDL.Func([], [IDL.Vec(Proposal)], ['query']),
    'get_all_votes' : IDL.Func([], [IDL.Vec(Vote)], ['query']),
    'get_proposal' : IDL.Func([IDL.Nat], [IDL.Vec(Proposal)], ['query']),
    'submit_proposal' : IDL.Func([IDL.Text, IDL.Text], [IDL.Nat], []),
    'vote' : IDL.Func([IDL.Nat, IDL.Bool], [IDL.Opt(IDL.Nat)], []),
  });
};
export const init = ({ IDL }) => { return []; };
