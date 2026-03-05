<template>
  <Teleport to="body">
    <Transition name="palette-fade">
      <div
        v-if="visible"
        class="hpa-command-palette"
        @click.self="close"
      >
        <div class="hpa-command-palette__panel">
          <div class="hpa-command-palette__input-wrap">
            <v-icon icon="mdi-magnify" size="20" class="hpa-command-palette__search-icon" />
            <input
              ref="inputRef"
              v-model="query"
              type="text"
              placeholder="Type a command..."
              class="hpa-command-palette__input"
              @keydown.esc="close"
              @keydown.down.prevent="moveSelection(1)"
              @keydown.up.prevent="moveSelection(-1)"
              @keydown.enter.prevent="executeSelected"
            />
          </div>
          <div class="hpa-command-palette__list">
            <button
              v-for="(item, idx) in filteredItems"
              :key="item.id"
              type="button"
              class="hpa-command-palette__item"
              :class="{ 'hpa-command-palette__item--selected': idx === selectedIndex }"
              @click="runItem(item)"
            >
              <v-icon :icon="item.icon" size="20" />
              <span>{{ item.label }}</span>
            </button>
            <div v-if="filteredItems.length === 0" class="hpa-command-palette__empty">
              No results
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'

export interface CommandItem {
  id: string
  label: string
  icon: string
  action: () => void
}

const props = defineProps<{
  modelValue: boolean
  items: CommandItem[]
}>()

const emit = defineEmits<{ 'update:modelValue': [v: boolean] }>()

const visible = computed({
  get: () => props.modelValue,
  set: (v) => emit('update:modelValue', v),
})

const query = ref('')
const selectedIndex = ref(0)
const inputRef = ref<HTMLInputElement | null>(null)

const filteredItems = computed(() => {
  const q = query.value.toLowerCase().trim()
  if (!q) return props.items
  return props.items.filter(
    (i) => i.label.toLowerCase().includes(q) || i.id.toLowerCase().includes(q)
  )
})

watch(visible, (v) => {
  if (v) {
    query.value = ''
    selectedIndex.value = 0
    setTimeout(() => inputRef.value?.focus(), 50)
  }
})

watch(filteredItems, () => {
  selectedIndex.value = 0
})

function moveSelection(delta: number) {
  const len = filteredItems.value.length
  if (len === 0) return
  selectedIndex.value = (selectedIndex.value + delta + len) % len
}

function executeSelected() {
  const item = filteredItems.value[selectedIndex.value]
  if (item) runItem(item)
}

function runItem(item: CommandItem) {
  item.action()
  close()
}

function close() {
  visible.value = false
}

// Global shortcuts: Ctrl+K / Cmd+K, or / (when not typing in input)
function onKeyDown(e: KeyboardEvent) {
  if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
    e.preventDefault()
    visible.value = !visible.value
    return
  }
  if (e.key === '/' && !e.ctrlKey && !e.metaKey && !e.altKey) {
    const target = e.target as HTMLElement
    const isInput = target.tagName === 'INPUT' || target.tagName === 'TEXTAREA' || target.isContentEditable
    if (!isInput) {
      e.preventDefault()
      visible.value = !visible.value
    }
  }
}

onMounted(() => {
  window.addEventListener('keydown', onKeyDown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', onKeyDown)
})
</script>

<style scoped>
.hpa-command-palette {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding-top: 15vh;
  background: rgba(15, 23, 42, 0.4);
  backdrop-filter: blur(4px);
}

.hpa-command-palette__panel {
  width: 100%;
  max-width: 480px;
  background: var(--glass-bg-strong, rgba(255, 255, 255, 0.95));
  border-radius: var(--radius-lg, 16px);
  box-shadow: var(--shadow-modal);
  overflow: hidden;
}

.hpa-command-palette__input-wrap {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  border-bottom: 1px solid var(--border-subtle, #e2e8f0);
}

.hpa-command-palette__search-icon {
  color: var(--text-muted, #94a3b8);
}

.hpa-command-palette__input {
  flex: 1;
  border: none;
  outline: none;
  font-size: var(--text-body-lg, 1rem);
  background: transparent;
}

.hpa-command-palette__input::placeholder {
  color: var(--text-muted, #94a3b8);
}

.hpa-command-palette__list {
  max-height: 320px;
  overflow-y: auto;
  padding: 0.5rem;
}

.hpa-command-palette__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  width: 100%;
  padding: 0.75rem 1rem;
  border: none;
  background: transparent;
  border-radius: var(--radius-md, 12px);
  font-size: var(--text-body, 0.9375rem);
  color: var(--text-primary, #1f2937);
  cursor: pointer;
  text-align: left;
  transition: background var(--transition-fast);
}

.hpa-command-palette__item:hover,
.hpa-command-palette__item--selected {
  background: var(--surface-2, #f1f5f9);
}

.hpa-command-palette__empty {
  padding: 1.5rem;
  text-align: center;
  color: var(--text-muted, #94a3b8);
  font-size: var(--text-sm, 0.8125rem);
}

.palette-fade-enter-active,
.palette-fade-leave-active {
  transition: opacity 0.2s ease;
}

.palette-fade-enter-from,
.palette-fade-leave-to {
  opacity: 0;
}
</style>
