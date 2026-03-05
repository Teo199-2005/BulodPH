<template>
  <DashboardTemplate title="Resources" subtitle="Logos and key messages" :animate="true">
    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-title class="text-subtitle-1 font-weight-bold">Logos</v-card-title>
      <v-card-text class="pa-4 pt-0">
        <p class="text-body-2 text-medium-emphasis mb-3">Download BulodPH logos for your posts and materials.</p>
        <div class="d-flex gap-2 flex-wrap">
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-download" aria-label="Download Logo (PNG)" />
            </template>
            Download Logo (PNG)
          </v-tooltip>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-download" aria-label="Download Logo (SVG)" />
            </template>
            Download Logo (SVG)
          </v-tooltip>
        </div>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-title class="text-subtitle-1 font-weight-bold">Key messages</v-card-title>
      <v-card-text class="pa-4 pt-0">
        <ul class="text-body-2 text-medium-emphasis pl-4 mb-0">
          <li>BulodPH – Car rental marketplace throughout the region and beyond.</li>
          <li>Rent a ride or list yours. Safe, simple, and verified.</li>
          <li>Use my link to get started and earn when you share.</li>
        </ul>
      </v-card-text>
    </v-card>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-title class="text-subtitle-1 font-weight-bold">Sample posts</v-card-title>
      <v-card-text class="pa-4 pt-0">
        <v-textarea
          model-value="Renting a car in the region? Try BulodPH – easy booking, verified owners. Use my link to sign up! #BulodPH"
          readonly
          variant="outlined"
          rows="3"
          hide-details
          class="mb-3"
        />
        <v-tooltip location="bottom">
          <template #activator="{ props: tooltipProps }">
            <v-btn v-bind="tooltipProps" variant="tonal" size="small" rounded="lg" icon="mdi-content-copy" aria-label="Copy sample post" />
          </template>
          Copy sample post
        </v-tooltip>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import DashboardTemplate from '@/components/DashboardTemplate.vue'
</script>
