<template>
  <DashboardTemplate title="Rewards" subtitle="Points and tier benefits." :animate="true">
    <!-- Stats row -->
    <div class="rewards-stats mb-5">
      <v-card elevation="0" rounded="lg" class="rewards-stat-card modern-card">
        <v-card-text class="pa-4">
          <div class="rewards-stat-card__icon rewards-stat-card__icon--points">
            <v-icon icon="mdi-star-circle" size="28" />
          </div>
          <p class="rewards-stat-card__value mb-0">{{ points }}</p>
          <p class="rewards-stat-card__label">Total points</p>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="rewards-stat-card modern-card rewards-stat-card--tier">
        <v-card-text class="pa-4">
          <div class="rewards-stat-card__icon" :style="{ background: tierBg, color: currentTier.color }">
            <v-icon :icon="currentTier.icon" size="26" />
          </div>
          <p class="rewards-stat-card__value rewards-stat-card__value--tier mb-1" :style="{ color: currentTier.color }">{{ currentTier.name }}</p>
          <p class="rewards-stat-card__label">Current tier</p>
          <v-progress-linear
            :model-value="tierProgress"
            :color="currentTier.color"
            height="8"
            rounded
            class="rewards-tier-progress mt-2"
          />
          <p class="text-caption text-medium-emphasis mt-1 mb-0">{{ points }} / {{ currentTier.nextAt }} pts to {{ currentTier.nextName }}</p>
        </v-card-text>
      </v-card>
      <v-card elevation="0" rounded="lg" class="rewards-stat-card modern-card">
        <v-card-text class="pa-4">
          <div class="rewards-stat-card__icon rewards-stat-card__icon--gift">
            <v-icon icon="mdi-gift" size="28" />
          </div>
          <p class="rewards-stat-card__value mb-0">{{ availableRewards }}</p>
          <p class="rewards-stat-card__label">Rewards available</p>
        </v-card-text>
      </v-card>
    </div>

    <div class="rewards-content">
      <!-- How to earn -->
      <v-card elevation="0" rounded="lg" class="rewards-section modern-card">
        <div class="rewards-section__accent" />
        <div class="rewards-section__header">
          <div class="rewards-section__icon">
            <v-icon icon="mdi-trending-up" size="22" />
          </div>
          <span class="rewards-section__title">How to earn</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4 pt-3">
          <div class="earn-list">
            <div v-for="way in earnWays" :key="way.label" class="earn-item">
              <v-icon :icon="way.icon" size="20" class="earn-item__icon" />
              <span class="earn-item__label">{{ way.label }}</span>
              <v-chip size="small" color="amber-darken-2" variant="tonal" class="earn-item__pts" density="compact">
                +{{ way.pts }} pts
              </v-chip>
            </div>
          </div>
        </v-card-text>
      </v-card>

      <!-- Rewards catalog -->
      <v-card elevation="0" rounded="lg" class="rewards-section modern-card">
        <div class="rewards-section__accent rewards-section__accent--catalog" />
        <div class="rewards-section__header">
          <div class="rewards-section__icon rewards-section__icon--catalog">
            <v-icon icon="mdi-gift-outline" size="22" />
          </div>
          <span class="rewards-section__title">Rewards catalog</span>
        </div>
        <v-divider class="mx-4" />
        <v-card-text class="pa-4 pt-3">
          <div class="catalog-list">
            <div
              v-for="reward in rewards"
              :key="reward.label"
              class="catalog-item"
              :class="{ 'catalog-item--locked': !reward.available }"
            >
              <div class="catalog-item__icon-wrap">
                <v-icon :icon="reward.icon" size="22" :color="reward.available ? 'success' : undefined" />
              </div>
              <div class="catalog-item__main">
                <span class="catalog-item__label">{{ reward.label }}</span>
                <span class="catalog-item__cost">{{ reward.cost }} pts</span>
              </div>
              <div class="catalog-item__action">
                <v-btn v-if="reward.available" size="small" color="primary" variant="tonal" rounded="lg" density="compact">
                  Redeem
                </v-btn>
                <v-chip v-else size="small" variant="outlined" density="compact" class="catalog-item__locked-chip">
                  Locked
                </v-chip>
              </div>
            </div>
          </div>
        </v-card-text>
      </v-card>
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

const points = 320

const tiers = [
  { name: 'Bronze', icon: 'mdi-medal', color: '#CD7F32', minPts: 0, nextAt: 500, nextName: 'Silver' },
  { name: 'Silver', icon: 'mdi-medal', color: '#9E9E9E', minPts: 500, nextAt: 1500, nextName: 'Gold' },
  { name: 'Gold', icon: 'mdi-trophy', color: '#FFC107', minPts: 1500, nextAt: 5000, nextName: 'Platinum' },
  { name: 'Platinum', icon: 'mdi-crown', color: '#7C4DFF', minPts: 5000, nextAt: 10000, nextName: 'Diamond' },
]

const currentTier = computed(() => {
  for (let i = tiers.length - 1; i >= 0; i--) {
    if (points >= tiers[i].minPts) return tiers[i]
  }
  return tiers[0]
})

