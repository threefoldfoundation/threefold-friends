<script>
  export let tags = [];
  let tags_category = "circles";

  tags = tags.filter(t => t.href.includes(tags_category));

  function getSelected(t) {
    var projectsIdx = t.indexOf("#/circles/tags");
    if (projectsIdx != -1) return t.substring(projectsIdx + 15);
    else return "all";
  }

  $: selected = getSelected(location.href);

  function tagSelected(evt) {
    selected = evt.target.innerText.toLowerCase();
  }
</script>

<style>
  .circle {
    height: 250px;
    background-image: url("/images/green-circle_new.svg");
    background-repeat: no-repeat;
    text-align: center;
    background-position: center;
    -webkit-transition: transform 0.2s ease-out;
    -moz-transition: transform 0.2s ease-out;
    -o-transition: transform 0.2s ease-out;
    -ms-transition: transform 0.2s ease-out;
    transition: transform 0.2s ease-out;
  }

  .circle:hover {
    -moz-transform: scale(1.05);
    -webkit-transform: scale(1.05);
    -ms-transform: scale(1.05);
    transform: scale(1.05);
  }

  .circle span {
    display: inline-block;
    margin-top: 5.5em;
    color: #fff;
  }
</style>

<div class="row">
  {#each tags as tag}
    <div class="col-sm-3 mb-5">
      <a
        class="circle image featured mb-0"
        on:click={tagSelected}
        href={tag.href}>
        <span class="text-capitalize font-weight-bold">{tag.name}</span>
      </a>
    </div>
  {/each}
</div>
