<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div>
        <h1 class="page-title mb-1">Car rental owners</h1>
        <p class="page-subtitle">Rental companies who list cars on BulodPH</p>
      </div>
      <v-btn color="primary" size="default" prepend-icon="mdi-plus" rounded="lg" @click="openAddDialog">
        Add car rental company
      </v-btn>
    </template>

    <v-row class="mb-6">
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="car_owner"
          :loading="false"
          title="Total rentals"
          :value="owners.length"
          icon="mdi-car-side"
          trend="neutral"
          trend-value="—"
          trend-label="total"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="car_owner"
          :loading="false"
          title="Active"
          :value="activeCount"
          icon="mdi-check-circle"
          trend="up"
          trend-value="active"
          trend-label="companies"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="car_owner"
          :loading="false"
          title="With listings"
          :value="withListingsCount"
          icon="mdi-car-multiple"
          trend="neutral"
          :trend-value="String(withListingsCount)"
          trend-label="listings"
        />
      </v-col>
      <v-col cols="6" sm="6" md="3">
        <HpaDashboardWidget
          role="car_owner"
          :loading="false"
          title="Pending"
          :value="pendingCount"
          icon="mdi-clock-alert"
          trend="neutral"
          :trend-value="String(pendingCount)"
          trend-label="pending"
        />
      </v-col>
    </v-row>

    <!-- Recent listings & By location -->
    <v-row class="mb-6">
      <v-col cols="12" lg="8">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-car-multiple" size="20" />
            </div>
            <span class="section-card-title">Recent listings</span>
            <v-spacer />
            <v-btn variant="text" color="primary" size="small" :to="{ name: 'admin-listings' }">View all</v-btn>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-row>
              <v-col v-for="v in recentListings" :key="v.id" cols="6" md="3">
                <router-link :to="{ name: 'admin-listings' }" class="recent-listing-card">
                  <v-img :src="v.image" height="80" cover rounded="lg" class="mb-2" />
                  <div class="text-body-2 font-weight-medium text-truncate">{{ v.name }}</div>
                  <div class="text-caption text-medium-emphasis">{{ v.location }} · {{ formatPrice(v.pricePerDay, { suffix: '/day' }) }}</div>
                </router-link>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" lg="4">
        <v-card elevation="0" rounded="lg" class="modern-card h-100">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-map-marker" size="20" />
            </div>
            <span class="section-card-title">Rentals by location</span>
          </div>
          <v-divider class="settings-divider" />
          <v-card-text class="pa-4">
            <v-list density="compact" class="pa-0">
              <v-list-item v-for="loc in ownersByLocation" :key="loc.label" class="px-0">
                <v-list-item-title class="text-body-2">{{ loc.label }}</v-list-item-title>
                <template #append>
                  <span class="text-body-2 font-weight-medium">{{ loc.count }}</span>
                </template>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <HpaDataTable
      title="Car rental owners"
      icon="mdi-car-side"
      :headers="headers"
      :items="ownersWithListingsFromVehicles"
      :loading="loading"
      searchable
      exportable
      selectable
    >
      <template #item.full_name="{ item }">
        <div class="d-flex align-center py-2">
          <v-avatar size="44" rounded="lg" class="mr-3 car-rental-owner-logo">
            <v-img v-if="item.logo_url" :src="resolveImageUrl(item.logo_url) ?? item.logo_url" cover />
            <v-img v-else-if="item.avatar_url" :src="resolveImageUrl(item.avatar_url) ?? item.avatar_url" cover />
            <v-img v-else :src="getAvatarUrl(item.business_name ?? item.full_name)" cover />
          </v-avatar>
          <div>
            <div class="font-weight-medium">{{ item.business_name ?? item.full_name }}</div>
            <div class="d-flex align-center flex-wrap gap-1">
              <span class="text-caption text-medium-emphasis">{{ item.full_name }} · {{ item.email }}</span>
              <EmailVerifiedBadge :verified="!!(item as { email_verified?: boolean }).email_verified" />
            </div>
          </div>
        </div>
      </template>
      <template #item.account_status="{ item }">
        <div class="d-flex flex-wrap gap-3 table-status-chips">
          <v-chip
            :color="(item.account_status === 'Approved' ? 'success' : 'warning')"
            :prepend-icon="item.account_status === 'Approved' ? 'mdi-check-circle' : 'mdi-clock-outline'"
            size="small"
            variant="tonal"
            class="table-status-chip"
          >
            {{ item.account_status }}
          </v-chip>
          <v-chip
            :color="item.verified ? 'success' : 'grey'"
            :prepend-icon="item.verified ? 'mdi-shield-check' : 'mdi-shield-off-outline'"
            size="small"
            variant="tonal"
            class="table-status-chip"
          >
            {{ item.verified ? 'Verified' : 'Unverified' }}
          </v-chip>
          <v-chip
            :color="item.has_permit ? 'info' : 'grey'"
            :prepend-icon="item.has_permit ? 'mdi-file-document-check' : 'mdi-file-document-remove-outline'"
            size="small"
            variant="tonal"
            class="table-status-chip"
          >
            {{ item.has_permit ? 'Has Permit' : 'No Permit' }}
          </v-chip>
        </div>
      </template>
      <template #item.status="{ item }">
        <v-chip :color="getStatusColor(item.status)" :prepend-icon="getStatusIcon(item.status)" size="small" variant="tonal" class="table-status-chip">
          {{ item.status }}
        </v-chip>
      </template>
      <template #item.location="{ item }">
        <div class="d-flex align-center">
          <v-icon icon="mdi-map-marker" size="16" class="mr-1 text-medium-emphasis" />
          <span>{{ item.city }}, {{ item.province }}</span>
        </div>
      </template>
      <template #item.actions="{ item }">
        <div class="d-flex align-center gap-3 table-action-buttons">
          <v-tooltip location="top" text="View details">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon
                variant="text"
                size="small"
                color="action"
                class="table-action-btn"
                @click="viewOwner(item)"
              >
                <v-icon size="20">mdi-eye</v-icon>
              </v-btn>
            </template>
          </v-tooltip>
          <v-tooltip location="top" text="Edit">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon
                variant="text"
                size="small"
                color="primary"
                class="table-action-btn"
                @click="openEditDialog(item)"
              >
                <v-icon size="20">mdi-pencil</v-icon>
              </v-btn>
            </template>
          </v-tooltip>
          <v-tooltip location="top" text="Delete">
            <template #activator="{ props: tooltipProps }">
              <v-btn
                v-bind="tooltipProps"
                icon
                variant="text"
                size="small"
                color="error"
                class="table-action-btn"
                @click="openDeleteConfirm(item)"
              >
                <v-icon size="20">mdi-delete-outline</v-icon>
              </v-btn>
            </template>
          </v-tooltip>
        </div>
      </template>
      <template #bulk-actions="{ selected }">
        <v-btn variant="text" color="primary" prepend-icon="mdi-email" @click="sendBulkEmail(selected)">Send email</v-btn>
        <v-btn variant="text" color="action" prepend-icon="mdi-file-export" @click="exportSelected(selected)">Export</v-btn>
      </template>
    </HpaDataTable>

    <HpaModal
      v-model="showFormDialog"
      :title="editingId ? 'Edit car rental company' : 'Add car rental company'"
      :icon="editingId ? 'mdi-pencil' : 'mdi-account-plus'"
      max-width="600"
      @confirm="handleSave"
    >
      <v-form ref="formRef">
        <v-row>
          <v-col cols="12">
            <v-text-field :model-value="form.business_name" @update:model-value="(v) => form.business_name = formatInput(v, 'address')" label="Rental company name" prepend-inner-icon="mdi-storefront" placeholder="e.g. Juan's Car Rental" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.first_name" @update:model-value="(v) => form.first_name = formatInput(v, 'letters')" label="Contact first name" prepend-inner-icon="mdi-account" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.last_name" @update:model-value="(v) => form.last_name = formatInput(v, 'letters')" label="Contact last name" prepend-inner-icon="mdi-account" />
          </v-col>
          <v-col cols="12">
            <v-text-field v-model="form.logo_url" label="Logo URL (optional)" prepend-inner-icon="mdi-image" placeholder="https://..." hide-details />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field v-model="form.email" label="Email" type="email" prepend-inner-icon="mdi-email" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.phone" @update:model-value="(v) => form.phone = formatInput(v, 'phone')" label="Phone" prepend-inner-icon="mdi-phone" placeholder="09xx xxx xxxx" />
          </v-col>
          <v-col cols="12">
            <v-text-field :model-value="form.address" @update:model-value="(v) => form.address = formatInput(v, 'address')" label="Address" prepend-inner-icon="mdi-map-marker" />
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field :model-value="form.city" @update:model-value="(v) => form.city = formatInput(v, 'letters')" label="City / Municipality" prepend-inner-icon="mdi-city" />
          </v-col>
          <v-col cols="12" md="6">
            <v-select
              v-model="form.province"
              :items="phProvinces"
              label="Province"
              prepend-inner-icon="mdi-map"
            />
          </v-col>
          <v-col cols="12" md="6">
            <v-select v-model="form.status" :items="statusOptions" label="Status" />
          </v-col>
          <v-col cols="12" md="6">
            <v-select v-model="form.account_status" :items="accountStatusOptions" label="Account status" />
          </v-col>
          <v-col cols="12" md="6">
            <v-checkbox v-model="form.verified" label="Verified" hide-details density="compact" />
          </v-col>
          <v-col cols="12" md="6">
            <v-checkbox v-model="form.has_permit" label="Has permit" hide-details density="compact" />
          </v-col>
          <v-col cols="12">
            <v-textarea v-model="form.notes" label="Notes" rows="2" prepend-inner-icon="mdi-note-text" />
          </v-col>
        </v-row>
      </v-form>
    </HpaModal>

    <HpaConfirmModal
      v-model="showDeleteConfirm"
      title="Delete car rental company?"
      :message="deleteMessage"
      confirm-text="Delete"
      cancel-text="Cancel"
      variant="danger"
      @confirm="handleDeleteConfirm"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import HpaDataTable from '@/components/base/HpaDataTable.vue'
