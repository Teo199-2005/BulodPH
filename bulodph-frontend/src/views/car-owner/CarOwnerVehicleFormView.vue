<template>
  <DashboardTemplate :title="isEdit ? 'Edit vehicle' : 'Add vehicle'" :subtitle="isEdit ? 'Update your listing' : 'List your car'" :animate="true" :back-to="{ name: 'car-owner-vehicles' }">
    <v-card elevation="0" rounded="lg" class="modern-card section-card-accent">
      <v-card-text class="pa-4">
        <v-form ref="formRef" @submit.prevent="save">
          <!-- Basic info -->
          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-information-outline" size="18" />
            </div>
            <span>Basic information</span>
          </div>
          <v-row dense>
            <v-col cols="12" md="6">
              <v-text-field
                :model-value="form.name"
                @update:model-value="(v) => form.name = formatInput(v, 'alphanumericSpaces')"
                label="Vehicle name *"
                placeholder="e.g. Toyota Innova 2022"
                variant="outlined"
                :rules="[rules.required, rules.minLength(2)]"
                hide-details="auto"
                class="mb-3"
                prepend-inner-icon="mdi-car-side"
              />
            </v-col>
            <v-col cols="12" md="6">
              <v-select
                v-model="form.type"
                :items="['Car']"
                label="Type *"
                variant="outlined"
                :rules="[rules.required]"
                hide-details="auto"
                class="mb-3"
                prepend-inner-icon="mdi-car-side"
              />
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field :model-value="form.brand" @update:model-value="(v) => form.brand = formatInput(v, 'letters')" label="Brand" placeholder="e.g. Toyota, Honda" variant="outlined" hide-details class="mb-3" prepend-inner-icon="mdi-tag-outline" />
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field :model-value="form.model" @update:model-value="(v) => form.model = formatInput(v, 'alphanumericSpaces')" label="Model" placeholder="e.g. Innova, City" variant="outlined" hide-details class="mb-3" prepend-inner-icon="mdi-car-info" />
            </v-col>
            <v-col cols="12" md="6">
              <v-select v-model="form.carType" :items="carTypeOptions" label="Car type" variant="outlined" hide-details class="mb-3" prepend-inner-icon="mdi-car-cog" />
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field
                :model-value="form.location"
                @update:model-value="(v) => form.location = formatInput(v, 'letters')"
                label="Location *"
                placeholder="e.g. Cauayan, Isabela"
                variant="outlined"
                :rules="[rules.required, rules.minLength(2)]"
                hide-details="auto"
                class="mb-3"
                prepend-inner-icon="mdi-map-marker-outline"
              />
            </v-col>
            <v-col cols="12">
              <v-textarea
                v-model="form.description"
                label="Description"
                placeholder="Brief description, features (e.g. 7-seater, AC, good for family trips)"
                variant="outlined"
                rows="3"
                :rules="[rules.optionalMinLength(10)]"
                hide-details="auto"
                class="mb-3"
              />
            </v-col>
          </v-row>

          <!-- Specs -->
          <div class="form-section-header form-section-header--spaced">
            <div class="form-section-icon">
              <v-icon icon="mdi-cog-outline" size="18" />
            </div>
            <span>Specifications</span>
          </div>
          <v-row dense>
            <v-col cols="12" sm="6" md="4">
              <v-select v-model="form.transmission" :items="['Automatic', 'Manual']" label="Transmission" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-text-field :model-value="form.capacity" @update:model-value="(v) => form.capacity = sanitizeQuantity(v, { min: 1, max: 20 }) || undefined" label="Capacity (seats)" type="number" min="1" max="20" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-select v-model="form.fuelType" :items="['Gasoline', 'Diesel', 'Electric']" label="Fuel type" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" md="6">
              <v-select v-model="form.fuelReturnPolicy" :items="['Return with Same Level', 'Full Tank', 'Empty']" label="Fuel return policy" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-text-field :model-value="form.carNumber" @update:model-value="(v) => form.carNumber = formatInput(v, 'plateNumber')" label="Plate / car number" placeholder="e.g. ABC 1234" variant="outlined" hide-details class="mb-3" />
            </v-col>
          </v-row>

          <!-- Pricing -->
          <div class="form-section-header form-section-header--spaced">
            <div class="form-section-icon">
              <v-icon icon="mdi-currency-php" size="18" />
            </div>
            <span>Pricing &amp; policy</span>
          </div>
          <v-row dense>
            <v-col cols="12" sm="6" md="4">
              <v-text-field
                :model-value="form.pricePerDay"
                @update:model-value="(v) => form.pricePerDay = sanitizePrice(v)"
                label="Price per day (₱) *"
                type="number"
                min="0"
                variant="outlined"
                :rules="[rules.required, rules.priceMin]"
                hide-details="auto"
                class="mb-3"
                prepend-inner-icon="mdi-currency-php"
              />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-text-field :model-value="form.securityDeposit" @update:model-value="(v) => form.securityDeposit = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined" label="Security deposit (₱)" type="number" min="0" placeholder="Optional" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-text-field :model-value="form.overdueChargeRate" @update:model-value="(v) => form.overdueChargeRate = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined" label="Overdue charge (₱/hr)" type="number" min="0" placeholder="Optional" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-select
                v-model="form.rentalMode"
                :items="rentalModeItems"
                label="Rental mode *"
                variant="outlined"
                hide-details
                class="mb-3"
                prepend-inner-icon="mdi-car-key"
              />
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-text-field :model-value="form.minRentalPeriodHours" @update:model-value="(v) => form.minRentalPeriodHours = (v === '' || v == null) ? undefined : sanitizeQuantity(v, { min: 1, max: 8760 })" label="Min rental (hours)" type="number" min="1" placeholder="e.g. 24" variant="outlined" hide-details class="mb-3" />
              <div class="d-flex flex-wrap gap-2 mt-1">
                <v-chip
                  v-for="hr in minRentalPresetHours"
                  :key="hr"
                  size="small"
                  :color="form.minRentalPeriodHours === hr ? 'primary' : undefined"
                  :variant="form.minRentalPeriodHours === hr ? 'flat' : 'tonal'"
                  @click="form.minRentalPeriodHours = hr"
                >
                  {{ hr }}h
                </v-chip>
              </div>
            </v-col>
          </v-row>

          <!-- Photos -->
          <div class="form-section-header form-section-header--spaced">
            <div class="form-section-icon">
              <v-icon icon="mdi-image-multiple-outline" size="18" />
            </div>
            <span>Photos</span>
          </div>
          <v-file-input
            v-model="mainImageFiles"
            label="Main image *"
            placeholder="Upload main photo (JPG, PNG)"
            prepend-inner-icon="mdi-camera"
            prepend-icon=""
            accept="image/*"
            show-size
            variant="outlined"
            hide-details
            class="mb-2"
            @update:model-value="onMainImageSelect"
          />
          <v-img v-if="form.image" :src="form.image" alt="Main" cover max-height="100" class="rounded-lg mb-3" />
          <p class="text-caption text-medium-emphasis mb-2">Four sides (optional): Front, Rear, Left, Right.</p>
          <v-row dense>
            <v-col cols="12" sm="6" md="3">
              <v-file-input v-model="sideImageFiles.front" label="Front" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="compact" hide-details class="mb-2" @update:model-value="(f) => onSideImageSelect('imageFront', f)" />
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <v-file-input v-model="sideImageFiles.rear" label="Rear" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="compact" hide-details class="mb-2" @update:model-value="(f) => onSideImageSelect('imageRear', f)" />
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <v-file-input v-model="sideImageFiles.left" label="Left" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="compact" hide-details class="mb-2" @update:model-value="(f) => onSideImageSelect('imageLeft', f)" />
            </v-col>
            <v-col cols="12" sm="6" md="3">
              <v-file-input v-model="sideImageFiles.right" label="Right" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="compact" hide-details class="mb-2" @update:model-value="(f) => onSideImageSelect('imageRight', f)" />
            </v-col>
          </v-row>

          <!-- Tags & status -->
          <div class="form-section-header form-section-header--spaced">
            <div class="form-section-icon">
              <v-icon icon="mdi-format-list-bulleted" size="18" />
            </div>
            <span>Listing</span>
          </div>
          <v-row dense>
            <v-col cols="12" md="6">
              <v-text-field v-model="tagsInput" label="Tags" placeholder="e.g. 7-seater, AC, Verified (comma-separated)" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12" md="6">
              <v-select v-model="form.status" :items="['Available', 'Unavailable']" label="Status" variant="outlined" hide-details class="mb-3" />
            </v-col>
            <v-col cols="12">
              <v-text-field :model-value="form.knownIssues" @update:model-value="(v) => form.knownIssues = formatInput(v, 'address')" label="Known issues (optional)" placeholder="e.g. Minor scratch on rear bumper" variant="outlined" hide-details class="mb-3" />
            </v-col>
          </v-row>

          <v-divider class="my-4" />
          <div class="d-flex flex-wrap align-center form-actions">
            <v-btn color="primary" rounded="lg" :loading="saving" type="submit">Save</v-btn>
            <v-btn variant="outlined" rounded="lg" :disabled="saving" :to="{ name: 'car-owner-vehicles' }">Cancel</v-btn>
            <v-btn
              v-if="!isEdit"
              variant="tonal"
              color="secondary"
              rounded="lg"
              :disabled="saving"
              prepend-icon="mdi-flask-outline"
              @click="fillDemo"
            >
              Demo fill
            </v-btn>
          </div>
        </v-form>
      </v-card-text>
    </v-card>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import { useToastStore } from '@/stores/toast'
