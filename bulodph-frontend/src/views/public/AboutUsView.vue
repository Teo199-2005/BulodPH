<template>
  <PublicLayout>
    <div class="public-page">
      <GlobalHero
        title="About BulodPH"
        subtitle="Car rental marketplace connecting communities across the Philippines."
        imageUrl="https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80"
        altText="Team working together on a journey"
      />

      <!-- Our Story Section -->
      <BulodSection theme="light" id="about-story" :watermark="true" watermarkVariant="about" :padded="true">
        <BulodMetallicCard class="py-12 px-6 px-md-12 rounded-xl elevation-3 about-story-card-watermark">
          <v-row align="center">
            <v-col cols="12" md="6" class="scroll-reveal scroll-reveal-up">
              <span class="section-badge mb-4 d-inline-block">Our Story</span>
              <h2 class="text-h3 font-weight-bold mb-6" style="color: var(--trust-blue); letter-spacing: -0.02em;">
                Bridging the Gap in <span class="title-accent">Local Mobility</span>
              </h2>
              <p class="text-body-1 mb-4 text-grey-darken-2" style="font-size: 1.1rem; line-height: 1.7;">
                BulodPH was founded with a simple goal: to make mobility accessible, reliable, and deeply rooted in the community. We bridge the gap between car owners who want to earn extra income and travelers seeking a trustworthy ride in the Philippines.
              </p>
              <p class="text-body-1 mb-8 text-grey-darken-2" style="font-size: 1.1rem; line-height: 1.7;">
                From the bustling streets of Manila to scenic routes across the region, our platform ensures verified rentals, transparent pricing, and 24/7 support.
              </p>
              <v-row class="mt-4">
                <v-col cols="6">
                  <div class="text-h4 font-weight-bold text-primary mb-1">2026</div>
                  <div class="text-body-2 text-grey-darken-1 text-uppercase font-weight-bold tracking-wide">Year Founded</div>
                </v-col>
                <v-col cols="6">
                  <div class="text-h4 font-weight-bold text-primary mb-1">100%</div>
                  <div class="text-body-2 text-grey-darken-1 text-uppercase font-weight-bold tracking-wide">Local Support</div>
                </v-col>
              </v-row>
            </v-col>
            <v-col cols="12" md="6" class="mt-8 mt-md-0 scroll-reveal scroll-reveal-up" style="transition-delay: 150ms">
              <div class="about-image-wrap rounded-xl overflow-hidden elevation-10" style="aspect-ratio: 4/3; position: relative;">
                <v-img
                  src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
                  alt="Team collaborating"
                  cover
                  class="h-100 w-100"
                ></v-img>
                <div class="position-absolute d-flex align-center justify-center" style="bottom: -20px; left: -20px; background: white; padding: 20px 30px; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); z-index: 5;">
                   <v-icon icon="mdi-handshake" color="primary" size="32" class="mr-3"></v-icon>
                   <span class="text-h6 font-weight-bold" style="color: var(--trust-blue);">Trusted Partner</span>
                </div>
              </div>
            </v-col>
          </v-row>
        </BulodMetallicCard>
      </BulodSection>

      <!-- Core Values -->
      <BulodSection theme="navy" id="values" :watermark="true" watermarkVariant="about" :padded="true">
        <v-container class="position-relative z-index-2">
          <div class="text-center mb-16 scroll-reveal scroll-reveal-up">
            <span class="section-badge bg-white text-primary mb-4 d-inline-block">The Foundation</span>
            <h2 class="text-h3 font-weight-bold mb-4" style="letter-spacing: -0.02em;">Our Core Values</h2>
            <p class="text-subtitle-1 opacity-80" style="max-width: 600px; margin: 0 auto; line-height: 1.6;">The principles that drive us to provide the safest and most reliable car-sharing experience across the Philippines.</p>
          </div>
          
          <v-row>
            <v-col cols="12" md="4" v-for="(value, idx) in coreValues" :key="idx" class="scroll-reveal scroll-reveal-up" :style="`transition-delay: ${idx * 150}ms`">
              <v-card class="h-100 rounded-xl value-card" color="rgba(255,255,255,0.03)" elevation="0" style="border: 1px solid rgba(255,255,255,0.08); backdrop-filter: blur(10px);">
                <v-card-text class="pa-8">
                  <div class="value-icon-wrap mb-6">
                    <component :is="value.icon" :size="32" class="text-primary" />
                  </div>
                  <h3 class="text-h5 font-weight-bold mb-4 text-white" style="letter-spacing: -0.01em;">{{ value.title }}</h3>
                  <p class="text-body-1 text-grey-lighten-2" style="line-height: 1.7">{{ value.description }}</p>
                </v-card-text>
              </v-card>
            </v-col>
          </v-row>
        </v-container>
      </BulodSection>

      <!-- Meet the Team -->
      <BulodSection theme="light" id="team" :watermark="true" watermarkVariant="about" :padded="true">
        <v-container>
          <div class="text-center mb-16 scroll-reveal scroll-reveal-up">
            <span class="section-badge mb-4 d-inline-block">Leadership</span>
            <h2 class="text-h3 font-weight-bold mb-4" style="color: var(--trust-blue); letter-spacing: -0.02em;">Meet the Team</h2>
            <p class="text-subtitle-1 text-grey-darken-1" style="max-width: 600px; margin: 0 auto; line-height: 1.6;">Dedicated professionals bringing reliable mobility to isolated towns and bustling cities alike.</p>
          </div>
          
          <v-row class="justify-center">
            <v-col cols="12" sm="6" md="3" v-for="(member, idx) in team" :key="idx" class="text-center scroll-reveal scroll-reveal-up" :style="`transition-delay: ${idx * 100}ms`">
              <v-avatar size="160" class="elevation-5 mb-6 mx-auto team-avatar">
                <v-img :src="member.image" :alt="member.name" cover></v-img>
              </v-avatar>
              <h4 class="text-h6 font-weight-bold mb-1" style="color: var(--trust-blue); letter-spacing: -0.01em;">{{ member.name }}</h4>
              <p class="text-primary font-weight-medium text-body-2 text-uppercase tracking-wide mb-3">{{ member.role }}</p>
              <div class="d-flex justify-center" style="gap: 8px;">
                <v-btn icon="mdi-linkedin" variant="text" size="small" color="grey-darken-1" class="social-hover"></v-btn>
                <v-btn icon="mdi-twitter" variant="text" size="small" color="grey-darken-1" class="social-hover"></v-btn>
              </div>
            </v-col>
          </v-row>
        </v-container>
      </BulodSection>

      <!-- CTA Section using metallic container -->
      <BulodSection class="mb-16" :watermark="true" watermarkVariant="about" :padded="true">
        <BulodMetallicCard elevation="6" :innerWatermark="true" padding="pa-4 pa-md-8" class="mx-4 mx-md-auto text-center scroll-reveal scroll-reveal-up" style="max-width: 1000px;">
          <h2 class="text-h3 font-weight-bold mb-6" style="color: var(--trust-blue); letter-spacing: -0.02em;">Ready to start your journey?</h2>
          <p class="text-h6 text-grey-darken-1 mb-8" style="max-width: 600px; margin: 0 auto; line-height: 1.5;">Join thousands of verified users renting and hosting cars today. Safe, secure, and incredibly simple.</p>
          <div class="d-flex justify-center flex-wrap" style="gap: 16px;">
            <v-btn color="action" size="x-large" rounded="pill" class="plate-btn px-8 font-weight-bold shadow-hover" to="/fleet">Rent a Car</v-btn>
            <v-btn color="grey-darken-4" size="x-large" rounded="pill" class="px-8 text-white font-weight-bold shadow-hover" to="/register">List Your Vehicle</v-btn>
          </div>
        </BulodMetallicCard>
      </BulodSection>

    </div>
  </PublicLayout>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import PublicLayout from '@/layouts/PublicLayout.vue'
