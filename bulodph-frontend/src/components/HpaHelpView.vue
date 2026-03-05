<template>
  <DashboardTemplate :title="title" :subtitle="subtitle" :animate="true">
    <v-card elevation="0" rounded="lg" class="modern-card mb-4">
      <v-card-text class="pa-4">
        <h3 class="heading-section mb-3">{{ stepsTitle }}</h3>
        <ol class="text-body-2 text-medium-emphasis pl-4 mb-0">
          <li v-for="(step, i) in steps" :key="i" v-html="step" />
        </ol>
      </v-card-text>
    </v-card>

    <h3 class="heading-section mb-2">Frequently asked questions</h3>
    <v-expansion-panels variant="accordion" class="mb-4">
      <v-expansion-panel
        v-for="faq in faqItems"
        :key="faq.id"
        elevation="0"
        class="modern-card mb-2 rounded-lg"
      >
        <v-expansion-panel-title class="text-body-1 font-weight-medium">
          {{ faq.question }}
        </v-expansion-panel-title>
        <v-expansion-panel-text class="text-body-2 text-medium-emphasis">
          {{ faq.answer }}
        </v-expansion-panel-text>
      </v-expansion-panel>
    </v-expansion-panels>

    <div v-if="$slots.support" class="text-body-2 text-medium-emphasis">
      <slot name="support" />
    </div>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import type { FaqItem } from '@/constants/helpSeed'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

defineProps<{
  title: string
  subtitle: string
  stepsTitle: string
  steps: string[]
  faqItems: FaqItem[]
}>()
</script>
