<template>
  <footer ref="footerRef" class="app-footer" role="contentinfo">
    <div class="app-footer__disclaimer-strip">
      <span class="app-footer__disclaimer-strip-inner">{{ platformDisclaimer }}</span>
    </div>
    <div class="app-footer__line">
      <span class="app-footer__name">{{ productName }}</span>
      <span class="app-footer__version-pill">v{{ version }}</span>
      <span class="app-footer__dot" aria-hidden="true">·</span>
      <router-link to="/settings" class="app-footer__link">Settings</router-link>
      <span class="app-footer__dot" aria-hidden="true">·</span>
      <router-link to="/privacy" class="app-footer__link">Privacy</router-link>
      <span class="app-footer__dot" aria-hidden="true">·</span>
      <router-link to="/terms" class="app-footer__link">Terms</router-link>
      <span class="app-footer__dot" aria-hidden="true">·</span>
      <span class="app-footer__copy">© {{ currentYear }} {{ productName }}. Car sharing.</span>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { APP_NAME, APP_VERSION } from '@/constants/app'
import { PLATFORM_DISCLAIMER_SHORT } from '@/constants/platformAgreement'

withDefaults(
  defineProps<{
    productName?: string
    version?: string
  }>(),
  {
    productName: APP_NAME,
    version: APP_VERSION,
  }
)

const currentYear = computed(() => new Date().getFullYear())
const platformDisclaimer = PLATFORM_DISCLAIMER_SHORT

// #region agent log
const footerRef = ref<HTMLElement | null>(null)
onMounted(() => {
  requestAnimationFrame(() => {
    const el = footerRef.value ?? document.querySelector('.app-footer')
    if (!el) return
    const st = getComputedStyle(el as HTMLElement)
    const payload = {
      sessionId: '178d91',
      runId: 'footer-debug',
      hypothesisId: 'B',
      location: 'AppFooter.vue:onMounted',
      message: 'Footer element size and padding',
      data: {
        footerOffsetHeight: (el as HTMLElement).offsetHeight,
        paddingTop: st.paddingTop,
        paddingBottom: st.paddingBottom,
      },
      timestamp: Date.now(),
    }
    if (import.meta.env.DEV) {
      fetch('http://127.0.0.1:7729/ingest/4e9ac25c-fe57-41fa-a774-d34fd0bff637', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-Debug-Session-Id': '178d91' },
        body: JSON.stringify(payload),
      }).catch(() => {})
    }
  })
})
// #endregion
</script>

<style scoped>
.app-footer {
  flex-shrink: 0;
  padding: 8px 24px 10px;
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-top: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.04), 0 0 0 1px rgba(255, 255, 255, 0.3) inset;
}

.app-footer__disclaimer-strip {
  width: 100vw;
  position: relative;
  left: 50%;
  right: 50%;
  margin-left: -50vw;
  margin-right: -50vw;
  margin-bottom: 0;
  padding: 10px 24px;
  background: rgba(15, 23, 42, 0.06);
  border-top: 1px solid rgba(15, 23, 42, 0.08);
  border-bottom: 1px solid rgba(15, 23, 42, 0.06);
}

.app-footer__disclaimer-strip-inner {
  display: block;
  max-width: 1200px;
  margin: 0 auto;
  font-size: 0.75rem;
  line-height: 1.35;
  color: var(--text-muted, #94a3b8);
  text-align: center;
}

.app-footer__line {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 2px 0;
  max-width: 1200px;
  margin: 0 auto;
  font-size: 0.8125rem;
  line-height: 1.35;
}

.app-footer__name {
  font-weight: 700;
  color: var(--text-primary, #0f172a);
  letter-spacing: 0.02em;
}

.app-footer__version-pill {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  margin-left: 6px;
  font-size: 0.6875rem;
  font-weight: 600;
  color: var(--role-primary);
  background: rgba(30, 58, 95, 0.08);
  border-radius: 999px;
  font-variant-numeric: tabular-nums;
  letter-spacing: 0.03em;
}

.app-footer__link {
  font-weight: 500;
  color: var(--text-secondary, #64748b);
  text-decoration: none;
  padding: 2px 6px;
  border-radius: 6px;
  transition: color 0.2s ease, background 0.2s ease;
}

.app-footer__link:hover {
  color: var(--role-primary);
  background: rgba(30, 58, 95, 0.06);
}

.app-footer__dot {
  margin: 0 6px;
  font-size: 0.5rem;
  color: var(--text-muted, #94a3b8);
  user-select: none;
}

.app-footer__copy {
  font-size: 0.8125rem;
  color: var(--text-muted, #94a3b8);
  letter-spacing: 0.02em;
}
</style>