import { useVehicles } from '@/composables/useVehicles'
import { persistVehicle, getStoredVehicleById } from '@/composables/useCarOwnerVehiclePersistence'
import { useUserSessionStore } from '@/stores/userSession'
import { filesToDataUrls } from '@/composables/useImageUpload'
import { formatInput } from '@/utils/inputFormatters'
import { sanitizePrice, sanitizeQuantity, validatePrice } from '@/utils/numericValidation'
import type { CarType, RentalMode, VehicleSeedItem } from '@/constants/vehicleSeed'

const route = useRoute()

const mainImageFiles = ref<File[] | null>(null)
const sideImageFiles = ref<{ front: File[] | null; rear: File[] | null; left: File[] | null; right: File[] | null }>({
  front: null, rear: null, left: null, right: null,
})

async function onMainImageSelect(files: File[] | null) {
  const url = await filesToDataUrls(files) as string | null
  if (url) form.value.image = url
}

async function onSideImageSelect(field: 'imageFront' | 'imageRear' | 'imageLeft' | 'imageRight', files: File[] | null) {
  const url = await filesToDataUrls(files) as string | null
  if (url) form.value[field] = url
}
const router = useRouter()
const toast = useToastStore()
const { getById, add, update } = useVehicles()
const userSession = useUserSessionStore()

