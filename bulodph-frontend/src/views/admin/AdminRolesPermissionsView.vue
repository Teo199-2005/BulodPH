<template>
  <DashboardTemplate title="Roles & Permissions" subtitle="Manage access rights across the platform.">
    <v-card class="modern-card section-card-accent" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-shield-lock" size="20" /></div>
        <span class="section-card-title">Role matrix</span>
      </div>
      <v-divider class="dashboard-divider" />
      <v-table density="comfortable" class="elevation-0">
        <thead>
          <tr>
            <th>Permission</th>
            <th v-for="role in roles" :key="role" class="text-center">
              <v-chip :color="roleColor(role)" :prepend-icon="roleIcon(role)" size="small" variant="tonal">{{ role }}</v-chip>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="perm in permissions" :key="perm.key">
            <td class="text-body-2 font-weight-medium">{{ perm.label }}</td>
            <td v-for="role in roles" :key="role" class="text-center">
              <v-checkbox-btn :model-value="perm.roles.includes(role)" color="primary" density="compact" hide-details @update:model-value="togglePerm(perm, role)" />
            </td>
          </tr>
        </tbody>
      </v-table>
    </v-card>

    <v-card class="modern-card section-card-accent mt-4" elevation="0" rounded="lg">
      <div class="section-card-header">
        <div class="section-card-icon"><v-icon icon="mdi-account-group" size="20" /></div>
        <span class="section-card-title">Active users by role</span>
      </div>
      <v-divider class="dashboard-divider" />
      <v-card-text class="pa-4">
        <v-row>
          <v-col v-for="role in roles" :key="role" cols="6" sm="3">
            <div class="text-center">
              <p class="text-h5 font-weight-bold mb-0">{{ roleCounts[role] }}</p>
              <v-chip :color="roleColor(role)" :prepend-icon="roleIcon(role)" size="small" variant="tonal">{{ role }}</v-chip>
            </div>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'

const roles = ['Admin', 'Car Owner', 'Client', 'Marketing']

interface Permission { key: string; label: string; roles: string[] }

const permissions = ref<Permission[]>([
  { key: 'manage_users', label: 'Manage users', roles: ['Admin'] },
  { key: 'manage_bookings', label: 'Manage all bookings', roles: ['Admin'] },
  { key: 'own_bookings', label: 'View own bookings', roles: ['Admin', 'Car Owner', 'Client'] },
  { key: 'manage_vehicles', label: 'Manage vehicles', roles: ['Admin', 'Car Owner'] },
  { key: 'view_reports', label: 'View reports', roles: ['Admin'] },
  { key: 'manage_disputes', label: 'Handle disputes', roles: ['Admin'] },
  { key: 'submit_disputes', label: 'Submit disputes', roles: ['Car Owner', 'Client'] },
  { key: 'manage_payouts', label: 'Process payouts', roles: ['Admin'] },
  { key: 'view_earnings', label: 'View own earnings', roles: ['Car Owner', 'Marketing'] },
  { key: 'manage_promos', label: 'Manage promos', roles: ['Admin'] },
  { key: 'referrals', label: 'Manage referrals', roles: ['Marketing'] },
  { key: 'browse_vehicles', label: 'Browse & book vehicles', roles: ['Client'] },
])

const roleCounts: Record<string, number> = { Admin: 3, 'Car Owner': 12, Client: 156, Marketing: 8 }

function roleColor(role: string) {
  const map: Record<string, string> = { Admin: 'primary', 'Car Owner': 'success', Client: 'info', Marketing: 'purple' }
  return map[role] ?? 'default'
}

function roleIcon(role: string): string {
  const map: Record<string, string> = {
    Admin: 'mdi-shield-account',
    'Car Owner': 'mdi-domain',
    Client: 'mdi-account',
    Marketing: 'mdi-bullhorn',
  }
  return map[role] ?? 'mdi-account-group'
}

function togglePerm(perm: Permission, role: string) {
  if (perm.roles.includes(role)) {
    perm.roles = perm.roles.filter(r => r !== role)
  } else {
    perm.roles = [...perm.roles, role]
  }
}
</script>
