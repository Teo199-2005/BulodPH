<template>
  <DashboardTemplate title="Dashboard promos" subtitle="Images shown on Client, Car rental owner & Marketing dashboards" :animate="true" :back-to="{ name: 'admin-dashboard' }" back-label="Back to dashboard">
    <div class="d-flex justify-end mb-4">
      <v-btn color="primary" prepend-icon="mdi-plus" rounded="lg" @click="openForm()">
        Add promo
      </v-btn>
    </div>

    <v-card elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <v-list v-if="promos.length" class="pa-0">
          <v-list-item
            v-for="promo in promos"
            :key="promo.id"
            class="px-0 align-start"
          >
            <template #prepend>
              <v-img
                :src="promo.imageUrl"
                :alt="promo.title"
                cover
                width="120"
                height="72"
                class="rounded-lg flex-shrink-0 mr-4"
              />
            </template>
            <v-list-item-title class="font-weight-medium">{{ promo.title || 'Untitled' }}</v-list-item-title>
            <v-list-item-subtitle>
              {{ promo.linkUrl || 'No link' }} · Target: {{ promo.targetRole }} · Order: {{ promo.order }}
              <template v-if="promo.imageWidth != null && promo.imageHeight != null">
                · Image: {{ promo.imageWidth }} × {{ promo.imageHeight }} px
              </template>
              <v-chip :color="promo.active ? 'success' : 'grey'" :prepend-icon="promo.active ? 'mdi-check-circle' : 'mdi-pause-circle-outline'" size="x-small" variant="tonal" class="ml-2">{{ promo.active ? 'Active' : 'Inactive' }}</v-chip>
            </v-list-item-subtitle>
            <template #append>
              <div class="d-flex gap-2">
                <v-tooltip location="bottom">
                  <template #activator="{ props: tooltipProps }">
                    <v-btn v-bind="tooltipProps" variant="text" size="small" icon="mdi-pencil" aria-label="Edit promo" @click="openForm(promo)" />
                  </template>
                  Edit promo
                </v-tooltip>
                <v-tooltip location="bottom">
                  <template #activator="{ props: tooltipProps }">
                    <v-btn v-bind="tooltipProps" variant="text" size="small" icon="mdi-delete-outline" color="error" aria-label="Delete promo" @click="confirmDelete(promo)" />
                  </template>
                  Delete promo
                </v-tooltip>
              </div>
            </template>
          </v-list-item>
        </v-list>
        <p v-else class="text-body-2 text-medium-emphasis mb-0">No dashboard promos yet. Add one to show images on Client, Car rental owner, and Marketing dashboards.</p>
      </v-card-text>
    </v-card>

    <!-- Add / Edit dialog -->
    <HpaModal
      v-model="showDialog"
      :title="editingId ? 'Edit promo' : 'Add promo'"
      icon="mdi-image-plus-outline"
      max-width="500"
      :persistent="true"
      :confirm-text="editingId ? 'Save' : 'Add'"
      cancel-text="Cancel"
      :confirm-disabled="!canSavePromo"
      @confirm="save"
    >
      <v-file-input
            v-model="promoImageFiles"
            label="Upload promo image"
            placeholder="Choose image (JPG, PNG)"
            prepend-inner-icon="mdi-camera"
            prepend-icon=""
            accept="image/*"
            show-size
            variant="outlined"
            density="comfortable"
            hide-details
            class="mb-2"
            @update:model-value="onPromoImageSelect"
          />
            <div v-if="form.imageUrl" class="promo-image-preview-wrap mb-3">
            <div
              ref="previewRef"
              class="promo-image-preview promo-image-preview--interactive"
              :style="{
                '--promo-zoom': form.imageZoom,
                '--promo-pos-x': form.imagePosX + '%',
                '--promo-pos-y': form.imagePosY + '%',
                '--promo-stretch-w': form.imageStretchW,
                '--promo-stretch-h': form.imageStretchH,
              }"
              tabindex="0"
              role="img"
              aria-label="Adjust image: drag to move, scroll to zoom"
              @mousedown.prevent="onPreviewPointerDown"
              @wheel.prevent="onPreviewWheel"
              @touchstart="onPreviewTouchStart"
              @touchmove.prevent="onPreviewTouchMove"
              @touchend="onPreviewTouchEnd"
            >
              <img :src="form.imageUrl" alt="Promo preview" class="promo-image-preview__img" draggable="false" />
            </div>
            <p v-if="form.imageWidth != null && form.imageHeight != null" class="text-caption text-medium-emphasis mt-2 mb-0">
              Drag to move · Scroll to zoom · Pinch to zoom on mobile. Image: {{ form.imageWidth }} × {{ form.imageHeight }} px
            </p>
            <div v-if="form.imageUrl" class="d-flex flex-column gap-2 mt-2">
              <p class="text-caption text-medium-emphasis mb-0">Stretch (preserves quality):</p>
              <div class="d-flex align-center gap-3">
                <span class="text-caption" style="min-width: 4rem">Width {{ Math.round(form.imageStretchW * 100) }}%</span>
                <v-slider
                  v-model="form.imageStretchW"
                  :min="0.5"
                  :max="1.5"
                  :step="0.01"
                  hide-details
                  density="compact"
                  class="flex-grow-1"
                />
              </div>
              <div class="d-flex align-center gap-3">
                <span class="text-caption" style="min-width: 4rem">Height {{ Math.round(form.imageStretchH * 100) }}%</span>
                <v-slider
                  v-model="form.imageStretchH"
                  :min="0.5"
                  :max="1.5"
                  :step="0.01"
                  hide-details
                  density="compact"
                  class="flex-grow-1"
                />
              </div>
            </div>
          </div>
          <v-text-field
            v-model="form.title"
            label="Title (optional)"
            placeholder="e.g. 10% on 1-day booking"
            variant="outlined"
            density="comfortable"
            hide-details
            class="mb-3"
          />
          <v-text-field
            v-model="form.linkUrl"
            label="Link URL (optional)"
            placeholder="/client/promo or https://..."
            variant="outlined"
            density="comfortable"
            hide-details
            class="mb-3"
          />
          <v-select
            v-model="form.targetRole"
            :items="targetRoleOptions"
            label="Show on dashboard"
            variant="outlined"
            density="comfortable"
            hide-details
            class="mb-3"
          />
          <v-text-field
            v-model.number="form.order"
            type="number"
            min="0"
            label="Order (lower = first)"
            variant="outlined"
            density="comfortable"
            hide-details
            class="mb-3"
          />
          <v-checkbox v-model="form.active" label="Active (visible on dashboard)" hide-details color="primary" />
    </HpaModal>

    <!-- Delete confirm -->
    <HpaConfirmModal
      v-model="showDeleteConfirm"
      title="Delete this promo?"
      message="It will be removed from all dashboards. This cannot be undone."
      confirm-text="Delete"
      cancel-text="Cancel"
      variant="danger"
      @confirm="doDelete"
    />
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { useDashboardPromosStore } from '@/stores/dashboardPromos'
import { useToastStore } from '@/stores/toast'
import { filesToDataUrls, getImageDimensions } from '@/composables/useImageUpload'
import type { DashboardPromo, DashboardPromoRole } from '@/stores/dashboardPromos'

