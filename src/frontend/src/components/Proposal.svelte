<script>
  import { daoActor } from "../views.js";
  import { get } from "svelte/store";
  export let proposal;
  var state = "";
  var stateCss = "";
  var canVote = true;

  if (proposal.winner && Array.isArray(proposal.winner) && proposal.winner[0] == 0){
    state = "REJECTED";
    stateCss = "bg-red-400";
  }
  else
  if (proposal.winner && Array.isArray(proposal.winner) && proposal.winner[0] == 1){
    state = "APPROVED";
    stateCss = "bg-green-400";
  }
  else{
    state = "OPEN";
    stateCss = "bg-yellow-400";
  }

  console.log(proposal);
  
  async function voteFor(id, vote) {
    console.log("calling voteFor function");
      let dao = get(daoActor);
      if (!dao) {
        console.log("dao not loaded");
        return;
      }
      else{
        console.log("dao loaded successfull");
      }

      let res = await dao.vote(id, vote);
      console.log(res);
      if (res > 0) {      
        return res;
      } else {
        console.log("err "+res.Err);
        throw new Error(res.Err);
      }
    }

  async function getVoteFromPrincipal(proposalId) {
    let dao = get(daoActor);
    if (!dao) {
      console.log("dao not loaded");
      return;
    };
    console.log("ready to call");
    let res = dao.getVoteFromPrincipal(proposalId);
    res
    .then((r) =>{
      if (r && Array.isArray(r)) {
        console.log("called");
        let vote = r[0];
        console.log(r);
        return vote;
      } else {
        console.log("err "+res.Err);
        throw new Error(res.Err);
      }
    })
    .catch ((e) =>{
      console.log(e);
    });
    
  }

  let promiseVote = getVoteFromPrincipal(proposal.id);
  var promise;

  function handleVote(obj){
    console.log("vote Clicked - " + obj.id, obj.vote);
    promise = voteFor(obj.id, obj.vote);
    canVote = false;
  };

  </script>
  
  <div class="flex flex-wrap gap-y-4 text-white border border-black p-5 m-5">
    <div class="w-full mb-2">
      <div class="flex items-center gap-y-2 gap-x-2">
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            Id:
          </span>
          <span class="bg-black px-2 text-sm text-white">
            {proposal.id}
          </span>
        </div>
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            Author:
          </span>
          <span class="bg-black px-2 text-sm text-white">
            {proposal.author}
          </span>
        </div>
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            state:
          </span>
          <span 
            class="{stateCss} px-2 text-sm text-white">
            {state}
          </span>
        </div>
        <div class="flex items-center">
          <span class="mr-2 align-baseline font-black uppercase">
            ACTION:
          </span>
          {#await promiseVote}
            <span  class=" px-2 text-sm text-white" >...waiting</span>
          {:then v}
            {#if v}
              <span 
              class="{canVote ? "bg-green-400" : "bg-red-400"} px-2 text-sm text-white">
              {!canVote ? "You already voted: " + v.vote + " with " + v.votingPowah + " voting powah": "you can vote"}
            </span>
            {:else}
            <span class = " px-2 text-sm text-white">hey</span>
            {/if}
          {:catch error}
            <span class=" px-2 text-sm text-white" >{error.message}</span>
          {/await}

          
        </div>
      </div>
      <div class="flex items-center gap-y-2">
        {proposal.title}
      </div>
      
    </div>
    <div class="flex flex-wrap gap-y-2 mb-2">
      <p class="w-full">{proposal.description}</p>
    </div>
    {#if proposal && proposal.winner && Array.isArray(proposal.winner) && proposal.winner.length == 0 && canVote == true}
    <div class="flex flex-wrap w-full gap-y-2">
      <div class="w-full flex gap-x-2">
        <div class="w-1/2">
          <button 
            class="w-full bg-green-200 hover:bg-green-400 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black"
            on:click="{handleVote({id: proposal.id, vote:true})}"
            >
            Approve
          </button>
        </div>
        <div class="w-1/2 flex gap-x-2">
          <button 
            class="w-full bg-red-200 hover:bg-red-500 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black"
            on:click="{handleVote({id: proposal.id, vote: false})}"
            >
            Reject
          </button>
        </div>
      </div>
      {#await promise}
          <p class="w-full" style="color: white">...waiting</p>
        {:then prop}
          {#if prop && prop > 0}
            <p class="w-full" style="color: white">
              Vote submitted! {prop}!
            </p>
            {:else}
            <p class="w-full" style="color: white">
              Vote Not submited, maybe you already voted here, or proposal has been closed in the meanwhile, or you own too few MB! {prop}!
            </p>
          {/if}
        {:catch error}
          <p class="w-full" style="color: red">{error.message}</p>
      {/await}
      
    </div>
    {/if}
  </div>
  