import HpaDashboardWidget from '@/components/base/HpaDashboardWidget.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { getAvatarUrl, resolveImageUrl } from '@/constants/images'
import { createCarOwner, deleteCarOwner, getCarOwners, updateCarOwner } from '@/services/carOwners'
import * as carRentalApi from '@/services/carRentalProfile'
import { useVehicles } from '@/composables/useVehicles'
import { CAR_OWNERS_SEED } from '@/constants/carOwnersSeed'
import type { CarRentalProfile } from '@/types/carRentalProfile'
import { hasInjectionRisk, isSafeText, sanitizeBasicText } from '@/utils/inputValidation'
import { formatInput } from '@/utils/inputFormatters'
import { getUserScopedItem, setUserScopedItem } from '@/utils/userScopedStorage'
import EmailVerifiedBadge from '@/components/shared/EmailVerifiedBadge.vue'

const CAR_OWNERS_STORAGE_KEY = 'bulodph_admin_car_owners'
const router = useRouter()
const toast = useToastStore()
const { vehicles: vehiclesList } = useVehicles()
const loading = ref(false)
const showFormDialog = ref(false)
const showDeleteConfirm = ref(false)
const editingId = ref<number | null>(null)
const ownerToDelete = ref<{ id: number; full_name: string } | null>(null)
const formRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)