const dashboardPromosStore = useDashboardPromosStore()
const toast = useToastStore()

const promoImageFiles = ref<File[] | File | null>(null)

const canSavePromo = computed(() => !!form.value.imageUrl || (Array.isArray(promoImageFiles.value) ? promoImageFiles.value.length > 0 : promoImageFiles.value instanceof File))

const previewRef = ref<HTMLElement | null>(null)
const isDragging = ref(false)
const lastPointer = ref({ x: 0, y: 0 })
const POSITION_SENSITIVITY = 0.15
/** Smaller = more precise: each scroll step changes zoom little by little */
const ZOOM_WHEEL_SENSITIVITY = 0.0012
/** Dampen pinch so zoom doesn't jump 100% in one gesture (0–1, lower = more precise) */
const PINCH_ZOOM_DAMPEN = 0.35
/** Low min so you can zoom out until the full image fits with no cropping */
const MIN_ZOOM = 0.25
const MAX_ZOOM = 2

const pinchState = ref<{ distance: number; zoom: number; centerX: number; centerY: number } | null>(null)

function getTouchCenter(touches: TouchList): { x: number; y: number } {
  const n = touches.length
  let x = 0, y = 0
  for (let i = 0; i < n; i++) {
    x += touches[i].clientX
    y += touches[i].clientY
  }
  return { x: x / n, y: y / n }
}