const tierBg = computed(() => {
  const c = currentTier.value.color
  return `${c}22`
})

const tierProgress = computed(() => {
  const t = currentTier.value
  return Math.min(100, Math.round(((points - t.minPts) / (t.nextAt - t.minPts)) * 100))
})

const earnWays = [
  { label: 'Complete a booking', pts: 50, icon: 'mdi-car-clock' },
  { label: 'Leave a review', pts: 10, icon: 'mdi-star-outline' },
  { label: 'Refer a friend', pts: 100, icon: 'mdi-account-plus' },
  { label: 'Upload ID verification', pts: 25, icon: 'mdi-shield-check' },
  { label: 'Complete profile', pts: 15, icon: 'mdi-account-check' },
]

const rewards = [
  { label: '₱50 off your next booking', cost: 200, icon: 'mdi-ticket-percent', available: points >= 200 },
  { label: 'Free insurance upgrade', cost: 500, icon: 'mdi-shield-car', available: points >= 500 },
  { label: '₱200 cashback', cost: 1000, icon: 'mdi-cash-refund', available: points >= 1000 },
  { label: 'Priority booking access', cost: 1500, icon: 'mdi-lightning-bolt', available: points >= 1500 },
  { label: 'VIP support', cost: 3000, icon: 'mdi-headset', available: points >= 3000 },
]

const availableRewards = computed(() => rewards.filter((r) => r.available).length)
</script>

<style scoped>
.rewards-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 1rem;
}

.rewards-stat-card {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  transition: box-shadow 0.2s ease;
}

.rewards-stat-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
}

.rewards-stat-card__icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 0.75rem;
}

.rewards-stat-card__icon--points {
  background: rgba(255, 193, 7, 0.2);
  color: rgb(184, 134, 11);
}

.rewards-stat-card__icon--gift {
  background: rgba(var(--v-theme-primary), 0.12);
  color: rgb(var(--v-theme-primary));
}

.rewards-stat-card__value {
  font-size: 1.75rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
  line-height: 1.2;
}

.rewards-stat-card__value--tier {
  font-size: 1.25rem;
}

.rewards-stat-card__label {
  font-size: 0.8125rem;
  color: rgba(var(--v-theme-on-surface), 0.7);
  margin: 0;
}

.rewards-tier-progress {
  border-radius: 4px;
}

.rewards-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 1.25rem;
}

.rewards-section {
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.rewards-section__accent {
  position: absolute;
  top: 0;
  left: 0;
  width: 4px;
  height: 100%;
  background: rgb(var(--v-theme-primary));
  border-radius: 4px 0 0 4px;
}

.rewards-section__accent--catalog {
  background: linear-gradient(to bottom, rgb(var(--v-theme-primary)), rgba(var(--v-theme-primary), 0.5));
}

.rewards-section__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1rem 0.5rem;
}

.rewards-section__icon {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-primary), 0.1);
  color: rgb(var(--v-theme-primary));
  display: flex;
  align-items: center;
  justify-content: center;
}

.rewards-section__icon--catalog {
  background: rgba(76, 175, 80, 0.12);
  color: rgb(76, 175, 80);
}

.rewards-section__title {
  font-size: 1rem;
  font-weight: 700;
  color: rgb(var(--v-theme-on-surface));
}

.earn-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.earn-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0.75rem;
  border-radius: 10px;
  background: rgba(0, 0, 0, 0.02);
}

.earn-item__icon {
  color: rgb(var(--v-theme-primary));
  flex-shrink: 0;
}

.earn-item__label {
  flex: 1;
  font-size: 0.875rem;
  font-weight: 500;
  color: rgb(var(--v-theme-on-surface));
}

.earn-item__pts {
  flex-shrink: 0;
  font-weight: 600;
}

.catalog-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.catalog-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.625rem 0.75rem;
  border-radius: 10px;
  border: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
  background: rgba(0, 0, 0, 0.02);
  transition: background 0.2s ease, border-color 0.2s ease;
}

.catalog-item:hover {
  background: rgba(0, 0, 0, 0.03);
}

.catalog-item--locked {
  opacity: 0.85;
}

.catalog-item__icon-wrap {
  width: 40px;
  height: 40px;
  border-radius: 10px;
  background: rgba(var(--v-theme-on-surface), 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.catalog-item--locked .catalog-item__icon-wrap {
  background: rgba(var(--v-theme-on-surface), 0.04);
}

.catalog-item__main {
  flex: 1;
  min-width: 0;
}

.catalog-item__label {
  display: block;
  font-size: 0.875rem;
  font-weight: 600;
  color: rgb(var(--v-theme-on-surface));
}

.catalog-item__cost {
  display: block;
  font-size: 0.75rem;
  color: rgba(var(--v-theme-on-surface), 0.65);
  margin-top: 2px;
}

.catalog-item__action {
  flex-shrink: 0;
}

.catalog-item__locked-chip {
  font-size: 0.6875rem;
}
</style>