import GlobalHero from '@/components/GlobalHero.vue'
import BulodSection from '@/components/ui/BulodSection.vue'
import BulodMetallicCard from '@/components/ui/BulodMetallicCard.vue'
import { ShieldCheck, HeartHandshake, MapPin } from 'lucide-vue-next'

const coreValues = [
  {
    icon: ShieldCheck,
    title: 'Trust & Safety',
    description: 'Every user is verified, every vehicle is checked, and every ride is monitored for your peace of mind. Safety is our non-negotiable priority.'
  },
  {
    icon: HeartHandshake,
    title: 'Community First',
    description: 'We believe in empowering local car owners and providing travelers with friendly, authentic local experiences you won\'t get from traditional agencies.'
  },
  {
    icon: MapPin,
    title: 'Accessible Mobility',
    description: 'We are expanding beyond major cities to ensure reliable transportation is accessible even in provincial towns and off-the-beaten-path destinations.'
  }
]

const team = [
  {
    name: 'Juan Dela Cruz',
    role: 'Founder & CEO',
    image: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Maria Santos',
    role: 'Head of Operations',
    image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Carlos Reyes',
    role: 'Trust & Safety Lead',
    image: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Ana Lim',
    role: 'Community Manager',
    image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'
  }
]

onMounted(() => {
  // Simple intersection observer to trigger manual scroll reveals if GSAP is not bound
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
.about-story-card-watermark {
  position: relative;
}
.about-story-card-watermark::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url('/logo.png');
  background-repeat: repeat;
  background-size: min(14%, 80px);
  opacity: 0.06;
  pointer-events: none;
  z-index: 0;
  filter: grayscale(100%) brightness(200%);
}
.about-story-card-watermark .position-relative.z-index-2 {
  position: relative;
  z-index: 1;
}
.tracking-wide {
  letter-spacing: 0.05em;
}
.value-icon-wrap {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  background: rgba(14, 165, 233, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(14, 165, 233, 0.3);
}
.value-card {
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), background 0.3s ease;
}
.value-card:hover {
  transform: translateY(-8px);
  background: rgba(255,255,255,0.06) !important;
  border-color: rgba(14, 165, 233, 0.4) !important;
}
.team-avatar {
  border: 4px solid white;
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.team-avatar:hover {
  transform: scale(1.08) rotate(2deg);
  border-color: var(--primary-cyan);
}
.social-hover {
  transition: color 0.2s ease, transform 0.2s ease;
}
.social-hover:hover {
  color: var(--primary-cyan) !important;
  transform: translateY(-2px);
}
.shadow-hover {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.shadow-hover:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.15);
}
</style>
