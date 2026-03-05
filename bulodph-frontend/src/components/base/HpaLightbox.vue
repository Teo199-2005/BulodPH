<template>
  <Teleport to="body">
    <Transition name="lightbox">
      <div
        v-if="visible"
        class="hpa-lightbox"
        role="dialog"
        aria-modal="true"
        aria-label="Image preview"
        @click.self="close"
      >
        <button
          class="hpa-lightbox__close"
          aria-label="Close"
          @click="close"
        >
          <v-icon icon="mdi-close" size="24" />
        </button>
        <img
          :src="src"
          :alt="alt"
          class="hpa-lightbox__img"
          @click.stop
        />
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
  src: string
  alt?: string
}>()

const emit = defineEmits<{ close: [] }>()

function close() {
  emit('close')
}

// Close on Escape
defineExpose({
  close,
})
</script>

<style scoped>
.hpa-lightbox {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(15, 23, 42, 0.9);
  backdrop-filter: blur(8px);
}

.hpa-lightbox__close {
  position: absolute;
  top: var(--space-4, 16px);
  right: var(--space-4, 16px);
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.15);
  color: #fff;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition-fast);
}

.hpa-lightbox__close:hover {
  background: rgba(255, 255, 255, 0.25);
}

.hpa-lightbox__img {
  max-width: 90vw;
  max-height: 90vh;
  object-fit: contain;
  border-radius: var(--radius-md, 12px);
}

.lightbox-enter-active,
.lightbox-leave-active {
  transition: opacity 0.2s ease;
}

.lightbox-enter-from,
.lightbox-leave-to {
  opacity: 0;
}
</style>
