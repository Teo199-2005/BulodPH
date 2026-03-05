<template>
  <DashboardTemplate title="Referral link" subtitle="Share and earn" :animate="true">
    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <div class="d-flex flex-column flex-sm-row align-sm-center referral-link-row">
          <div class="qr-wrap">
            <img :src="qrCodeUrl" alt="QR code" width="180" height="180" class="qr-code" />
            <p class="text-caption text-medium-emphasis mt-2 mb-0 text-center">Scan to open link</p>
          </div>
          <div class="flex-grow-1">
            <h3 class="text-subtitle-1 font-weight-bold mb-2">Your unique link</h3>
            <p class="text-body-2 text-medium-emphasis mb-2">Short link: <strong>{{ shortLink }}</strong></p>
            <div class="d-flex align-center gap-3 flex-wrap">
              <v-text-field
                :model-value="referralLink"
                readonly
                variant="outlined"
                density="comfortable"
                hide-details
                class="flex-grow-1 max-w-320"
              />
              <v-tooltip location="bottom">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" color="primary" rounded="lg" icon="mdi-content-copy" aria-label="Copy link" @click="copy(referralLink)" />
                </template>
                Copy link
              </v-tooltip>
            </div>
          </div>
        </div>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-title class="text-subtitle-1 font-weight-bold">Share</v-card-title>
      <v-card-text class="pa-4 pt-0">
        <div class="d-flex gap-2 flex-wrap">
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-facebook" aria-label="Share on Facebook" :href="facebookShareUrl" target="_blank" rel="noopener" />
            </template>
            Share on Facebook
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-whatsapp" aria-label="Share on WhatsApp" :href="whatsappShareUrl" target="_blank" rel="noopener" />
            </template>
            Share on WhatsApp
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-twitter" aria-label="Share on Twitter" :href="twitterShareUrl" target="_blank" rel="noopener" />
            </template>
            Share on Twitter
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-email" aria-label="Share via Email" :href="emailShareUrl" />
            </template>
            Share via Email
          </v-tooltip>
        </div>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-title class="text-subtitle-1 font-weight-bold">Stats (this month)</v-card-title>
      <v-list>
        <v-list-item>
          <template #prepend><v-icon>mdi-cursor-default-click</v-icon></template>
          <v-list-item-title>Clicks</v-list-item-title>
          <template #append><span class="font-weight-bold">{{ stats.clicks }}</span></template>
        </v-list-item>
        <v-list-item>
          <template #prepend><v-icon>mdi-account-plus</v-icon></template>
          <v-list-item-title>Sign-ups</v-list-item-title>
          <template #append><span class="font-weight-bold">{{ stats.signUps }}</span></template>
        </v-list-item>
      </v-list>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useCopyToClipboard } from '@/composables/useCopyToClipboard'

const { copy } = useCopyToClipboard('Link copied to clipboard.')
const referralLink = ref('https://bulodph.com/ref/ABC123')
const stats = ref({ clicks: 42, signUps: 8 })

const shortLink = computed(() => 'bulodph.com/r/ABC123')

const qrCodeUrl = computed(() => {
  const base = 'https://api.qrserver.com/v1/create-qr-code/'
  const params = new URLSearchParams({ size: '180x180', data: referralLink.value })
  return `${base}?${params.toString()}`
})

const encodedLink = computed(() => encodeURIComponent(referralLink.value))
const shareText = computed(() => `Join BulodPH – car rental marketplace. Use my link: ${referralLink.value}`)

const facebookShareUrl = computed(() => `https://www.facebook.com/sharer/sharer.php?u=${encodedLink.value}`)
const whatsappShareUrl = computed(() => `https://wa.me/?text=${encodeURIComponent(shareText.value)}`)
const twitterShareUrl = computed(() => `https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText.value)}&url=${encodedLink.value}`)
const emailShareUrl = computed(() => {
  const subject = encodeURIComponent('Join BulodPH – car rental marketplace throughout the region')
  const body = encodeURIComponent(shareText.value)
  return `mailto:?subject=${subject}&body=${body}`
})

</script>

<style scoped>
.referral-link-row {
  gap: 2rem;
}
@media (min-width: 600px) {
  .referral-link-row {
    gap: 2.5rem;
  }
}
.qr-wrap { flex-shrink: 0; }
.qr-code { display: block; border-radius: 8px; }
</style>