function getTouchDistance(touches: TouchList): number {
  if (touches.length < 2) return 0
  const a = touches[0]
  const b = touches[1]
  return Math.hypot(b.clientX - a.clientX, b.clientY - a.clientY)
}

function onPreviewPointerDown(e: MouseEvent) {
  if (e.button !== 0) return
  e.preventDefault()
  isDragging.value = true
  lastPointer.value = { x: e.clientX, y: e.clientY }
}

function onPointerMove(e: MouseEvent) {
  if (!isDragging.value) return
  const dx = e.clientX - lastPointer.value.x
  const dy = e.clientY - lastPointer.value.y
  lastPointer.value = { x: e.clientX, y: e.clientY }
  form.value.imagePosX = Math.max(0, Math.min(100, form.value.imagePosX + dx * POSITION_SENSITIVITY))
  form.value.imagePosY = Math.max(0, Math.min(100, form.value.imagePosY + dy * POSITION_SENSITIVITY))
}

function onPointerUp() {
  isDragging.value = false
}

function onPreviewWheel(e: WheelEvent) {
  const delta = -e.deltaY * ZOOM_WHEEL_SENSITIVITY
  form.value.imageZoom = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, form.value.imageZoom + delta))
}

function onPreviewTouchStart(e: TouchEvent) {
  if (e.touches.length === 2) {
    pinchState.value = {
      distance: getTouchDistance(e.touches),
      zoom: form.value.imageZoom,
      centerX: getTouchCenter(e.touches).x,
      centerY: getTouchCenter(e.touches).y,
    }
  } else {
    pinchState.value = null
    if (e.touches.length === 1) {
      isDragging.value = true
      lastPointer.value = { x: e.touches[0].clientX, y: e.touches[0].clientY }
    }
  }
}

function onPreviewTouchMove(e: TouchEvent) {
  if (e.touches.length === 2 && pinchState.value) {
    const d = getTouchDistance(e.touches)
    const ratio = d / pinchState.value.distance
    // Dampen: apply only part of the ratio so pinch zooms little by little
    const dampedRatio = 1 + (ratio - 1) * PINCH_ZOOM_DAMPEN
    form.value.imageZoom = Math.max(MIN_ZOOM, Math.min(MAX_ZOOM, pinchState.value.zoom * dampedRatio))
  } else if (e.touches.length === 1 && isDragging.value) {
    const dx = e.touches[0].clientX - lastPointer.value.x
    const dy = e.touches[0].clientY - lastPointer.value.y
    lastPointer.value = { x: e.touches[0].clientX, y: e.touches[0].clientY }
    form.value.imagePosX = Math.max(0, Math.min(100, form.value.imagePosX + dx * POSITION_SENSITIVITY))
    form.value.imagePosY = Math.max(0, Math.min(100, form.value.imagePosY + dy * POSITION_SENSITIVITY))
  }
}

function onPreviewTouchEnd(e: TouchEvent) {
  if (e.touches.length < 2) pinchState.value = null
  if (e.touches.length === 0) isDragging.value = false
}

onMounted(() => {
  window.addEventListener('mousemove', onPointerMove)
  window.addEventListener('mouseup', onPointerUp)
})
onUnmounted(() => {
  window.removeEventListener('mousemove', onPointerMove)
  window.removeEventListener('mouseup', onPointerUp)
})

async function onPromoImageSelect(files: File[] | File | null) {
  const url = await filesToDataUrls(files) as string | null
  if (url) {
    form.value.imageUrl = url
    try {
      const { width, height } = await getImageDimensions(url)
      form.value.imageWidth = width
      form.value.imageHeight = height
    } catch {
      form.value.imageWidth = undefined
      form.value.imageHeight = undefined
    }
  }
}

const promos = computed(() => dashboardPromosStore.list)

const showDialog = ref(false)
const editingId = ref<string | null>(null)
const showDeleteConfirm = ref(false)
const deleteTargetId = ref<string | null>(null)

const targetRoleOptions = [
  { title: 'Client dashboard', value: 'client' as DashboardPromoRole },
  { title: 'Car rental owner dashboard', value: 'car_owner' as DashboardPromoRole },
  { title: 'Marketing dashboard', value: 'marketing' as DashboardPromoRole },
  { title: 'All dashboards', value: 'all' as DashboardPromoRole },
]

