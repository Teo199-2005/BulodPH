<template>
  <div class="hpa-skeleton-loader">
    <template v-if="loading && type === 'card-grid'">
      <div v-for="i in count" :key="i" class="hpa-skeleton-card">
        <div class="hpa-skeleton-card__image" />
        <div class="hpa-skeleton-card__body">
          <div class="hpa-skeleton-card__line hpa-skeleton-card__line--title" />
          <div class="hpa-skeleton-card__line hpa-skeleton-card__line--sub" />
          <div class="hpa-skeleton-card__line hpa-skeleton-card__line--short" />
        </div>
      </div>
    </template>
    <template v-else-if="loading && type === 'list-rows'">
      <div v-for="i in count" :key="i" class="hpa-skeleton-list-row">
        <div class="hpa-skeleton-list-row__avatar" />
        <div class="hpa-skeleton-list-row__content">
          <div class="hpa-skeleton-list-row__line hpa-skeleton-list-row__line--main" />
          <div class="hpa-skeleton-list-row__line hpa-skeleton-list-row__line--sub" />
        </div>
      </div>
    </template>
    <template v-else-if="loading && type === 'form-fields'">
      <div v-for="i in count" :key="i" class="hpa-skeleton-form-field">
        <div class="hpa-skeleton-form-field__label" />
        <div class="hpa-skeleton-form-field__input" />
      </div>
    </template>
    <template v-else-if="loading">
      <v-skeleton-loader
        :type="skeletonType"
        :loading="loading"
        :height="height"
      >
        <slot />
      </v-skeleton-loader>
    </template>
    <template v-else>
      <slot />
    </template>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  type?: 'card' | 'table' | 'list' | 'dashboard' | 'form' | 'avatar' | 'text' | 'card-grid' | 'list-rows' | 'form-fields'
  loading?: boolean
  count?: number
  height?: string | number
}

const props = withDefaults(defineProps<Props>(), {
  type: 'card',
  loading: true,
  count: 1,
})

const skeletonType = computed(() => {
  const typeMap: Record<string, string> = {
    card: 'card',
    table: 'table-row@5',
    list: 'list-item-avatar-two-line@3',
    dashboard: 'article',
    form: 'article, actions',
    avatar: 'avatar',
    text: 'text',
  }
  return typeMap[props.type] || 'card'
})
</script>

<style scoped>
.hpa-skeleton-loader {
  width: 100%;
}

/* Card grid variant */
.hpa-skeleton-card {
  background: var(--surface-1, #f8fafc);
  border-radius: var(--radius-lg, 16px);
  overflow: hidden;
  border: 1px solid var(--border-subtle, #e2e8f0);
}

.hpa-skeleton-card__image {
  height: 140px;
  background: linear-gradient(90deg, var(--surface-2, #f1f5f9) 25%, var(--surface-3, #e2e8f0) 50%, var(--surface-2) 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}

.hpa-skeleton-card__body {
  padding: var(--space-4, 16px);
}

.hpa-skeleton-card__line {
  height: 12px;
  border-radius: 4px;
  background: var(--surface-2, #f1f5f9);
  margin-bottom: 8px;
}

.hpa-skeleton-card__line--title {
  width: 70%;
  height: 16px;
}

.hpa-skeleton-card__line--sub {
  width: 50%;
}

.hpa-skeleton-card__line--short {
  width: 30%;
  margin-bottom: 0;
}

/* List rows variant */
.hpa-skeleton-list-row {
  display: flex;
  align-items: center;
  gap: var(--space-3, 12px);
  padding: var(--space-3) 0;
  border-bottom: 1px solid var(--border-subtle, #e2e8f0);
}

.hpa-skeleton-list-row__avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: var(--surface-2, #f1f5f9);
  flex-shrink: 0;
}

.hpa-skeleton-list-row__content {
  flex: 1;
}

.hpa-skeleton-list-row__line {
  height: 10px;
  border-radius: 4px;
  background: var(--surface-2, #f1f5f9);
  margin-bottom: 6px;
}

.hpa-skeleton-list-row__line--main {
  width: 60%;
}

.hpa-skeleton-list-row__line--sub {
  width: 40%;
  margin-bottom: 0;
}

/* Form fields variant */
.hpa-skeleton-form-field {
  margin-bottom: var(--space-4, 16px);
}

.hpa-skeleton-form-field__label {
  width: 80px;
  height: 10px;
  border-radius: 4px;
  background: var(--surface-2, #f1f5f9);
  margin-bottom: 8px;
}

.hpa-skeleton-form-field__input {
  height: 44px;
  border-radius: var(--radius-md, 12px);
  background: var(--surface-2, #f1f5f9);
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>

<style>
/* Skeleton bones use surface tokens for consistency */
.hpa-skeleton-loader :deep(.v-skeleton-loader__bone) {
  background-color: var(--surface-2, #f1f5f9) !important;
}
</style>

