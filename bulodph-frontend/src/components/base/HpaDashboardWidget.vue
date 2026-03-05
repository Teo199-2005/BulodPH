<template>
  <v-card
    :loading="loading"
    elevation="0"
    class="hpa-stats-card modern-card"
    :class="{ 'hpa-stats-card--role': role }"
    :style="cardRoleStyle"
    rounded="lg"
    @click="$emit('click')"
  >
    <v-card-text class="stats-card-body">
      <div class="stats-card-label">{{ title }}</div>
      <div class="stats-card-row">
        <span class="stats-card-value">
          <AnimatedNumber
            :value="numericValue"
            :prefix="prefix"
            :suffix="suffix"
            :decimals="decimals"
          />
        </span>
        <div class="stats-card-icon" :style="{ background: iconBg }">
          <v-icon :icon="icon" size="22" color="white" />
        </div>
      </div>
      <div v-if="showTrendRow" class="stats-card-trend">
        <v-icon :icon="trendIcon" size="14" :color="trendIconColor" class="stats-card-trend-icon" />
        <span class="stats-card-trend-value">{{ trendValue }}</span>
        <span class="stats-card-trend-label">{{ trendLabel }}</span>
      </div>
    </v-card-text>
  </v-card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AnimatedNumber from './AnimatedNumber.vue'
import { getRoleColors } from '@/constants/roleColors'

interface Props {
  title: string
  value: number | string
  icon: string
  color?: string
  iconColor?: string
  /** When set, card and icon use role colors (client/car_owner/marketing_staff/admin) */
  role?: string
  trend?: 'up' | 'down' | 'neutral'
  trendValue?: string
  trendLabel?: string
  loading?: boolean
  prefix?: string
  suffix?: string
  decimals?: number
}

const props = withDefaults(defineProps<Props>(), {
  color: 'primary',
  loading: false,
  trendLabel: 'vs last period',
  prefix: '',
  suffix: '',
  decimals: 0,
})

defineEmits<{
  'click': []
}>()

const numericValue = computed(() => {
  if (typeof props.value === 'number') return props.value
  return parseFloat(props.value.replace(/[^0-9.-]/g, '')) || 0
})

/** Only show the trend row when there is meaningful content (not just placeholder "—" with no label) */
const showTrendRow = computed(() => {
  if (!props.trend) return false
  const dashOnly = !props.trendValue || props.trendValue.trim() === '' || props.trendValue === '—' || props.trendValue === '--'
  const hasLabel = props.trendLabel != null && String(props.trendLabel).trim() !== ''
  return !dashOnly || hasLabel
})

const trendIcon = computed(() => {
  if (props.trend === 'up') return 'mdi-trending-up'
  if (props.trend === 'down') return 'mdi-trending-down'
  return 'mdi-minus'
})

const roleColors = computed(() => (props.role ? getRoleColors(props.role) : null))

const iconBg = computed(() => {
  if (roleColors.value) return roleColors.value.gradient
  const c = props.iconColor || props.color
  if (c === 'primary') return 'linear-gradient(135deg, #1e3a5f 0%, #334155 100%)'
  return '#1e3a5f'
})

const cardRoleStyle = computed(() => {
  const r = roleColors.value
  if (!r) return undefined
  return {
    '--stats-role-primary': r.primary,
    '--stats-role-border': r.border,
    '--stats-role-border-hover': r.borderHover,
  } as Record<string, string>
})

const trendIconColor = computed(() => {
  if (props.trend === 'up') return '#059669'
  if (props.trend === 'down') return '#dc2626'
  return '#64748b'
})
</script>

<style scoped>
.hpa-stats-card {
  cursor: pointer;
  position: relative;
  overflow: visible;
  min-height: 148px;
  border: 1px solid rgba(30, 58, 95, 0.12) !important;
  box-shadow: var(--shadow-widget, 0 2px 12px rgba(0, 0, 0, 0.06)) !important;
  transition: transform 0.25s ease, box-shadow 0.3s ease, border-color 0.25s ease, background 0.25s ease;
  animation: fadeInUp 0.4s ease-out;
}

.hpa-stats-card:hover {
  border-color: rgba(148, 163, 184, 0.5) !important;
  box-shadow: 0 8px 24px rgba(30, 58, 95, 0.12), 0 2px 8px rgba(0, 0, 0, 0.06), 0 2px 6px rgba(255, 255, 255, 0.5) inset !important;
  transform: translateY(-3px);
}

