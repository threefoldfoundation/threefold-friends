<script>
  export let project;
</script>

<style>
  .image.featured img {
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
  .circle {
    position: relative;
    display: inline-block;
    color: #fff;
  }
  .circle .text {
    position: absolute;
    z-index: 999;
    left: 0;
    right: 0;
    top: 45%;
    text-align: center;
    width: 85%;
  }

  .circle .text h1 {
    color: #fff !important;
  }

  .circle img {
    width: 270px;
  }
</style>

<div class="col-sm-3 circle">
  <a class="image featured mb-0" href="#/circles/{project.name}">
    <img src="images/blue-circle-0.svg" alt="" />
    <div class="text">
      <h1 class="text-capitalize font-weight-bold">{project.name}</h1>
    </div>
  </a>
</div>