const isEdit = computed(() => !!route.params.id)

const form = ref({
  name: '',
  type: 'Car',
  brand: '',
  model: '',
  carType: '' as CarType | '',
  location: '',
  description: '',
  transmission: '' as 'Automatic' | 'Manual' | '',
  capacity: undefined as number | undefined,
  fuelType: '' as 'Gasoline' | 'Diesel' | 'Electric' | '',
  fuelReturnPolicy: '' as string,
  carNumber: '',
  pricePerDay: 0,
  securityDeposit: undefined as number | undefined,
  overdueChargeRate: undefined as number | undefined,
  rentalMode: 'both' as RentalMode,
  minRentalPeriodHours: undefined as number | undefined,
  image: '',
  imageFront: '',
  imageRear: '',
  imageLeft: '',
  imageRight: '',
  status: 'Available' as 'Available' | 'Unavailable',
  knownIssues: '',
})

const tagsInput = ref('')

const carTypeOptions = [
  { title: '—', value: '' },
  { title: 'Sedan', value: 'Sedan' },
  { title: 'SUV', value: 'SUV' },
  { title: 'MPV', value: 'MPV' },
  { title: 'Hatchback', value: 'Hatchback' },
  { title: 'Van', value: 'Van' },
]

const rentalModeItems = [
  { title: 'Driver only', value: 'driver_only' as RentalMode },
  { title: 'Self-drive only', value: 'self_drive_only' as RentalMode },
  { title: 'Both', value: 'both' as RentalMode },
]

