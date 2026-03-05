import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import { VueQueryPlugin, vueQueryOptions } from './plugins/query'
import { autoAnimatePlugin } from '@formkit/auto-animate/vue'
// Import after Vuetify so HPA overrides (login auth bg, .modern-card) apply
import './style.css'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(vuetify)

// Force light theme — design system (style.css) has no dark mode support
try {
  localStorage.removeItem('bulodph-theme')
} catch {
  /* ignore */
}
vuetify.theme.change('bulodLight')
app.use(VueQueryPlugin, vueQueryOptions)
app.use(autoAnimatePlugin)

// Wait for router to finish initial navigation (and auth guard) before first paint
// so dashboard/layout render correctly on refresh
router.isReady().then(() => {
  app.mount('#app')
})
