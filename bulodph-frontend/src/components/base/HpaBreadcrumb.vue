<template>
  <nav aria-label="Breadcrumb" class="hpa-breadcrumb">
    <ol class="hpa-breadcrumb__list">
      <li
        v-for="(item, index) in items"
        :key="item.to || item.label"
        class="hpa-breadcrumb__item"
        :class="{ 'hpa-breadcrumb__item--current': index === items.length - 1 }"
      >
        <router-link
          v-if="index < items.length - 1 && item.to"
          :to="item.to"
          class="hpa-breadcrumb__link"
        >
          {{ item.label }}
        </router-link>
        <span v-else class="hpa-breadcrumb__current" aria-current="page">
          {{ item.label }}
        </span>
        <v-icon
          v-if="index < items.length - 1"
          icon="mdi-chevron-right"
          size="16"
          class="hpa-breadcrumb__separator"
        />
      </li>
    </ol>
  </nav>
</template>

<script setup lang="ts">
export interface BreadcrumbItem {
  label: string
  to?: string
}

defineProps<{
  items: BreadcrumbItem[]
}>()
</script>

<style scoped>
.hpa-breadcrumb {
  margin-bottom: var(--space-4, 16px);
}

.hpa-breadcrumb__list {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.25rem;
  list-style: none;
  margin: 0;
  padding: 0;
  font-size: var(--text-sm, 0.8125rem);
}

.hpa-breadcrumb__item {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.hpa-breadcrumb__link {
  color: var(--text-secondary, #64748b);
  text-decoration: none;
  font-weight: 500;
  padding: 0.25rem 0;
  border-radius: var(--radius-sm, 8px);
  transition: color var(--transition-fast);
}

.hpa-breadcrumb__link:hover {
  color: var(--sky-600, #1e40af);
}

.hpa-breadcrumb__current {
  color: var(--text-primary, #1f2937);
  font-weight: 600;
}

.hpa-breadcrumb__separator {
  color: var(--text-muted, #94a3b8);
  opacity: 0.7;
}

@media (max-width: 599px) {
  .hpa-breadcrumb__list {
    font-size: var(--text-xs, 0.75rem);
  }
}
</style>
