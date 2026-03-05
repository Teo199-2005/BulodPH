<template>
  <span>{{ displayValue }}</span>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'

interface Props {
  value: number | string
  duration?: number
  decimals?: number
  prefix?: string
  suffix?: string
}

const props = withDefaults(defineProps<Props>(), {
  duration: 1000,
  decimals: 0,
  prefix: '',
  suffix: '',
})

const displayValue = ref<string>('0')

const formatNumber = (num: number): string => {
  const formatted = num.toFixed(props.decimals)
  return `${props.prefix}${formatted}${props.suffix}`
}

const animateValue = (start: number, end: number, duration: number) => {
  const startTime = Date.now()
  
  const animate = () => {
    const now = Date.now()
    const progress = Math.min((now - startTime) / duration, 1)
    
    // Ease out quad function for smooth animation
    const easeOutQuad = progress * (2 - progress)
    const currentValue = start + (end - start) * easeOutQuad
    
    displayValue.value = formatNumber(currentValue)
    
    if (progress < 1) {
      requestAnimationFrame(animate)
    } else {
      displayValue.value = formatNumber(end)
    }
  }
  
  animate()
}

const parseValue = (val: number | string): number => {
  if (typeof val === 'string') {
    // Remove non-numeric characters except decimal point
    const cleaned = val.replace(/[^0-9.-]/g, '')
    return parseFloat(cleaned) || 0
  }
  return val
}

watch(() => props.value, (newVal) => {
  const currentNum = parseValue(displayValue.value)
  const targetNum = parseValue(newVal)
  animateValue(currentNum, targetNum, props.duration)
})

onMounted(() => {
  const targetNum = parseValue(props.value)
  animateValue(0, targetNum, props.duration)
})
</script>

