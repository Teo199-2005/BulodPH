<template>
  <div ref="containerRef" class="hpa-empty-state text-center pa-8">
    <!-- Image/Illustration -->
    <div class="empty-state-image mb-6">
      <v-img
        v-if="imageUrl"
        :src="imageUrl"
        :alt="effective.title"
        max-width="300"
        class="mx-auto"
      />
      <v-icon
        v-else-if="effective.icon"
        :icon="effective.icon"
        size="96"
        class="empty-state-icon"
      />
    </div>

    <!-- Title -->
    <h3 class="heading-card mb-3">
      {{ effective.title }}
    </h3>

    <!-- Description -->
    <p class="empty-state-description mb-6">
      {{ effective.description }}
    </p>

    <!-- Action Button (min 44px tap target per accessibility) -->
    <v-btn
      v-if="effective.actionText"
      color="primary"
      variant="elevated"
      size="large"
      :prepend-icon="actionIcon"
      class="empty-state-action"
      @click="$emit('action')"
    >
      {{ effective.actionText }}
    </v-btn>

    <!-- Slot for custom content -->
    <slot />
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, onBeforeUnmount } from 'vue'

const containerRef = ref<HTMLElement | null>(null)
let gsapCtx: { revert: () => void } | null = null

onMounted(async () => {
  if (!containerRef.value || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return
  const el = containerRef.value
  const { default: gsap } = await import('gsap')
  gsapCtx = gsap.context(() => {
    gsap.fromTo(el, { opacity: 0 }, { opacity: 1, duration: 0.4, ease: 'power2.out' })
  }, el)
})

onBeforeUnmount(() => {
  gsapCtx?.revert()
  gsapCtx = null
})

export type EmptyStatePreset =
  | 'no-vehicles'
  | 'no-results'
  | 'no-bookings'
  | 'no-favorites'
  | 'no-promos'
  | 'no-notifications'
  | 'no-payouts'

const PRESETS: Record<EmptyStatePreset, { title: string; description: string; icon: string; actionText?: string }> = {
  'no-vehicles': {
    title: 'No vehicles yet',
    description: 'Add your first vehicle to start accepting rentals.',
    icon: 'mdi-car-outline',
    actionText: 'Add vehicle',
  },
  'no-results': {
    title: 'No results found',
    description: 'Try adjusting your filters or search term.',
    icon: 'mdi-magnify',
  },
  'no-bookings': {
    title: 'No bookings yet',
    description: 'Your upcoming bookings will appear here.',
    icon: 'mdi-calendar-blank-outline',
    actionText: 'Browse rentals',
  },
  'no-favorites': {
    title: 'No favorites yet',
    description: 'Save vehicles you like to find them easily later.',
    icon: 'mdi-heart-outline',
    actionText: 'Browse rentals',
  },
  'no-promos': {
    title: 'No promos available',
    description: 'Check back later for special offers.',
    icon: 'mdi-tag-outline',
  },
  'no-notifications': {
    title: 'No notifications',
    description: 'You\'re all caught up. New notifications will appear here.',
    icon: 'mdi-bell-outline',
  },
  'no-payouts': {
    title: 'No payouts yet',
    description: 'Your payout history will appear here once you receive payments.',
    icon: 'mdi-bank-outline',
  },
}

interface Props {
  title?: string
  description?: string
  icon?: string
  imageUrl?: string
  actionText?: string
  actionIcon?: string
  /** Use a preset for common empty states (overrides title/description/icon/actionText) */
  preset?: EmptyStatePreset
}

const props = withDefaults(defineProps<Props>(), {
  actionIcon: 'mdi-plus',
})

const effective = computed(() => {
  if (props.preset && PRESETS[props.preset]) {
    const p = PRESETS[props.preset]
    return {
      title: p.title,
      description: p.description,
      icon: p.icon,
      actionText: p.actionText,
    }
  }
  return {
    title: props.title ?? 'Nothing here yet',
    description: props.description ?? 'Check back later or take an action.',
    icon: props.icon ?? 'mdi-information-outline',
    actionText: props.actionText,
  }
})

defineEmits<{
  'action': []
}>()
</script>

<style scoped>
.hpa-empty-state {
  min-height: 400px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-radius: var(--radius-lg, 16px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04), 0 1px 2px rgba(255, 255, 255, 0.4) inset;
}

.empty-state-image {
  animation: fadeInUp 0.6s ease-out;
}

.empty-state-icon {
  color: rgba(148, 163, 184, 0.5) !important;
  opacity: 0.6;
}

.empty-state-description {
  max-width: 400px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.6;
  font-size: var(--text-body, 0.9375rem);
  color: var(--text-secondary, #64748b);
}

.empty-state-action {
  min-height: 44px !important;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>

