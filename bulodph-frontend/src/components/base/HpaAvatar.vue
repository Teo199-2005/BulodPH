<template>
  <div class="hpa-avatar" :class="[sizeClass, { 'hpa-avatar--status': showStatus }]">
    <v-avatar
      :size="avatarSize"
      :color="color"
      :image="src"
      class="hpa-avatar__inner"
    >
      <span v-if="!src && name" class="hpa-avatar__initials">{{ initials }}</span>
      <v-icon v-else-if="!src && !name" icon="mdi-account" />
    </v-avatar>
    <span
      v-if="showStatus && status !== 'offline'"
      class="hpa-avatar__status"
      :class="`hpa-avatar__status--${status}`"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(
  defineProps<{
    src?: string | null
    name?: string
    size?: 'sm' | 'md' | 'lg'
    color?: string
    showStatus?: boolean
    status?: 'online' | 'away' | 'offline'
  }>(),
  { size: 'md', color: 'primary', showStatus: false, status: 'offline' }
)

const avatarSize = computed(() => {
  const map = { sm: 32, md: 40, lg: 56 }
  return map[props.size]
})

const sizeClass = computed(() => `hpa-avatar--${props.size}`)

const initials = computed(() => {
  if (!props.name) return '?'
  return props.name
    .split(/\s+/)
    .slice(0, 2)
    .map((s) => s[0])
    .join('')
    .toUpperCase()
})
</script>

<style scoped>
.hpa-avatar {
  position: relative;
  display: inline-block;
}

.hpa-avatar__inner {
  border: 2px solid var(--surface-0, #fff);
  box-shadow: var(--shadow-sm);
}

.hpa-avatar__initials {
  font-size: 0.875em;
  font-weight: 600;
  color: inherit;
}

.hpa-avatar__status {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: 2px solid var(--surface-0, #fff);
}

.hpa-avatar__status--online {
  background: var(--accent-green, #10b981);
}

.hpa-avatar__status--away {
  background: #f59e0b;
}

.hpa-avatar__status--offline {
  background: var(--text-muted, #94a3b8);
}
</style>
