import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'

/**
 * BulodPH Theme Configuration — Navy Blue, Modern UI
 *
 * - action: #60a5fa (Sky blue) — main CTAs, buttons
 * - primary: #0f172a (Navy) — nav, headers, footer
 * - background: #F8FAFC, text: #1F2937
 */
export default createVuetify({
  components,
  directives,
  theme: {
    defaultTheme: 'bulodLight',
    themes: {
      bulodLight: {
        colors: {
          // Navy — nav, headers, footer
          primary: '#0f172a',
          'primary-darken-1': '#020617',
          'primary-lighten-1': '#1e3a5f',
          'primary-lighten-2': '#1e40af',

          // Sky blue / bright blue — main CTAs, active icons
          action: '#3b82f6',
          'action-darken-1': '#2563eb',
          'action-lighten-1': '#60a5fa',
          'action-lighten-2': '#93c5fd',

          secondary: '#64748B',
          'secondary-darken-1': '#475569',
          'secondary-lighten-1': '#94A3B8',

          accent: '#10B981',
          'accent-darken-1': '#059669',
          'accent-lighten-1': '#34D399',

          success: '#10B981',
          'success-darken-1': '#059669',
          'success-lighten-1': '#34D399',

          error: '#EF4444',
          'error-darken-1': '#DC2626',
          'error-lighten-1': '#F87171',

          warning: '#F59E0B',
          'warning-darken-1': '#D97706',
          'warning-lighten-1': '#FBBF24',

          info: '#1e40af',
          'info-darken-1': '#0f172a',
          'info-lighten-1': '#3b82f6',

          background: '#F8FAFC',
          surface: '#FFFFFF',
          'surface-variant': '#F1F5F9',
          'surface-bright': '#FFFFFF',
          'surface-light': '#FFFFFF',
          'surface-dark': '#0f172a',

          'on-background': '#1F2937',
          'on-surface': '#1F2937',
          'on-surface-variant': '#64748B',
          'on-primary': '#FFFFFF',
          'on-secondary': '#FFFFFF',
          'on-action': '#0f172a',

          invoiced: '#10B981',
          booked: '#60a5fa',
          pending: '#F59E0B',
          leave: '#EF4444',

          'sidebar-bg': '#0f172a',
          'sidebar-active': '#60a5fa',
          'sidebar-hover': '#1e40af',

          'border-subtle': '#E2E8F0',
          'border-default': '#CBD5E1',
          'border-focus': '#60a5fa',
        },
      },
      dark: {
        colors: {
          primary: '#132A46',
          'primary-darken-1': '#0E2038',
          'primary-lighten-1': '#1E3A5F',

          action: '#3A86FF',
          'action-darken-1': '#2F80ED',
          'action-lighten-1': '#60A5FA',

          secondary: '#9CA3AF',
          'secondary-darken-1': '#6B7280',

          accent: '#10B981',
          'accent-darken-1': '#059669',

          success: '#10B981',
          error: '#EF4444',
          warning: '#F59E0B',
          info: '#2F80ED',

          background: '#0F172A',
          surface: '#1E293B',
          'surface-variant': '#334155',
          'surface-bright': '#475569',

          'on-surface': '#F1F5F9',
          'on-surface-variant': '#CBD5E1',
          'on-primary': '#FFFFFF',
          'on-secondary': '#FFFFFF',
          'on-background': '#F1F5F9',

          invoiced: '#10B981',
          booked: '#2F80ED',
          pending: '#F59E0B',
          leave: '#EF4444',
        },
      },
    },
  },
  defaults: {
    VBtn: {
      elevation: 0,
      style: 'text-transform: none; font-weight: 600; letter-spacing: 0.025em; min-height: 40px;',
      rounded: 'lg',
    },
    VCard: {
      elevation: 0,
      rounded: 'lg',
    },
    VTextField: {
      variant: 'outlined',
      density: 'comfortable',
      color: 'action',
      rounded: 'lg',
    },
    VSelect: {
      variant: 'outlined',
      density: 'comfortable',
      color: 'action',
      rounded: 'lg',
    },
    VTextarea: {
      variant: 'outlined',
      density: 'comfortable',
      color: 'action',
      rounded: 'lg',
    },
    VAutocomplete: {
      variant: 'outlined',
      density: 'comfortable',
      color: 'action',
      rounded: 'lg',
    },
    VChip: {
      rounded: 'lg',
    },
    VDialog: {
      rounded: 'lg',
    },
    VSheet: {
      rounded: 'lg',
    },
    VProgressCircular: {
      color: 'primary',
      width: 4,
    },
    VProgressLinear: {
      color: 'primary',
      height: 3,
      rounded: true,
    },
  },
})

