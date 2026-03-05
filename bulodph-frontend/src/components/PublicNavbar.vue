<template>
  <div>
    <!-- Navigation Bar -->
    <v-app-bar
      elevation="0"
      class="navbar-modern"
      :class="{ 'navbar-scrolled': isScrolled }"
      :height="70"
      fixed
      app
    >
      <v-container class="d-flex align-center py-2 h-100">
        <router-link to="/" class="d-flex align-center logo-container logo-link logo-wrap">
          <img src="/logo.png" alt="BulodPH" class="logo-img" />
        </router-link>

        <v-spacer />

        <div class="nav-links d-none d-lg-flex align-center">
          <v-btn variant="text" class="nav-link" to="/">Home</v-btn>
          <v-btn variant="text" class="nav-link" to="/about">About Us</v-btn>
          <v-btn variant="text" class="nav-link" to="/fleet">Car-Rental</v-btn>
          <v-btn variant="text" class="nav-link" to="/blog">Blog</v-btn>
          <v-btn variant="text" class="nav-link" to="/contact">Contact Us</v-btn>
          <v-btn variant="text" class="nav-link" to="/faq">FAQ</v-btn>
        </div>

        <div class="nav-cta d-flex align-center ml-4">
          <v-btn variant="outlined" class="login-btn" rounded="lg" @click="$router.push('/login')">Login</v-btn>
          <v-btn class="trial-btn ml-2" elevation="0" rounded="lg" @click="$router.push('/register')">Register</v-btn>
        </div>

        <!-- Mobile Menu Toggle -->
        <button
          type="button"
          class="d-lg-none ml-2 mobile-menu-toggle"
          :class="{ 'is-open': mobileMenu }"
          :aria-label="mobileMenu ? 'Close menu' : 'Open menu'"
          @click.stop.prevent="toggleMobileMenu"
        >
          <v-icon :icon="mobileMenu ? 'mdi-close' : 'mdi-menu'" size="22" />
        </button>
      </v-container>
    </v-app-bar>

    <!-- Mobile Menu Modal -->
    <v-dialog v-model="mobileMenu" width="340" transition="scale-transition">
      <v-card class="mobile-menu-modal">
        <div class="mobile-menu-modal__header">
          <div class="mobile-menu-modal__title">Menu</div>
          <button type="button" class="mobile-menu-modal__close" aria-label="Close menu" @click="mobileMenu = false">
            <v-icon icon="mdi-close" size="20" />
          </button>
        </div>
        <div class="mobile-menu-modal__grid">
          <router-link class="mobile-menu-tile" to="/" @click="mobileMenu = false">
            <v-icon icon="mdi-home-outline" size="22" />
            <span>Home</span>
          </router-link>
          <router-link class="mobile-menu-tile" to="/about" @click="mobileMenu = false">
            <v-icon icon="mdi-information-outline" size="22" />
            <span>About Us</span>
          </router-link>
          <router-link class="mobile-menu-tile" to="/fleet" @click="mobileMenu = false">
            <v-icon icon="mdi-car-outline" size="22" />
            <span>Car-Rental</span>
          </router-link>
          <router-link class="mobile-menu-tile" to="/blog" @click="mobileMenu = false">
            <v-icon icon="mdi-post-outline" size="22" />
            <span>Blog</span>
          </router-link>
          <router-link class="mobile-menu-tile" to="/contact" @click="mobileMenu = false">
            <v-icon icon="mdi-phone-outline" size="22" />
            <span>Contact Us</span>
          </router-link>
          <router-link class="mobile-menu-tile" to="/faq" @click="mobileMenu = false">
            <v-icon icon="mdi-help-circle-outline" size="22" />
            <span>FAQ</span>
          </router-link>
          <button class="mobile-menu-tile" type="button" @click="$router.push('/login'); mobileMenu = false">
            <v-icon icon="mdi-login" size="22" />
            <span>Login</span>
          </button>
          <button class="mobile-menu-tile" type="button" @click="$router.push('/register'); mobileMenu = false">
            <v-icon icon="mdi-account-plus-outline" size="22" />
            <span>Register</span>
          </button>
        </div>
      </v-card>
    </v-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const isScrolled = ref(false)
const mobileMenu = ref(false)

const toggleMobileMenu = () => {
  mobileMenu.value = !mobileMenu.value
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* Copied and adapted from LandingPage.vue */
.navbar-modern {
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(226, 232, 240, 0.8);
  transition: background-color 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
  position: relative;
  will-change: background-color, box-shadow;
}

.navbar-scrolled {
  background: rgba(255, 255, 255, 0.98) !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.logo-wrap {
  padding: 6px 12px;
  border-radius: 10px;
  background: transparent;
  align-items: center;
  display: inline-flex;
}

.logo-img {
  height: 44px;
  width: auto;
  max-width: 120px;
  object-fit: contain;
  display: block;
}

.nav-links {
  gap: 0.25rem 0.5rem;
}

.nav-links .nav-link {
  font-weight: 600;
  text-transform: none;
  letter-spacing: 0.025em;
  transition: all 0.3s ease;
  position: relative;
  color: #334155 !important;
}

.nav-links .nav-link:hover {
  color: var(--sky-600) !important;
}

.login-btn {
  background: transparent !important;
  border: 1.5px solid #334155 !important;
  color: #0f172a !important;
  font-weight: 600;
}

.trial-btn {
  background: linear-gradient(180deg, var(--primary-cyan) 0%, var(--sky-600) 100%) !important;
  color: #ffffff !important;
  font-weight: 700;
}

.mobile-menu-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  width: 44px;
  height: 44px;
  border-radius: 14px;
  border: 1px solid rgba(15, 23, 42, 0.14);
  background: rgba(248, 250, 252, 0.95);
  box-shadow: 0 10px 20px rgba(15, 23, 42, 0.12), 0 0 0 1px rgba(255, 255, 255, 0.5) inset;
  color: #0f172a;
  cursor: pointer;
}

.mobile-menu-modal {
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid rgba(226, 232, 240, 0.9);
  box-shadow: 0 24px 50px rgba(15, 23, 42, 0.2);
}

.mobile-menu-modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 18px 10px;
}

.mobile-menu-modal__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  padding: 10px 16px 18px;
}

.mobile-menu-tile {
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  border-radius: 16px;
  padding: 14px 8px;
  min-height: 76px;
  border: 1px solid rgba(226, 232, 240, 0.9);
  background: rgba(248, 250, 252, 0.9);
  color: var(--trust-blue, #0f172a);
  font-weight: 600;
  font-size: 0.85rem;
}
</style>
