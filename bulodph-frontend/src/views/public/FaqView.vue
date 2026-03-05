<template>
  <PublicLayout>
    <div class="public-page">
      <GlobalHero
        title="Common Questions"
        subtitle="Find quick answers about booking, listing your vehicle, payments, and policies."
        imageUrl="https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80"
        altText="Friendly customer support staff helping users"
      />

      <BulodSection theme="light" id="faq" :watermark="true" watermarkVariant="receipt" :padded="true" class="bg-surface-light">
        <v-container class="position-relative z-index-2 faq-section-inner">
          <v-row>
            <v-col cols="12" md="10" lg="9" class="mx-auto">
              
              <!-- Category Badges -->
              <div class="text-center mb-16 scroll-reveal scroll-reveal-up">
                <span class="section-badge mb-4 d-inline-block">Support Hub</span>
                <h2 class="text-h3 font-weight-bold mb-8" style="color: var(--trust-blue); letter-spacing: -0.02em;">How can we help?</h2>
                <div class="d-flex justify-center flex-wrap" style="gap: 12px;">
                  <v-btn 
                    v-for="cat in faqCategories" 
                    :key="cat"
                    :variant="activeCategory === cat ? 'flat' : 'outlined'"
                    :color="activeCategory === cat ? 'primary' : 'grey-darken-1'"
                    rounded="pill"
                    size="large"
                    class="px-8 text-none font-weight-bold bg-white"
                    :class="{'plate-btn text-white': activeCategory === cat}"
                    @click="activeCategory = cat"
                    style="letter-spacing: 0.02em; border-width: 1px;"
                  >
                    {{ cat }}
                  </v-btn>
                </div>
              </div>
              
              <!-- Rich Accordions within a metallic container -->
              <BulodMetallicCard padding="pa-3 pa-md-8" elevation="10" class="scroll-reveal scroll-reveal-up faq-accordion-watermark" style="transition-delay: 150ms; border: 1px solid rgba(14, 165, 233, 0.2);" :innerWatermark="true">
                
                <h3 class="text-h5 font-weight-bold mb-6 text-center" style="color: var(--trust-blue); position: relative; z-index: 2;">{{ activeCategory }}</h3>
                
                <v-expansion-panels variant="accordion" class="custom-panels" elevation="0" style="position: relative; z-index: 2;">
                  <v-expansion-panel v-for="(item, i) in filteredFaqs" :key="i" class="mb-4 border rounded-xl overflow-hidden faq-panel">
                    <v-expansion-panel-title class="font-weight-bold text-h6 py-5 px-6 faq-title">
                      {{ item.question }}
                      <template v-slot:actions="{ expanded }">
                        <v-icon :icon="expanded ? 'mdi-minus' : 'mdi-plus'" :color="expanded ? 'primary' : 'grey-darken-1'" size="28"></v-icon>
                      </template>
                    </v-expansion-panel-title>
                    <v-expansion-panel-text class="text-body-1 text-grey-darken-2 pt-2 pb-8 px-6 faq-text bg-white" style="line-height: 1.7; font-size: 1.05rem;">
                      {{ item.answer }}
                    </v-expansion-panel-text>
                  </v-expansion-panel>
                </v-expansion-panels>
                
                <div v-if="filteredFaqs.length === 0" class="text-center py-16 bg-white rounded-xl elevation-2 position-relative z-index-2">
                  <v-icon icon="mdi-magnify" size="64" color="grey-lighten-2" class="mb-4"></v-icon>
                  <h3 class="text-h5 font-weight-bold text-grey-darken-1">No questions found.</h3>
                  <p class="text-body-1 text-grey">Select another category to view related content.</p>
                </div>
              </BulodMetallicCard>

              <!-- Still Have Questions CTA -->
              <div class="text-center mt-16 scroll-reveal scroll-reveal-up pt-8">
                <div class="d-inline-flex flex-column align-center bg-white pa-10 rounded-xl elevation-4" style="border: 2px solid rgba(14, 165, 233, 0.1);">
                  <div class="bg-primary-lighten-5 px-6 py-4 rounded-pill mb-6 d-flex align-center">
                    <v-avatar size="40" class="mr-n3 border" style="z-index: 3;"><v-img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&w=100&q=80" cover></v-img></v-avatar>
                    <v-avatar size="40" class="mr-n3 border" style="z-index: 2;"><v-img src="https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&w=100&q=80" cover></v-img></v-avatar>
                    <v-avatar size="40" class="border mr-3" style="z-index: 1;"><v-img src="https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.0.3&w=100&q=80" cover></v-img></v-avatar>
                    <span class="text-primary font-weight-bold">We're here to help</span>
                  </div>
                  <h3 class="text-h4 font-weight-bold mb-4" style="color: var(--trust-blue); letter-spacing: -0.01em;">Still have questions?</h3>
                  <p class="text-body-1 text-grey-darken-1 mb-8" style="max-width: 400px; line-height: 1.6;">We aim to respond to inquiries within 24 hours. For booking or account issues not covered here, contact us and we’ll help.</p>
                  <v-btn color="primary" size="x-large" rounded="pill" class="plate-btn px-10 font-weight-bold shadow-hover" to="/contact" style="letter-spacing: 0.03em;">Contact Support</v-btn>
                </div>
              </div>
              
            </v-col>
          </v-row>
        </v-container>
      </BulodSection>
    </div>
  </PublicLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import PublicLayout from '@/layouts/PublicLayout.vue'