const phProvinces = ['Isabela', 'Cagayan', 'Nueva Vizcaya', 'Quirino', 'Bataan', 'Bulacan', 'Pampanga', 'Tarlac', 'Nueva Ecija', 'Zambales', 'Metro Manila', 'Other']
const statusOptions = ['Active', 'Pending', 'Suspended', 'Inactive']
const accountStatusOptions = ['Approved', 'Pending']

const form = ref({
  business_name: '',
  logo_url: '',
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  province: 'Isabela',
  status: 'Active',
  account_status: 'Approved' as 'Approved' | 'Pending',
  verified: true,
  has_permit: false,
  notes: '',
})

const headers = [
  { title: 'Name', key: 'full_name', sortable: true },
  { title: 'Phone', key: 'phone', sortable: true },
  { title: 'Location', key: 'location', sortable: false },
  { title: 'Listings', key: 'listings_count', sortable: true },
  { title: 'Account Status', key: 'account_status', sortable: false },
  { title: 'Status', key: 'status', sortable: true },
  { title: 'Actions', key: 'actions', sortable: false },
]

const owners = ref<any[]>([])

function mapApiOwner(item: any) {
  return {
    id: typeof item.id === 'string' ? item.id : Number(item.id),
    full_name: String(item.full_name ?? item.name ?? 'Unnamed'),
    business_name: item.business_name ?? undefined,
    logo_url: item.logo_url ?? undefined,
    email: String(item.email ?? ''),
    phone: String(item.phone ?? ''),
    city: String(item.city ?? ''),
    province: String(item.province ?? ''),
    address: item.address ?? '',
    status: item.status ?? 'Active',
    account_status: item.account_status ?? 'Approved',
    verified: Boolean(item.verified),
    has_permit: Boolean(item.has_permit),
    listings_count: Number(item.listings_count ?? 0),
    notes: item.notes ?? '',
  }
}

