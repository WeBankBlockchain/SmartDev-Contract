<template>
  <div id="app">
    <!-- <div class="videoContainer">
      <video class="fullscreenVideo" id="bgVid" playsinline="" autoplay="" muted="" loop="">
        <source src="./assets/cage.mp4" type="video/mp4">
      </video>
  </div> -->
    <router-view/>
    
  </div>
</template>

<style>
#app{
  position: relative;
  height: 100%;
}

/* .videoContainer{
  position: fixed;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: -100;
}

.videoContainer:before{
  content: "";
  position: absolute;
  width: 100%;
  height: 100%;
  display: block;
  z-index: -1;
  top: 0;
  left: 0;
  background: rgba(25,29,34,.65);
  background-size: cover;
}

.fullscreenVideo{
  width: 100%;
  height: 100%;
  object-fit: fill;
  opacity:0.9;
} */

</style>
