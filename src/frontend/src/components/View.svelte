<script>
    import Proposal from "./Proposal.svelte";
    import { get } from "svelte/store";
    import { daoActor, principal } from "../views";
    
    async function get_all_proposals() {
      let dao = get(daoActor);
      if (!dao) {
        console.log("error loading dao");
        return;
      }
      let res = await dao.get_all_proposals();
      console.log("Proposals", res);
      return res;
    }
    let promise = get_all_proposals();
    </script>
    
    <div class="text-black">
      {#if $principal }
        {#await promise}
          <p>Loading...</p>
        {:then proposals}
          <div>
            <h1 class="text-black mb-4 text-xl uppercase font-black">Proposals</h1>
            {#if proposals == null || proposals.length == 0}
                <p>no proposals yet</p>
            {:else}
            {#each proposals as proposal}
              <Proposal proposal="{proposal}" />
            {/each}
            {/if}
          </div>
        {:catch error}
          <p style="color: red">{error.message}</p>
        {/await}
      {:else}
        <p class="example-disabled">Connect with Plug first</p>
      {/if}
    </div>
    