<template>
  <span v-html="highlighted" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { highlightSearch } from '@/utils/searchHighlight'

const props = defineProps<{
  text: string
  search: string
}>()

const highlighted = computed(() => highlightSearch(props.text, props.search))
</script>

<style scoped>
/* Parent must not scope this; use :deep or global */
</style>
