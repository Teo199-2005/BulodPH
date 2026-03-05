// Vitest setup file
import { config } from '@vue/test-utils'

// Add global mocks, components, or plugins here if needed
config.global.mocks = {
    $t: (msg: string) => msg
}
