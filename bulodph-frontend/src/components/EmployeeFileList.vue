<template>
  <v-list v-if="items.length" class="pa-0">
    <v-list-item
      v-for="doc in items"
      :key="doc.id"
      class="doc-list-item"
      :subtitle="doc.uploadedAt"
    >
      <template #prepend>
        <v-icon icon="mdi-file-document-outline" color="primary" class="mr-3" />
      </template>
      <v-list-item-title>{{ doc.name }}</v-list-item-title>
      <template #append>
        <v-btn icon="mdi-download" variant="text" size="small" aria-label="Download file" />
        <v-btn icon="mdi-delete-outline" variant="text" size="small" color="error" aria-label="Remove file" @click="$emit('remove', doc.id)" />
      </template>
    </v-list-item>
  </v-list>
  <p v-else class="text-body-2 text-medium-emphasis mb-0">No documents in this section. Add documents to keep employee files in one place.</p>
</template>

<script setup lang="ts">
defineProps<{
  items: Array<{ id: number; name: string; uploadedAt: string }>
}>()
defineEmits<{ (e: 'remove', id: number): void }>()
</script>

<style scoped>
.doc-list-item { border-bottom: 1px solid rgba(30, 58, 95, 0.08); }
.doc-list-item:last-child { border-bottom: none; }
</style>