function mapCarRentalProfileToOwner(profile: CarRentalProfile) {
  const name = (profile.businessName ?? 'Rental').trim() || 'Unnamed'
  return {
    id: profile.id,
    full_name: name,
    business_name: name,
    logo_url: profile.logoUrl ?? undefined,
    avatar_url: profile.logoUrl ?? undefined,
    email: String(profile.email ?? ''),
    phone: String(profile.phone ?? ''),
    city: String(profile.city ?? ''),
    province: String(profile.province ?? ''),
    address: String(profile.address ?? ''),
    status: 'Active',
    account_status: 'Approved',
    verified: true,
    has_permit: Boolean(profile.businessPermitNumber),
    listings_count: Number(profile.vehicleCount ?? 0),
    notes: '',
    _fromCarRentalsApi: true,
  }
}

function ownerKey(o: { email?: string; business_name?: string; full_name?: string }) {
  const e = (o.email ?? '').trim().toLowerCase()
  const b = (o.business_name ?? o.full_name ?? '').trim().toLowerCase()
  return e || b || String(o)
}

async function loadOwners() {
  loading.value = true
  const data = await getCarOwners()
  if (data?.length) {
    owners.value = data.map(mapApiOwner)
    setUserScopedItem(CAR_OWNERS_STORAGE_KEY, owners.value)
  } else {
    const stored = getUserScopedItem<any[]>(CAR_OWNERS_STORAGE_KEY)
    owners.value = Array.isArray(stored) && stored.length ? stored : JSON.parse(JSON.stringify(CAR_OWNERS_SEED))
  }
  const profiles = await carRentalApi.getCarRentals()
  if (profiles?.length) {
    const existingKeys = new Set(owners.value.map(ownerKey))
    const toAdd = profiles
      .map((p) => mapCarRentalProfileToOwner(p))
      .filter((o) => !existingKeys.has(ownerKey(o)))
    toAdd.forEach((o) => {
      existingKeys.add(ownerKey(o))
      owners.value.push(o)
    })
  }
  loading.value = false
}

onMounted(() => {
  loadOwners()
})

const recentListings = computed(() => {
  const list = vehiclesList.value
  const recent = list.length <= 4 ? list : list.slice(-4).reverse()
  return recent.map(v => ({
    id: v.id,
    name: v.name,
    location: v.location,
    pricePerDay: v.pricePerDay,
    image: v.image || 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop',
  }))
})
const ownersByLocation = computed(() => {
  const map = new Map<string, number>()
  owners.value.forEach(o => {
    const key = `${o.city}, ${o.province}`
    map.set(key, (map.get(key) ?? 0) + 1)
  })
  return Array.from(map.entries()).map(([label, count]) => ({ label, count })).sort((a, b) => b.count - a.count)
})