const minRentalPresetHours = [12, 24, 36, 48]


// Load existing vehicle when editing
watch(
  () => route.params.id,
  (id) => {
    mainImageFiles.value = null
    sideImageFiles.value = { front: null, rear: null, left: null, right: null }
    if (id) {
      const v = getById(id as string) ?? getStoredVehicleById(id as string)
      if (v) {
        form.value = {
          name: v.name,
          type: v.type,
          brand: v.brand ?? '',
          model: v.model ?? '',
          carType: (v.carType ?? '') as CarType | '',
          location: v.location,
          description: v.description ?? '',
          transmission: (v.transmission ?? '') as 'Automatic' | 'Manual' | '',
          capacity: v.capacity,
          fuelType: (v.fuelType ?? '') as 'Gasoline' | 'Diesel' | 'Electric' | '',
          fuelReturnPolicy: v.fuelReturnPolicy ?? '',
          carNumber: v.carNumber ?? '',
          pricePerDay: v.pricePerDay,
          securityDeposit: v.securityDeposit,
          overdueChargeRate: v.overdueChargeRate,
          rentalMode: (v.rentalMode ?? 'both') as RentalMode,
          minRentalPeriodHours: v.minRentalPeriodHours,
          image: v.image ?? '',
          imageFront: v.imagesFourSides?.front ?? '',
          imageRear: v.imagesFourSides?.rear ?? '',
          imageLeft: v.imagesFourSides?.left ?? '',
          imageRight: v.imagesFourSides?.right ?? '',
          status: (v.status ?? 'Available') as 'Available' | 'Unavailable',
          knownIssues: v.knownIssues ?? '',
        }
        tagsInput.value = (v.tags ?? []).join(', ')
      }
    } else {
      form.value = {
        name: '',
        type: 'Car',
        brand: '',
        model: '',
        carType: '',
        location: '',
        description: '',
        transmission: '',
        capacity: undefined,
        fuelType: '',
        fuelReturnPolicy: '',
        carNumber: '',
        pricePerDay: 0,
        securityDeposit: undefined,
        overdueChargeRate: undefined,
        rentalMode: 'both' as RentalMode,
        minRentalPeriodHours: undefined,
        image: '',
        imageFront: '',
        imageRear: '',
        imageLeft: '',
        imageRight: '',
        status: 'Available',
        knownIssues: '',
      }
      tagsInput.value = ''
    }
  },
  { immediate: true }
)

const formRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)
const saving = ref(false)

const rules = {
  required: (v: unknown) => (v !== undefined && v !== null && String(v).trim() !== '') || 'Required',
  minLength: (min: number) => (v: unknown) =>
    !v || String(v).trim().length >= min || `At least ${min} characters`,
  optionalMinLength: (min: number) => (v: unknown) =>
    !v || String(v).trim().length === 0 || String(v).trim().length >= min || `At least ${min} characters if provided`,
  priceMin: (v: unknown) => validatePrice(v) || true,
}

const defaultImage = 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop'
/** Demo 4-side images (from codebase / vehicleSeed-style Unsplash URLs) */
const demoFourSides = {
  front: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop',
  rear: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80&fit=crop',
  left: 'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?w=800&q=80&fit=crop',
  right: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800&q=80&fit=crop',
}