const form = ref({
  imageUrl: '',
  imageWidth: undefined as number | undefined,
  imageHeight: undefined as number | undefined,
  imageZoom: 1,
  imagePosX: 50,
  imagePosY: 50,
  imageStretchW: 1,
  imageStretchH: 1,
  title: '',
  linkUrl: '',
  targetRole: 'client' as DashboardPromoRole,
  order: 0,
  active: true,
})

type ApplyImageResult = { dataUrl: string; width: number; height: number }

/** Max longest side for saved image so it fits in localStorage without quota errors. */
const MAX_SAVE_LONG_SIDE = 1920

/** Draw image with zoom, position, and optional stretch. Auto-downscales so save never hits quota. */
async function applyImageAdjust(
  imageUrl: string,
  zoom: number,
  posX: number,
  posY: number,
  stretchW: number = 1,
  stretchH: number = 1
): Promise<ApplyImageResult> {
  return new Promise((resolve, reject) => {
    const img = new Image()
    if (!imageUrl.startsWith('data:')) img.crossOrigin = 'anonymous'
    img.onload = () => {
      const w = img.naturalWidth
      const h = img.naturalHeight
      const canvas = document.createElement('canvas')
      canvas.width = w
      canvas.height = h
      const ctx = canvas.getContext('2d')
      if (!ctx) {
        resolve({ dataUrl: imageUrl, width: w, height: h })
        return
      }
      const cropW = w / zoom
      const cropH = h / zoom
      const sx = Math.max(0, (w - cropW) * (posX / 100))
      const sy = Math.max(0, (h - cropH) * (posY / 100))
      ctx.drawImage(img, sx, sy, cropW, cropH, 0, 0, w, h)
      let outW = w
      let outH = h
      let lastCanvas: HTMLCanvasElement = canvas
      if (stretchW !== 1 || stretchH !== 1) {
        outW = Math.round(w * stretchW)
        outH = Math.round(h * stretchH)
        const MAX_CANVAS = 4096
        if (outW > 0 && outH > 0 && outW <= MAX_CANVAS && outH <= MAX_CANVAS) {
          const canvas2 = document.createElement('canvas')
          canvas2.width = outW
          canvas2.height = outH
          const ctx2 = canvas2.getContext('2d')
          if (ctx2) {
            ctx2.imageSmoothingEnabled = true
            ;(ctx2 as CanvasRenderingContext2D & { imageSmoothingQuality?: string }).imageSmoothingQuality = 'high'
            ctx2.drawImage(canvas, 0, 0, w, h, 0, 0, outW, outH)
            lastCanvas = canvas2
          }
        } else {
          outW = w
          outH = h
        }
      }
      let dataUrl: string
      let finalW = outW
      let finalH = outH
      const longSide = Math.max(outW, outH)
      if (longSide > MAX_SAVE_LONG_SIDE) {
        const scale = MAX_SAVE_LONG_SIDE / longSide
        finalW = Math.round(outW * scale)
        finalH = Math.round(outH * scale)
        const canvas3 = document.createElement('canvas')
        canvas3.width = finalW
        canvas3.height = finalH
        const ctx3 = canvas3.getContext('2d')
        if (ctx3) {
          ctx3.imageSmoothingEnabled = true
          ;(ctx3 as CanvasRenderingContext2D & { imageSmoothingQuality?: string }).imageSmoothingQuality = 'high'
          ctx3.drawImage(lastCanvas, 0, 0, lastCanvas.width, lastCanvas.height, 0, 0, finalW, finalH)
          try {
            dataUrl = canvas3.toDataURL('image/jpeg', 0.9)
          } catch {
            dataUrl = lastCanvas.toDataURL('image/jpeg', 0.88)
            finalW = outW
            finalH = outH
          }
        } else {
          dataUrl = lastCanvas.toDataURL('image/jpeg', 0.88)
          finalW = outW
          finalH = outH
        }
      } else {
        try {
          dataUrl = lastCanvas.toDataURL('image/jpeg', 0.9)
        } catch {
          resolve({ dataUrl: imageUrl, width: w, height: h })
          return
        }
      }
      resolve({ dataUrl, width: finalW, height: finalH })
    }
    img.onerror = () => reject(new Error('Image load failed'))
    img.src = imageUrl
  })
}