/** Derive listing count from actual vehicles so car-owner-added vehicles show (e.g. Demo Car Owner). */
const ownersWithListingsFromVehicles = computed(() => {
  const byRental = new Map<string, number>()
  for (const v of vehiclesList.value) {
    const name = (v.businessName ?? v.hostName ?? '').trim()
    if (!name) continue
    const key = name.toLowerCase()
    byRental.set(key, (byRental.get(key) ?? 0) + 1)
  }
  function countForOwner(o: { business_name?: string; full_name?: string }) {
    const name = (o.business_name ?? o.full_name ?? '').trim().toLowerCase()
    if (!name) return 0
    let count = byRental.get(name) ?? 0
    if (count === 0) {
      for (const [rentalName, c] of byRental) {
        if (rentalName.includes(name) || name.includes(rentalName)) return c
      }
    }
    return count
  }
  return owners.value.map(o => ({
    ...o,
    listings_count: countForOwner(o) || o.listings_count,
  }))
})

const activeCount = computed(() => ownersWithListingsFromVehicles.value.filter(o => o.status === 'Active').length)
const withListingsCount = computed(() => ownersWithListingsFromVehicles.value.filter(o => o.listings_count > 0).length)
const pendingCount = computed(() => owners.value.filter(o => o.status === 'Pending').length)
const deleteMessage = computed(() =>
  ownerToDelete.value ? `Remove "${(ownerToDelete.value as { business_name?: string }).business_name ?? ownerToDelete.value.full_name}"? This cannot be undone.` : ''
)

function getStatusColor(status: string) {
  const map: Record<string, string> = { Active: 'success', Pending: 'warning', Suspended: 'error', Inactive: 'grey' }
  return map[status] || 'grey'
}

function getStatusIcon(status: string) {
  const map: Record<string, string> = {
    Active: 'mdi-check-circle',
    Pending: 'mdi-clock-outline',
    Suspended: 'mdi-pause-circle',
    Inactive: 'mdi-close-circle',
  }
  return map[status] || 'mdi-circle-outline'
}

function openAddDialog() {
  editingId.value = null
  form.value = { business_name: '', logo_url: '', first_name: '', last_name: '', email: '', phone: '', address: '', city: '', province: 'Isabela', status: 'Active', account_status: 'Approved', verified: false, has_permit: false, notes: '' }
  showFormDialog.value = true
}

function viewOwner(item: (typeof owners.value)[0]) {
  router.push({
    name: 'car-owner-details',
    params: { id: String(item.id) },
    state: { owner: item },
  })
}

function openEditDialog(item: (typeof owners.value)[0]) {
  editingId.value = item.id
  const [first = '', ...rest] = item.full_name.split(' ')
  form.value = {
    business_name: item.business_name ?? '',
    logo_url: item.logo_url ?? '',
    first_name: first,
    last_name: rest.join(' ') || '',
    email: item.email,
    phone: item.phone,
    address: item.address || '',
    city: item.city,
    province: item.province,
    status: item.status,
    account_status: (item as { account_status?: string }).account_status === 'Pending' ? 'Pending' : 'Approved',
    verified: !!(item as { verified?: boolean }).verified,
    has_permit: !!(item as { has_permit?: boolean }).has_permit,
    notes: item.notes || '',
  }
  showFormDialog.value = true
}

