<template>
  <PublicLayout>
    <div class="public-page">
      <GlobalHero
        title="Our Fleet"
        subtitle="Browse top-rated vehicles available for your next adventure."
        imageUrl="https://images.unsplash.com/photo-1550355291-bbee04a92027?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80"
        altText="Premium car rental fleet parked on a scenic road"
      />

      <BulodSection theme="light" id="fleet" :watermark="true" watermarkVariant="receipt" :padded="true">
        <v-container class="position-relative z-index-2 fleet-section-inner">
          
          <!-- Filter Tabs -->
          <div class="text-center mb-16 scroll-reveal scroll-reveal-up">
            <span class="section-badge mb-4 d-inline-block">The Garage</span>
            <h2 class="text-h3 font-weight-bold mb-8" style="color: var(--trust-blue); letter-spacing: -0.02em;">Find Your Perfect Ride</h2>
            
            <div class="d-flex justify-center flex-wrap" style="gap: 12px;">
              <v-btn 
                v-for="category in categories" 
                :key="category"
                :variant="activeCategory === category ? 'flat' : 'outlined'"
                :color="activeCategory === category ? 'primary' : 'grey-darken-1'"
                rounded="pill"
                size="large"
                class="px-8 text-none font-weight-bold bg-white"
                :class="{'plate-btn': activeCategory === category}"
                @click="activeCategory = category"
                style="letter-spacing: 0.02em;"
              >
                {{ category }}
              </v-btn>
            </div>
          </div>
          
          <!-- Fleet Grid referencing .featured-card-metallic from LandingPage -->
          <v-row class="mb-12">
            <v-col cols="12" sm="6" md="4" v-for="(ride, idx) in filteredRides" :key="idx" class="scroll-reveal scroll-reveal-up mb-6" :style="`transition-delay: ${(idx % 3) * 100}ms`">
              <div class="featured-card featured-card-metallic h-100 d-flex flex-column" data-tilt style="border: 1px solid rgba(0,0,0,0.05);">
                <div class="featured-card-image-wrap" style="aspect-ratio: 16/10;">
                  <span v-if="ride.topPick" class="featured-top-pick bg-primary text-white px-3 py-1 font-weight-bold text-caption rounded-lg" style="position: absolute; top: 12px; left: 12px; z-index: 3; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">Top Pick</span>
                  <v-img
                    :src="ride.image"
                    :alt="ride.name"
                    cover
                    class="featured-card-image h-100 w-100 transition-transform"
                  />
                  <div class="featured-card-type" :style="{ background: ride.color || 'var(--primary-cyan)' }" style="position: absolute; bottom: 0; left: 0; padding: 6px 16px; color: white; font-weight: bold; border-top-right-radius: 12px; font-size: 0.85rem; z-index: 3;">
                    <span>{{ ride.category }}</span>
                  </div>
                  <span class="featured-location" style="position: absolute; top: 12px; right: 12px; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); color: white; padding: 4px 10px; border-radius: 6px; font-size: 0.8rem; z-index: 3; font-weight: 500;">
                    <v-icon icon="mdi-map-marker" size="14" class="mr-1"></v-icon>{{ ride.location }}
                  </span>
                </div>
                
                <div class="featured-card-body flex-grow-1 d-flex flex-column pa-6 bg-white" style="border-bottom-left-radius: 16px; border-bottom-right-radius: 16px;">
                  <h3 class="text-h6 font-weight-bold mb-1" style="color: var(--trust-blue); letter-spacing: -0.01em;">{{ ride.name }}</h3>
                  <p class="featured-card-vehicles text-caption font-weight-bold text-primary text-uppercase tracking-wide mb-3">{{ ride.specs }}</p>
                  <p class="text-body-2 text-grey-darken-2 mb-6 flex-grow-1" style="line-height: 1.6;">{{ ride.description }}</p>
                  
                  <v-divider class="mb-4" style="opacity: 0.15; border-color: var(--trust-blue);"></v-divider>
                  
                  <div class="d-flex justify-space-between align-center mt-auto">
                    <div class="featured-price-row d-flex align-end">
                      <span class="text-h5 font-weight-bold text-primary" style="line-height: 1;">₱{{ ride.price.toLocaleString() }}</span>
                      <span class="text-caption text-grey-darken-1 ml-1 font-weight-medium">/day</span>
                    </div>
                    <v-btn
                      color="action"
                      variant="flat"
                      rounded="pill"
                      class="plate-btn px-6 text-none font-weight-bold shadow-hover"
                      @click="$router.push('/login')"
                    >
                      Book Now
                    </v-btn>
                  </div>
                </div>
              </div>
            </v-col>
            
            <v-col v-if="filteredRides.length === 0" cols="12" class="text-center py-16">
              <v-icon icon="mdi-car-off" size="64" color="grey-lighten-1" class="mb-4"></v-icon>
              <h3 class="text-h5 font-weight-bold text-grey-darken-1">No vehicles found in this category.</h3>
              <p class="text-body-1 text-grey">Try selecting a different filter above.</p>
            </v-col>
          </v-row>
          
          <div v-if="filteredRides.length > 0" class="text-center mt-8 scroll-reveal scroll-reveal-up">
            <v-btn color="primary" variant="outlined" size="x-large" rounded="pill" class="px-8 bg-white border-primary font-weight-bold shadow-hover">Load More Vehicles</v-btn>
          </div>
        </v-container>
      </BulodSection>

      <!-- List Your Fleet – for car rental owners -->
      <section class="fleet-owner-cta" id="list-your-fleet">
        <div class="fleet-owner-cta__inner">
          <div class="fleet-owner-cta__grid scroll-reveal scroll-reveal-up">
            <div class="fleet-owner-cta__media">
              <img
                src="/images/fleet-owner-cta.png"
                alt="BulodPH – Car rental owner with dashboard. Showcase your fleet to the entire region. More visibility, more bookings, more income."
                class="fleet-owner-cta__img"
                loading="lazy"
                decoding="async"
              />
            </div>
            <div class="fleet-owner-cta__content">
              <span class="fleet-owner-cta__badge">For owners</span>
              <h2 class="fleet-owner-cta__title">Are you a <span class="fleet-owner-cta__accent">car rental owner?</span></h2>
              <p class="fleet-owner-cta__lead">Showcase your fleet to the entire region. Get more visibility, more bookings, and more income—all on one platform.</p>
              <ul class="fleet-owner-cta__benefits">
                <li><v-icon icon="mdi-check-circle" size="20" color="success" /> More visibility</li>
                <li><v-icon icon="mdi-check-circle" size="20" color="success" /> More bookings</li>
                <li><v-icon icon="mdi-check-circle" size="20" color="success" /> More income</li>
              </ul>
              <p class="fleet-owner-cta__tagline text-body-2 font-weight-medium mb-4">One platform. Unlimited opportunities.</p>
              <v-btn
                :to="ROUTES.register"
                color="error"
                size="x-large"
                rounded="pill"
                class="fleet-owner-cta__btn font-weight-bold px-8"
                elevation="0"
              >
                Register your fleet
              </v-btn>
            </div>
          </div>
        </div>
      </section>
    </div>
  </PublicLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import PublicLayout from '@/layouts/PublicLayout.vue'
