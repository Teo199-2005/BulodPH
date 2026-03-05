import { computed, watch, onMounted, type Ref } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import {
  toRoleColorKey,
  getRoleColors,
  applyRoleCssVars,
  type RoleColorKey,
  type RoleColorSet,
} from '@/constants/roleColors'

/**
 * Composable for role-based theming. Use in layout to apply CSS vars and get role key/colors.
 */
export function useRoleTheme(appShellRef?: Ref<HTMLElement | null>) {
  const userSession = useUserSessionStore()

  const primaryRole = computed(() => userSession.user?.roles?.[0])

  const roleKey = computed<RoleColorKey>(() => {
    const r = primaryRole.value
    if (!r) return 'client'
    return toRoleColorKey(r)
  })

  const roleColors = computed<RoleColorSet>(() => getRoleColors(primaryRole.value))

  function applyToElement(el: HTMLElement | null) {
    if (el) applyRoleCssVars(el, primaryRole.value)
  }

  if (appShellRef) {
    onMounted(() => applyToElement(appShellRef.value ?? null))
    watch([appShellRef, primaryRole], () => applyToElement(appShellRef.value ?? null), { immediate: true })
  }

  return {
    primaryRole,
    roleKey,
    roleColors,
    applyToElement,
  }
}