.hpa-stats-card--role {
  border-color: var(--stats-role-border, rgba(30, 58, 95, 0.25)) !important;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04) !important;
}
.hpa-stats-card--role:hover {
  border-color: var(--stats-role-border-hover, rgba(30, 58, 95, 0.35)) !important;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1), 0 2px 8px rgba(0, 0, 0, 0.06) !important;
}
.hpa-stats-card--role .stats-card-trend {
  border-top-color: var(--stats-role-border, rgba(30, 58, 95, 0.08));
}

.stats-card-body {
  padding: 1.375rem 1.5rem !important;
  min-width: 0;
  overflow: visible;
  box-sizing: border-box;
}

.stats-card-label {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-secondary, #64748b);
  letter-spacing: 0.025em;
  text-transform: uppercase;
  margin-bottom: 0.625rem;
  display: block;
  line-height: 1.3;
  word-wrap: break-word;
  overflow-wrap: break-word;
  hyphens: auto;
}

.stats-card-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 0.75rem;
  min-width: 0;
}

.stats-card-value {
  font-size: 1.875rem;
  font-weight: 800;
  font-variant-numeric: tabular-nums;
  color: var(--text-primary, #0f172a);
  line-height: 1.1;
  letter-spacing: -0.04em;
  -webkit-font-smoothing: antialiased;
  min-width: 0;
}

.stats-card-icon {
  width: 52px;
  height: 52px;
  border-radius: var(--radius-lg, 16px);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(30, 58, 95, 0.2), 0 2px 4px rgba(255, 255, 255, 0.4) inset;
  border: 1px solid rgba(255, 255, 255, 0.35);
  position: relative;
  overflow: hidden;
  transition: transform 0.25s ease, box-shadow 0.3s ease;
}
.stats-card-icon::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(125deg, transparent 0%, rgba(255,255,255,0.35) 40%, transparent 60%);
  opacity: 0;
  transition: opacity 0.3s ease;
}
.hpa-stats-card:hover .stats-card-icon {
  box-shadow: 0 6px 16px rgba(30, 58, 95, 0.3), 0 2px 6px rgba(255, 255, 255, 0.5) inset;
  transform: scale(1.08);
}
.hpa-stats-card:hover .stats-card-icon::after {
  opacity: 1;
  animation: statsIconShine 0.7s ease-in-out;
}
@keyframes statsIconShine {
  0% { transform: translateX(-100%) skewX(-10deg); opacity: 0; }
  50% { opacity: 0.8; }
  100% { transform: translateX(100%) skewX(-10deg); opacity: 0; }
}

.stats-card-trend {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.75rem;
  margin-top: 2px;
  padding-top: 0.5rem;
  border-top: 1px solid rgba(30, 58, 95, 0.08);
  min-width: 0;
}

.stats-card-trend-icon {
  flex-shrink: 0;
}

.stats-card-trend-value {
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  color: var(--text-primary, #0f172a);
  letter-spacing: 0.02em;
  flex-shrink: 0;
}

.stats-card-trend-label {
  color: var(--text-secondary, #64748b);
  font-weight: 500;
  letter-spacing: 0.01em;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Mobile: prevent clipping, allow label to wrap, tighter padding */
@media (max-width: 599px) {
  .hpa-stats-card {
    min-height: 132px;
  }

  .stats-card-body {
    padding: 1rem 1rem !important;
  }

  .stats-card-label {
    font-size: 0.6875rem;
    letter-spacing: 0.02em;
    margin-bottom: 0.5rem;
    line-height: 1.25;
    max-height: 2.5em;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  .stats-card-row {
    gap: 10px;
    margin-bottom: 0.5rem;
  }

  .stats-card-value {
    font-size: 1.5rem;
    min-width: 0;
  }

  .stats-card-icon {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    flex-shrink: 0;
  }

  .stats-card-icon :deep(.v-icon) {
    font-size: 20px !important;
  }

  .stats-card-trend {
    font-size: 0.6875rem;
    gap: 4px;
    padding-top: 0.375rem;
  }

  .stats-card-trend-value,
  .stats-card-trend-label {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    max-width: 100%;
  }
}
</style>
