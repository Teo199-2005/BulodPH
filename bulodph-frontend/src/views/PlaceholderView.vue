<template>
  <DashboardTemplate :title="title" :subtitle="subtitle">
    <div class="placeholder-view placeholder-view--glass">
      <v-icon icon="mdi-construction" size="64" color="primary" class="placeholder-view__icon" />
      <p class="placeholder-view__text">Coming soon</p>
      <p class="placeholder-view__sub">{{ subtitle }}</p>
      <v-btn :to="backTo" variant="tonal" color="primary" rounded="lg" class="placeholder-view__btn">
        Back to dashboard
      </v-btn>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useUserSessionStore } from '@/stores/userSession'
import { toRoleColorKey } from '@/constants/roleColors'
import { DASHBOARD_PATH_BY_ROLE } from '@/constants/roleNav'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

const route = useRoute()
const userSession = useUserSessionStore()

const primaryRole = computed(() => userSession.user?.roles?.[0])
const roleKey = computed(() => toRoleColorKey(primaryRole.value))
const backTo = computed(() => DASHBOARD_PATH_BY_ROLE[roleKey.value] ?? '/client')

const title = computed(() => route.meta.title as string ?? 'Page')
const subtitle = computed(() => route.meta.subtitle as string ?? 'This section is under construction.')
</script>

<style scoped>
.placeholder-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 280px;
  padding: 2rem;
  text-align: center;
}
.placeholder-view--glass {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-radius: var(--radius-lg, 16px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 2px 12px rgba(15, 23, 42, 0.06), 0 1px 3px rgba(255, 255, 255, 0.5) inset;
}
.placeholder-view__icon {
  margin-bottom: 1rem;
  opacity: 0.8;
}
.placeholder-view__text {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  margin: 0 0 0.25rem;
}
.placeholder-view__sub {
  font-size: var(--text-body, 0.9375rem);
  color: var(--text-secondary, #64748b);
  margin: 0 0 1.5rem;
}
.placeholder-view__btn {
  text-transform: none;
  font-weight: 600;
}
</style>
