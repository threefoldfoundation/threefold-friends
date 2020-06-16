<script>
export let tags;

  let tags_category = "community"
  if(window.location.href.includes("circles")){
      tags_category = "circles"
  }
  tags = tags.filter(t =>
      t.href.includes(tags_category)
  );

  function getSelected(t){
    var projectsIdx = t.indexOf("#/circles/tags")
    var peopleIdx = t.indexOf("#/community/tags")
    if (projectsIdx != -1)
      return t.substring(projectsIdx+15)
    else if (peopleIdx != -1)
      return t.substring(peopleIdx+19)
    else 
      return "all"
  }

  $: selected = getSelected(location.href)

  function tagSelected(evt){
    selected = evt.target.innerText.toLowerCase()
  }
  

</script>

<ul class="stats">
  <h1>Tags</h1>
  {#each tags as tag}
      {#if tag.name == selected}
      <li class="my-1"><a  on:click={tagSelected} class= "active" href="{tag.href}">{tag.name}</a></li>
      {:else}
      <li class="my-1"><a  on:click={tagSelected} href="{tag.href}">{tag.name}</a></li>
      {/if}
  {/each}

  {#if selected == "all" && tags_category == "circles"}
     <li class="my-1"><a  on:click={tagSelected} class= "active" href="#/circles">ALL</a></li>
  {:else if tags_category == "circles"}
     <li class="my-1"><a   on:click={tagSelected} href="#/circles">ALL</a></li>
  {:else if selected == "all" && tags_category == "community"}
  <li class="my-1"><a  on:click={tagSelected}  class= "active" href="#/community">ALL</a></li>
  {:else if tags_category == "community"}
  <li class="my-1"><a  on:click={tagSelected} href="#/community">ALL</a></li>
  {/if}
</ul>