async function handleSave() {
  const firstName = sanitizeBasicText(form.value.first_name)
  const lastName = sanitizeBasicText(form.value.last_name)
  const full_name = [firstName, lastName].filter(Boolean).join(' ') || 'Unnamed'
  const business_name = sanitizeBasicText(form.value.business_name)
  const logo_url = sanitizeBasicText(form.value.logo_url)
  const email = sanitizeBasicText(form.value.email)
  const phone = sanitizeBasicText(form.value.phone)
  const address = sanitizeBasicText(form.value.address)
  const city = sanitizeBasicText(form.value.city)
  const province = sanitizeBasicText(form.value.province)
  const notes = sanitizeBasicText(form.value.notes)

  if (hasInjectionRisk(full_name) || (notes && (!isSafeText(notes) || hasInjectionRisk(notes)))) {
    toast.error('Please remove unsafe characters from the form.')
    return
  }

  const payload = {
    full_name,
    business_name: business_name || undefined,
    logo_url: logo_url || undefined,
    email,
    phone,
    address,
    city,
    province,
    status: form.value.status,
    account_status: form.value.account_status,
    verified: form.value.verified,
    has_permit: form.value.has_permit,
    notes,
  }

  if (editingId.value) {
    const updated = await updateCarOwner(editingId.value, payload)
    if (updated) {
      const idx = owners.value.findIndex(x => x.id === editingId.value)
      if (idx !== -1) owners.value[idx] = mapApiOwner(updated)
      else owners.value.unshift(mapApiOwner(updated))
      toast.success('Car rental company updated')
    } else {
      const o = owners.value.find(x => x.id === editingId.value)
      if (o) {
        o.full_name = full_name
        ;(o as { business_name?: string }).business_name = business_name || undefined
        ;(o as { logo_url?: string }).logo_url = logo_url || undefined
        o.email = email
        o.phone = phone
        o.address = address
        o.city = city
        o.province = province
        o.status = form.value.status
        ;(o as { account_status: string; verified: boolean; has_permit: boolean }).account_status = form.value.account_status
        ;(o as { account_status: string; verified: boolean; has_permit: boolean }).verified = form.value.verified
        ;(o as { account_status: string; verified: boolean; has_permit: boolean }).has_permit = form.value.has_permit
        o.notes = notes
      }
      setUserScopedItem(CAR_OWNERS_STORAGE_KEY, owners.value)
      toast.warning('Update failed on server. Saved locally for now.')
    }
  } else {
    const created = await createCarOwner(payload)
    if (created) {
      owners.value.unshift(mapApiOwner(created))
      toast.success('Car rental company added')
    } else {
      const id = Math.max(0, ...owners.value.map(x => x.id)) + 1
      owners.value.push({
        id,
        full_name: full_name,
        business_name: business_name || undefined,
        logo_url: logo_url || undefined,
        email,
        phone,
        address,
        city,
        province,
        status: form.value.status,
        account_status: form.value.account_status,
        verified: form.value.verified,
        has_permit: form.value.has_permit,
        listings_count: 0,
        notes,
      } as (typeof owners.value)[0])
      setUserScopedItem(CAR_OWNERS_STORAGE_KEY, owners.value)
      toast.warning('Create failed on server. Saved locally for now.')
    }
  }
  showFormDialog.value = false
}

function openDeleteConfirm(item: { id: number; full_name: string; business_name?: string }) {
  ownerToDelete.value = item
  showDeleteConfirm.value = true
}

async function handleDeleteConfirm() {
  if (!ownerToDelete.value) return
  const { id, full_name } = ownerToDelete.value
  const ok = await deleteCarOwner(id)
  owners.value = owners.value.filter(o => o.id !== id)
  ownerToDelete.value = null
  if (ok) {
    toast.success(`"${full_name}" removed`)
  } else {
    setUserScopedItem(CAR_OWNERS_STORAGE_KEY, owners.value)
    toast.warning('Delete failed on server. Removed locally for now.')
  }
}

function sendBulkEmail(selected: { full_name?: string; email?: string }[]) {
  const emails = selected.map(o => (o as { email?: string }).email).filter(Boolean).join(',')
  if (emails) {
    window.location.href = `mailto:${emails}`
  } else {
    toast.info('No email addresses for selected rental companies.')
  }
}

function exportSelected(selected: Record<string, unknown>[]) {
  if (!selected.length) {
    toast.info('Select at least one rental company to export.')
    return
  }
  const headers = ['full_name', 'email', 'phone', 'city', 'province', 'status', 'account_status', 'listings_count']
  const rows = selected.map(row => headers.map(h => row[h] ?? ''))
  const csv = [headers.join(','), ...rows.map(r => r.map(c => `"${String(c).replace(/"/g, '""')}"`).join(','))].join('\n')
  const blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `car-rental-owners-export-${new Date().toISOString().slice(0, 10)}.csv`
  a.click()
  URL.revokeObjectURL(url)
  toast.success('Export downloaded.')
}
</script>

<style scoped>
.recent-listing-card {
  text-decoration: none;
  color: inherit;
  display: block;
}
.recent-listing-card:hover .font-weight-medium { color: rgb(var(--v-theme-primary)); }

.table-status-chips :deep(.table-status-chip) {
  font-weight: 500;
}
.table-action-buttons .table-action-btn {
  min-width: 32px;
  width: 32px;
  height: 32px;
}
</style>