import GlobalHero from '@/components/GlobalHero.vue'
import BulodSection from '@/components/ui/BulodSection.vue'
import { ROUTES } from '@/constants/siteUrls'

const categories = ['All Cars', 'Economy Sedan', 'SUV & 4x4', 'Vans & MPV', 'Premium']
const activeCategory = ref('All Cars')

const fleetData = [
  {
    name: 'Toyota Vios 1.3 XLE',
    category: 'Economy Sedan',
    specs: '5 Seats • Auto • Petrol',
    location: 'Cauayan, Isabela',
    description: 'Perfect for city driving and quick errands. Excellent fuel economy, reliable cooling, and smooth comfort.',
    price: 1500,
    image: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: true,
    color: '#38bdf8'
  },
  {
    name: 'Mitsubishi Montero Sport',
    category: 'SUV & 4x4',
    specs: '7 Seats • Auto • Diesel',
    location: 'Santiago City',
    description: 'Tackle any Philippine terrain with this powerful and spacious family SUV. Features full off-road capabilities.',
    price: 3500,
    image: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: false,
    color: '#0ea5e9'
  },
  {
    name: 'Toyota Hiace Grandia',
    category: 'Vans & MPV',
    specs: '12 Seats • Manual • Diesel',
    location: 'Ilagan, Isabela',
    description: 'The ultimate group travel vehicle. Ideal for family out of town trips, corporate events, and long distances.',
    price: 4500,
    image: 'https://images.unsplash.com/photo-1579899381622-d04b68ff0dc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: true,
    color: '#0284c7'
  },
  {
    name: 'Honda Civic RS',
    category: 'Premium',
    specs: '5 Seats • Auto • Petrol',
    location: 'Cauayan, Isabela',
    description: 'Travel in ultimate style with this sleek, sporty, and fully-loaded premium sedan. Fast and extremely comfortable.',
    price: 2800,
    image: 'https://images.unsplash.com/photo-1590362891991-f766e54ee758?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: false,
    color: '#0369a1'
  },
  {
    name: 'Toyota Innova 2.8 E',
    category: 'Vans & MPV',
    specs: '8 Seats • Auto • Diesel',
    location: 'Tuguegarao, Cagayan',
    description: 'Reliable, spacious, and comfortable. The Philippines favorite MPV for medium-sized families.',
    price: 2500,
    image: 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: false,
    color: '#0284c7'
  },
  {
    name: 'Ford Everest Titanium',
    category: 'SUV & 4x4',
    specs: '7 Seats • Auto • Diesel',
    location: 'Santiago City',
    description: 'Premium technology, luxury leather interiors, a panoramic sunroof, and heavy-duty towing performance.',
    price: 4000,
    image: 'https://images.unsplash.com/photo-1620958189510-91bf5938fcf8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    topPick: true,
    color: '#0ea5e9'
  }
]

