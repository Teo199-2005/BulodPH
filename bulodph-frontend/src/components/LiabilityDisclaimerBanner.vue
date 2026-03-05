<template>
  <v-alert
    v-if="visible"
    type="info"
    variant="tonal"
    density="comfortable"
    rounded="lg"
    class="liability-disclaimer-banner"
    border="start"
    :icon="showIcon ? 'mdi-information-outline' : false"
    closable
    @click:close="dismiss"
  >
    <span class="liability-disclaimer-banner__text">{{ bannerText }}</span>
    <router-link v-if="showTermsLink" :to="termsRoute" class="liability-disclaimer-banner__link">
      {{ termsLinkText }}
    </router-link>
  </v-alert>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { LIABILITY_DISCLAIMER_BANNER } from '@/constants/platformAgreement'

const props = withDefaults(
  defineProps<{
    /** Optional override for banner text. */
    text?: string
    /** Show link to Terms of Service. */
    showTermsLink?: boolean
    /** Link text. */
    termsLinkText?: string
    /** Route for Terms (default /terms). */
    termsRoute?: string
    /** Show info icon. */
    showIcon?: boolean
    /** Storage key for dismissal. If set, banner can be dismissed for the session. Omit to always show. */
    dismissKey?: string
  }>(),
  {
    text: LIABILITY_DISCLAIMER_BANNER,
    showTermsLink: true,
    termsLinkText: 'See Terms of Service',
    termsRoute: '/terms',
    showIcon: true,
    dismissKey: '',
  }
)

const bannerText = props.text
const visible = ref(true)

function dismiss() {
  if (props.dismissKey) {
    try {
      sessionStorage.setItem(props.dismissKey, '1')
    } catch {
      // ignore
    }
  }
  visible.value = false
}

onMounted(() => {
  if (props.dismissKey) {
    try {
      if (sessionStorage.getItem(props.dismissKey) === '1') {
        visible.value = false
      }
    } catch {
      // ignore
    }
  }
})
</script>

<style scoped>
.liability-disclaimer-banner {
  margin-bottom: 1rem;
}

.liability-disclaimer-banner__text {
  margin-right: 0.25rem;
}

.liability-disclaimer-banner__link {
  font-weight: 600;
  color: inherit;
  text-decoration: underline;
  text-underline-offset: 2px;
}

.liability-disclaimer-banner__link:hover {
  opacity: 0.9;
}
</style>
