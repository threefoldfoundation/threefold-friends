<script>
  import MiniProject from "./MiniProject.svelte";

  export let miniProjects = [];
</script>

<section>
  <div class="mini-posts">
    <h1>Circles</h1>

    <div class="row">
      {#each miniProjects as miniProject}
        <MiniProject {miniProject} />
      {/each}

    </div>
  </div>
</section>
