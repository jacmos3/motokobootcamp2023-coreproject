<script>
    import { plugConnection } from "../connections";
    import { principal } from "../../views.js";
    import { view } from "../../views.js";
    
    const handleView = () => {
      $view.current = $view.view;
    };
    const handleNew = () => {
      $view.current = $view.new;
    };
    const handleVote = () => {
      $view.current = $view.vote;
    };
    </script>
    
    <header class="mb-8 bg-gray text-white">
      <nav class="mx-auto max-w-7xl px-6 lg:px-8" aria-label="Top">
        <div class="flex w-full items-center justify-between py-6 lg:border-none">
          <h1 class="text-4xl font-white">Motoko Bootcamp 2023 - Core Project: DAO </h1>
          </div>
          <div>
            {#if $principal}
                <div class="flex items-center">
                  <div class=" space-x-8 lg:block">
                    <button
                      on:click="{() => handleNew()}"
                      class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard">
                      Create New Proposal
                    </button>
                    <button
                      on:click="{() => handleView()}"
                      class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard">
                      Proposals
                    </button>
                    <button
                      on:click="{() => handleVote()}"
                      class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard">
                      Vote
                    </button>
                  </div>
              </div>
            {:else}
              <button
                class="mr-1 flex items-center px-4 py-2 font-semibold text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
                on:click="{() => plugConnection()}">
               Connect Wallet
              </button>
            {/if}
          </div>
        
      </nav>
    </header>
    