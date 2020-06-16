<script>
  import { projects } from "../../store.js";
  import CircleItem from "../components/CircleItem.svelte";

  import marked from "marked";

  import * as animateScroll from "svelte-scrollto";
  animateScroll.scrollToTop();

  const url = window.location.href;
  let current_project = url
    .substring(url.lastIndexOf("/") + 1)
    .split("%20")
    .join(" ");

  export let params = {};
  export let projectsList = $projects;

  $: if (params.tagname) {
    //watch the params.id for changes
    projectsList = getProjects();
  }

  function filterProjects(category) {
    return $projects.filter(project =>
      project.ecosystem.categories.includes(category)
    );
  }

  function getProjects() {
    if (params.tagname) {
      return filterProjects(params.tagname);
    } else {
      return $projects;
    }
  }
</script>

<style>
  .current_circle {
    position: relative;
    display: inline-block;
  }

  .current_circle .text h1 {
    color: #fff !important;
  }
  .current_circle .text {
    position: absolute;
    z-index: 999;
    margin: 0 auto;
    left: 0;
    right: 0;
    top: 45%;
    text-align: center;
    width: 60%;
  }
</style>

<!-- Wrapper -->

<div id="wrapper">
  <!-- Main -->
  <div id="main">
    <a class="text-capitalize" href="#/circles">
      <i class="fas fa-arrow-left" />
      Back to circles
    </a>

    <div class="row">
      <div class="offset-sm-4 col-sm-4 current_circle my-5">
        <img src="/images/green-circle_new.svg" alt={current_project} />
        <div class="text">
          <h1>{current_project}</h1>
        </div>
      </div>
    </div>

    <div class="row">
      {#each projectsList as project}
        <CircleItem {project} />
      {/each}
    </div>
  </div>
</div>