function fillDemo() {
  form.value = {
    name: 'Toyota Innova 2022',
    type: 'Car',
    brand: 'Toyota',
    model: 'Innova',
    carType: 'MPV' as CarType,
    location: 'Cauayan',
    description: '7-seater MPV, air-conditioned, well-maintained. Ideal for family trips and out-of-town drives.',
    transmission: 'Automatic' as 'Automatic' | 'Manual',
    capacity: 7,
    fuelType: 'Diesel' as 'Gasoline' | 'Diesel' | 'Electric',
    fuelReturnPolicy: 'Full Tank',
    carNumber: 'ABC 1234',
    pricePerDay: 2500,
    securityDeposit: 5000,
    overdueChargeRate: 150,
    rentalMode: 'both' as RentalMode,
    minRentalPeriodHours: 24,
    image: defaultImage,
    imageFront: demoFourSides.front,
    imageRear: demoFourSides.rear,
    imageLeft: demoFourSides.left,
    imageRight: demoFourSides.right,
    status: 'Available',
    knownIssues: '',
  }
  tagsInput.value = '7-seater, AC, Family-friendly, Verified'
  mainImageFiles.value = null
  sideImageFiles.value = { front: null, rear: null, left: null, right: null }
  toast.success('Form filled with demo data. You can edit and Save.')
}

async function save() {
  const { valid } = await formRef.value?.validate() ?? { valid: false }
  if (!valid) return

  const hasMainImage = form.value.image || (mainImageFiles.value && mainImageFiles.value.length > 0)
  if (!hasMainImage) {
    toast.error('Please add a main image.')
    return
  }

  saving.value = true
  try {
    const result = await doSave()
    if (result) {
      persistVehicle(result as VehicleSeedItem)
      toast.success(isEdit.value ? 'Vehicle updated.' : 'Vehicle added.')
      router.push({ name: 'car-owner-vehicles' })
    } else {
      toast.error('Could not save vehicle. Check your connection and try again.')
    }
  } catch (_) {
    toast.error('Could not save vehicle. Please try again.')
  } finally {
    saving.value = false
  }
}

async function doSave(): Promise<unknown> {
  const tags = tagsInput.value
    .split(',')
    .map((t) => t.trim())
    .filter(Boolean)
  const imagesFourSides =
    form.value.imageFront || form.value.imageRear || form.value.imageLeft || form.value.imageRight
      ? {
          front: form.value.imageFront || form.value.image,
          rear: form.value.imageRear || form.value.image,
          left: form.value.imageLeft || form.value.image,
          right: form.value.imageRight || form.value.image,
        }
      : undefined

  const payload = {
    name: form.value.name,
    type: form.value.type,
    location: form.value.location,
    pricePerDay: sanitizePrice(form.value.pricePerDay),
    description: form.value.description || '',
    image: form.value.image || defaultImage,
    status: form.value.status,
    ...(form.value.brand && { brand: form.value.brand }),
    ...(form.value.model && { model: form.value.model }),
    ...(form.value.carType && { carType: form.value.carType as CarType }),
    ...(form.value.transmission && { transmission: form.value.transmission as 'Automatic' | 'Manual' }),
    ...(form.value.capacity != null && { capacity: form.value.capacity }),
    ...(form.value.fuelType && { fuelType: form.value.fuelType as 'Gasoline' | 'Diesel' | 'Electric' }),
    ...(form.value.fuelReturnPolicy && { fuelReturnPolicy: form.value.fuelReturnPolicy }),
    ...(form.value.carNumber && { carNumber: form.value.carNumber }),
    ...(form.value.securityDeposit != null && form.value.securityDeposit > 0 && { securityDeposit: sanitizePrice(form.value.securityDeposit) }),
    ...(form.value.overdueChargeRate != null && form.value.overdueChargeRate > 0 && { overdueChargeRate: sanitizePrice(form.value.overdueChargeRate) }),
    ...(form.value.rentalMode && { rentalMode: form.value.rentalMode as RentalMode }),
    ...(form.value.minRentalPeriodHours != null && form.value.minRentalPeriodHours > 0 && { minRentalPeriodHours: sanitizeQuantity(form.value.minRentalPeriodHours, { min: 1, max: 8760 }) }),
    ...(tags.length > 0 && { tags }),
    ...(imagesFourSides && { imagesFourSides }),
    ...(form.value.knownIssues && { knownIssues: form.value.knownIssues }),
    businessName: userSession.user?.name ?? undefined,
    hostName: userSession.user?.name ?? undefined,
  }

  if (isEdit.value) {
    return update(route.params.id as string, payload)
  }
  return add(payload as any)
}
</script>

<style scoped>
.form-actions {
  gap: 1rem;
}
</style>