import GlobalHero from '@/components/GlobalHero.vue'
import BulodSection from '@/components/ui/BulodSection.vue'
import BulodMetallicCard from '@/components/ui/BulodMetallicCard.vue'

const faqCategories = ['All Questions', 'Booking & Tripping', 'Hosting & Earning', 'Insurance & Safety', 'Account Details']
const activeCategory = ref('All Questions')

const allFaqs = [
  {
    category: 'Booking & Tripping',
    question: 'How do I book a car on BulodPH?',
    answer: 'Browse available vehicles in your area, pick one and click Book. Choose your dates on Schedule booking, then go to Checkout. Log in or create an account if needed. Once the rental approves your request, you can pay with GCash or Maya under Payments. You’ll get a confirmation and the rental’s contact for pickup.'
  },
  {
    category: 'Booking & Tripping',
    question: 'What do I need to rent a car?',
    answer: 'You need a valid Philippine driver’s licence (LTO Professional or Non-Professional). You may be asked to complete ID verification (KYC) in your account. Age and other requirements may apply per rental—check the listing and rental terms.'
  },
  {
    category: 'Booking & Tripping',
    question: 'Can I cancel my trip and get a full refund?',
    answer: 'Yes. You can cancel free of charge and receive a full refund when you cancel at least 24 hours before the scheduled pickup. Cancellations within 24 hours of pickup may be subject to a fee. Cancel from My bookings by opening the booking and choosing Cancel.'
  },
  {
    category: 'Hosting & Earning',
    question: 'How do I list my vehicle on BulodPH?',
    answer: 'Sign up as a Car rental owner (via “List your vehicle” or Create account), then go to My vehicles and click Add vehicle. Add photos, description, price per day, and availability. Submit for approval. Once approved, renters can book. You may be asked to provide vehicle or business documents (e.g. LTO) for verification.'
  },
  {
    category: 'Hosting & Earning',
    question: 'How and when do I get paid for my trips?',
    answer: 'Earnings from completed trips go to your balance. Set your payout method (GCash, Maya, or bank) under Payout method in your dashboard. Payouts run on a schedule (e.g. weekly); check Earnings for details and typical processing times.'
  },
  {
    category: 'Insurance & Safety',
    question: 'Are the vehicles insured during trips?',
    answer: 'BulodPH is a platform that connects renters and car rental owners. We do not insure vehicles. Insurance is the responsibility of the car rental owner. For coverage details or claims related to theft or damage, contact the rental directly. See our Terms for full details.'
  },
  {
    category: 'Insurance & Safety',
    question: 'What happens if the car breaks down on the road?',
    answer: 'Contact the car rental using the details in your booking. For urgent issues, also contact BulodPH support. Resolutions (e.g. replacement, refund) are agreed between you and the rental in line with your rental terms.'
  },
  {
    category: 'Account Details',
    question: 'How long does ID verification take?',
    answer: 'Verification is usually completed within a few minutes to 24 hours. If your ID or photo needs manual review, our team will process it as soon as possible. You’ll be notified once verification is complete.'
  },
]

const filteredFaqs = computed(() => {
  if (activeCategory.value === 'All Questions') return allFaqs
  return allFaqs.filter(faq => faq.category === activeCategory.value)
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
.faq-section-inner {
  position: relative;
}
.faq-section-inner::before {
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
.faq-section-inner > * {
  position: relative;
  z-index: 1;
}
.faq-accordion-watermark {
  position: relative;
}
.page-container {
  max-width: 1100px;
}
.custom-panels {
  background: transparent !important;
}
.faq-panel {
  border: 1px solid rgba(14, 165, 233, 0.1) !important;
  background-color: white !important;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.faq-panel:hover {
  box-shadow: 0 10px 25px rgba(0,0,0,0.06) !important;
  border-color: var(--primary-cyan) !important;
  transform: translateY(-2px);
}
.faq-title {
  color: var(--trust-blue);
  letter-spacing: -0.01em;
  transition: color 0.3s ease, background-color 0.3s ease;
}
.faq-title:hover {
  color: var(--primary-cyan);
}
.custom-panels :deep(.v-expansion-panel-title--active) {
  background-color: rgba(14, 165, 233, 0.04);
  color: var(--primary-cyan);
}
.shadow-hover {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.shadow-hover:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(14, 165, 233, 0.3) !important;
}
.z-index-2 {
  z-index: 2;
}
.opacity-20 {
  opacity: 0.2;
}
</style>