watch(showDialog, (open) => {
  if (!open) {
    editingId.value = null
    promoImageFiles.value = null
    form.value = {
      imageUrl: '',
      imageWidth: undefined,
      imageHeight: undefined,
      imageZoom: 1,
      imagePosX: 50,
      imagePosY: 50,
      imageStretchW: 1,
      imageStretchH: 1,
      title: '',
      linkUrl: '',
      targetRole: 'client',
      order: 0,
      active: true,
    }
  }
})

function openForm(promo?: DashboardPromo) {
  promoImageFiles.value = null
  if (promo) {
    editingId.value = promo.id
    form.value = {
      imageUrl: promo.imageUrl,
      imageWidth: promo.imageWidth,
      imageHeight: promo.imageHeight,
      imageZoom: 1,
      imagePosX: 50,
      imagePosY: 50,
      imageStretchW: 1,
      imageStretchH: 1,
      title: promo.title,
      linkUrl: promo.linkUrl ?? '',
      targetRole: promo.targetRole,
      order: promo.order,
      active: promo.active,
    }
  } else {
    editingId.value = null
    const maxOrder = Math.max(0, ...promos.value.map((p) => p.order))
    form.value = {
      imageUrl: '',
      imageWidth: undefined,
      imageHeight: undefined,
      imageZoom: 1,
      imagePosX: 50,
      imagePosY: 50,
      imageStretchW: 1,
      imageStretchH: 1,
      title: '',
      linkUrl: '',
      targetRole: 'client',
      order: maxOrder + 1,
      active: true,
    }
  }
  showDialog.value = true
}

async function save() {
  try {
    if (!form.value.imageUrl && promoImageFiles.value) {
      const url = await filesToDataUrls(promoImageFiles.value) as string | null
      if (url) form.value.imageUrl = url
    }
    if (!form.value.imageUrl) {
      toast.warning('Please upload an image.')
      return
    }
    let imageUrlToSave = form.value.imageUrl
    let outWidth = form.value.imageWidth
    let outHeight = form.value.imageHeight
    try {
      const result = await applyImageAdjust(
        form.value.imageUrl,
        form.value.imageZoom,
        form.value.imagePosX,
        form.value.imagePosY,
        form.value.imageStretchW,
        form.value.imageStretchH
      )
      imageUrlToSave = result.dataUrl
      outWidth = result.width
      outHeight = result.height
    } catch {
      // Image load failed (e.g. CORS) or canvas tainted: save without applying crop/stretch
      toast.warning('Image could not be processed; saving without crop/stretch. Re-upload the image to apply adjustments.')
    }
    const payload = {
      imageUrl: imageUrlToSave,
      imageWidth: outWidth,
      imageHeight: outHeight,
      title: form.value.title,
      linkUrl: form.value.linkUrl || undefined,
      targetRole: form.value.targetRole,
      order: form.value.order,
      active: form.value.active,
    }
    const isEdit = !!editingId.value
    if (isEdit) {
      dashboardPromosStore.update(editingId.value!, payload)
    } else {
      dashboardPromosStore.add(payload)
    }
    showDialog.value = false
    toast.success(isEdit ? 'Promo updated.' : 'Promo added.')
  } catch {
    toast.error('Could not save promo. Please try again.')
  }
}

function confirmDelete(promo: DashboardPromo) {
  deleteTargetId.value = promo.id
  showDeleteConfirm.value = true
}

function doDelete() {
  if (deleteTargetId.value) {
    dashboardPromosStore.remove(deleteTargetId.value)
    toast.success('Promo removed.')
    deleteTargetId.value = null
  }
  showDeleteConfirm.value = false
}
</script>

<style scoped>
.promo-image-preview-wrap {
  border-radius: 12px;
  overflow: hidden;
  background: var(--surface-2, #e2e8f0);
}
.promo-image-preview {
  height: 160px;
  overflow: hidden;
  position: relative;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}
/* contain = show full image so zooming out reveals everything; position/zoom still control crop for save */
.promo-image-preview__img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: var(--promo-pos-x, 50%) var(--promo-pos-y, 50%);
  transform: scale(var(--promo-zoom, 1)) scaleX(var(--promo-stretch-w, 1)) scaleY(var(--promo-stretch-h, 1));
  transform-origin: center center;
  pointer-events: none;
  user-select: none;
}
.promo-image-preview--interactive {
  cursor: grab;
  touch-action: none;
  user-select: none;
  -webkit-user-select: none;
  pointer-events: auto;
}
.promo-image-preview--interactive:active {
  cursor: grabbing;
}
</style>
