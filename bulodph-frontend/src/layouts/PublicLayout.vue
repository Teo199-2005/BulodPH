<template>
  <div class="public-layout">
    <PublicNavbar />
    <main ref="mainRef" class="public-main">
      <slot />
    </main>
    <PublicFooter />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import PublicNavbar from '@/components/PublicNavbar.vue'
import PublicFooter from '@/components/PublicFooter.vue'
import { useGsapReveal } from '@/composables/useGsapReveal'

const mainRef = ref<HTMLElement | null>(null)
useGsapReveal(mainRef, {
  selector: '.scroll-reveal',
  y: 24,
  duration: 0.5,
  stagger: 0.06,
  start: 'top 88%',
})
</script>

<style scoped>
.public-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.public-main {
  flex-grow: 1;
}
</style>