const filteredRides = computed(() => {
  if (activeCategory.value === 'All Cars') return fleetData
  return fleetData.filter(ride => ride.category === activeCategory.value)
})

onMounted(() => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-revealed')
        observer.unobserve(entry.target)
      }
    })
  }, { threshold: 0.1 })
  
  document.querySelectorAll('.scroll-reveal').forEach(el => observer.observe(el))
})
</script>

<style scoped>
.public-page {
  background-color: #f8fafc;
  min-height: 100vh;
}
.fleet-section-inner {
  position: relative;
}
.fleet-section-inner::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: repeat;
  background-size: min(16%, 100px);
  opacity: 0.05;
  pointer-events: none;
  z-index: 0;
  filter: grayscale(100%) brightness(200%);
}
.fleet-section-inner > * {
  position: relative;
  z-index: 1;
}
.page-container {
  max-width: 1200px;
}
.tracking-wide {
  letter-spacing: 0.05em;
}
.featured-card {
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.3s ease;
}
.featured-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0,0,0,0.12) !important;
}
.transition-transform {
  transition: transform 0.5s ease;
}
.featured-card:hover .transition-transform {
  transform: scale(1.05);
}
.shadow-hover {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.shadow-hover:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(14, 165, 233, 0.3);
}

/* List Your Fleet – owner CTA (matches ad: blue, yellow, red CTA) */
.fleet-owner-cta {
  position: relative;
  padding: 4rem 1.5rem;
  background: linear-gradient(135deg, #0f172a 0%, #1e3a5f 40%, #0f172a 100%);
  overflow: hidden;
}
.fleet-owner-cta__inner {
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}
.fleet-owner-cta__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}
.fleet-owner-cta__media {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 24px 48px rgba(0, 0, 0, 0.35);
  background: #1e293b;
}
.fleet-owner-cta__img {
  width: 100%;
  height: auto;
  display: block;
  vertical-align: middle;
}
.fleet-owner-cta__content {
  padding: 1.5rem 0;
}
.fleet-owner-cta__badge {
  display: inline-block;
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  color: #fbbf24;
  margin-bottom: 0.75rem;
}
.fleet-owner-cta__title {
  font-size: clamp(1.75rem, 3.2vw, 2.35rem);
  font-weight: 800;
  letter-spacing: -0.02em;
  line-height: 1.2;
  color: #ffffff;
  margin: 0 0 1rem 0;
}
.fleet-owner-cta__accent {
  color: #fbbf24;
}
.fleet-owner-cta__lead {
  font-size: 1rem;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 1.25rem 0;
}
.fleet-owner-cta__benefits {
  list-style: none;
  padding: 0;
  margin: 0 0 1rem 0;
  display: grid;
  gap: 0.5rem;
}
.fleet-owner-cta__benefits li {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #fff;
}
.fleet-owner-cta__tagline {
  color: rgba(255, 255, 255, 0.85) !important;
}
.fleet-owner-cta__btn {
  text-transform: none;
  letter-spacing: 0.02em;
}
@media (max-width: 900px) {
  .fleet-owner-cta__grid {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  .fleet-owner-cta__media {
    order: -1;
    max-width: 480px;
    margin: 0 auto;
  }
}
@media (max-width: 600px) {
  .fleet-owner-cta {
    padding: 2.5rem 1rem;
  }
  .fleet-owner-cta__title {
    font-size: clamp(1.5rem, 5vw, 1.9rem);
  }
}
</style>
