<template>
  <PublicLayout>
    <div class="public-page">
      <GlobalHero
        title="Contact Us"
        subtitle="We are here to help. Reach out to our 24/7 support team for any inquiries."
        imageUrl="https://images.unsplash.com/photo-1521791136064-7986c2920216?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80"
        altText="Customer support representative on phone"
      />

      <!-- Contact Split Layout -->
      <BulodSection theme="light" id="contact" :watermark="true" watermarkVariant="receipt" :padded="true">
        <v-container class="position-relative z-index-2">
          <v-row class="stretch-row">
            <!-- Left Side: Form -->
            <v-col cols="12" md="7" class="scroll-reveal scroll-reveal-up d-flex">
              <BulodMetallicCard class="w-100 position-relative overflow-hidden" elevation="8" :innerWatermark="true">
                <div class="position-relative z-index-2">
                  <span class="section-badge bg-white text-primary mb-4 d-inline-block">Get in Touch</span>
                  <h2 class="text-h3 font-weight-bold mb-3" style="color: var(--trust-blue); letter-spacing: -0.02em;">Send us a Message</h2>
                  <p class="text-body-1 text-grey-darken-2 mb-8" style="line-height: 1.6;">Have a question about a booking, hosting, or a general inquiry? Drop us a line and our team will respond within 24 hours.</p>
                  
                  <v-form @submit.prevent="submitForm" class="contact-form">
                    <v-row>
                      <v-col cols="12" sm="6" class="pb-1">
                        <v-text-field label="First Name" variant="outlined" density="comfortable" bg-color="white" color="primary" hide-details="auto" class="rounded-lg mb-4"></v-text-field>
                      </v-col>
                      <v-col cols="12" sm="6" class="pb-1">
                        <v-text-field label="Last Name" variant="outlined" density="comfortable" bg-color="white" color="primary" hide-details="auto" class="rounded-lg mb-4"></v-text-field>
                      </v-col>
                      <v-col cols="12" class="py-1">
                        <v-text-field label="Email Address" type="email" variant="outlined" density="comfortable" bg-color="white" color="primary" hide-details="auto" class="rounded-lg mb-4"></v-text-field>
                      </v-col>
                      <v-col cols="12" class="py-1">
                        <v-select label="Subject" :items="['Booking Inquiry', 'Host Support', 'Account Issue', 'Partnership', 'Other']" variant="outlined" density="comfortable" bg-color="white" color="primary" hide-details="auto" class="rounded-lg mb-4"></v-select>
                      </v-col>
                      <v-col cols="12" class="py-1">
                        <v-textarea label="How can we help?" variant="outlined" rows="5" bg-color="white" color="primary" hide-details="auto" class="rounded-lg mb-4"></v-textarea>
                      </v-col>
                      <v-col cols="12" class="pt-2">
                        <v-btn color="primary" size="x-large" block rounded="pill" class="plate-btn text-button font-weight-bold shadow-hover" type="submit" style="letter-spacing: 0.05em;">
                          Send Message
                        </v-btn>
                      </v-col>
                    </v-row>
                  </v-form>
                </div>
              </BulodMetallicCard>
            </v-col>

            <!-- Right Side: Contact Details & Info -->
            <v-col cols="12" md="5" class="scroll-reveal scroll-reveal-up d-flex flex-column pl-md-8 mt-8 mt-md-0" style="transition-delay: 150ms">
              <div class="bg-white rounded-xl pa-8 elevation-3 mb-6 w-100 flex-grow-0" style="border: 1px solid rgba(0,0,0,0.05);">
                <h3 class="text-h5 font-weight-bold mb-8" style="color: var(--trust-blue); letter-spacing: -0.01em;">Contact Information</h3>
                
                <div class="d-flex align-start mb-8 contact-info-row group">
                  <div class="icon-circle mr-5 transition">
                    <MapPin class="text-primary transition-icon" size="24" />
                  </div>
                  <div>
                    <div class="font-weight-bold text-subtitle-1 text-grey-darken-4 mb-1">Headquarters</div>
                    <div class="text-body-2 text-grey-darken-2" style="line-height: 1.6;">{{ CONTACT.address }}</div>
                  </div>
                </div>
                
                <div class="d-flex align-start mb-8 contact-info-row group">
                  <div class="icon-circle mr-5 transition">
                    <Mail class="text-primary transition-icon" size="24" />
                  </div>
                  <div>
                    <div class="font-weight-bold text-subtitle-1 text-grey-darken-4 mb-1">Email Us</div>
                    <a :href="CONTACT.emailHref" class="text-body-2 text-decoration-none text-grey-darken-2 hover-primary transition d-block mb-1">{{ CONTACT.email }}</a>
                    <a :href="CONTACT.supportEmailHref" class="text-body-2 text-decoration-none text-grey-darken-2 hover-primary transition d-block">{{ CONTACT.supportEmail }}</a>
                  </div>
                </div>
                
                <div class="d-flex align-start mb-2 contact-info-row group">
                  <div class="icon-circle mr-5 transition">
                    <Phone class="text-primary transition-icon" size="24" />
                  </div>
                  <div>
                    <div class="font-weight-bold text-subtitle-1 text-grey-darken-4 mb-1">Call Us</div>
                    <a :href="CONTACT.phoneHref" class="text-body-1 font-weight-bold text-decoration-none text-primary hover-dark transition d-block">{{ CONTACT.phone }}</a>
                    <div class="text-caption text-grey-darken-1 mt-1">Available Mon-Sat, 9AM to 6PM</div>
                  </div>
                </div>
              </div>

              <!-- Partnerships Callout -->
              <div class="bg-primary-lighten-5 rounded-xl pa-8 w-100 text-center flex-grow-1 d-flex flex-column justify-center align-center transition-up shadow-hover" style="background-color: rgba(14, 165, 233, 0.05); border: 1px solid rgba(14, 165, 233, 0.2);">
                <div class="mb-4 bg-white pa-3 rounded-circle elevation-2">
                  <Briefcase class="text-primary" size="28" />
                </div>
                <h4 class="text-h5 font-weight-bold mb-3" style="color: var(--trust-blue);">Partner with Us</h4>
                <p class="text-body-2 text-grey-darken-2 mb-6" style="line-height: 1.6;">Are you an established rental agency or fleet manager looking to scale operations online?</p>
                <v-btn variant="outlined" color="primary" rounded="pill" class="bg-white px-8 font-weight-bold transition">Corporate Inquiries</v-btn>
              </div>
            </v-col>
          </v-row>
        </v-container>
      </BulodSection>

      <!-- Branding / dashboard showcase image -->
      <BulodSection theme="light" id="showcase" :watermark="true" watermarkVariant="receipt" :padded="true" class="py-8 mb-16">
        <v-container class="page-container scroll-reveal scroll-reveal-up p-0 position-relative z-index-2">
          <div class="text-center mb-8">
            <h2 class="text-h4 font-weight-bold" style="color: var(--trust-blue);">BulodPH in action</h2>
            <p class="text-body-1 text-grey-darken-1 mt-2">Our platform on desktop and mobile—built for renters and hosts.</p>
          </div>
          <div class="contact-showcase-wrap mx-auto elevation-10 rounded-xl overflow-hidden">
            <img
              :src="FOOTER_SHOWCASE_IMAGE"
              :srcset="`${FOOTER_SHOWCASE_IMAGE} 1x, ${FOOTER_SHOWCASE_IMAGE_2X} 2x`"
              alt="BulodPH app on laptop and phone"
              class="contact-showcase-img"
              loading="lazy"
            />
          </div>
        </v-container>
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
import { CONTACT, FOOTER_SHOWCASE_IMAGE, FOOTER_SHOWCASE_IMAGE_2X } from '@/constants/siteUrls'
import { MapPin, Mail, Phone, Briefcase } from 'lucide-vue-next'

const submitForm = () => {
  // Placeholder submit logic
  alert('Thank you for your message. Our team will get back to you shortly.');
}

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
.page-container {
  max-width: 1200px;
}
.stretch-row {
  align-items: stretch;
}
.z-index-2 {
  z-index: 2;
}
.opacity-20 {
  opacity: 0.2;
}
.icon-circle {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: rgba(14, 165, 233, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.hover-primary:hover {
  color: var(--primary-cyan) !important;
}
.hover-dark:hover {
  color: var(--trust-blue) !important;
}
.transition {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.contact-info-row:hover .icon-circle {
  background: var(--primary-cyan);
  transform: scale(1.1);
}
.contact-info-row:hover .transition-icon {
  color: white !important;
}
.transition-up {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.transition-up:hover {
  transform: translateY(-8px);
}
.shadow-hover {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.shadow-hover:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(14, 165, 233, 0.25) !important;
}
:deep(.v-field--variant-outlined .v-field__outline__start),
:deep(.v-field--variant-outlined .v-field__outline__end) {
  border-color: rgba(0,0,0,0.1) !important;
}
:deep(.v-field--focused.v-field--variant-outlined .v-field__outline__start),
:deep(.v-field--focused.v-field--variant-outlined .v-field__outline__end) {
  border-color: var(--primary-cyan) !important;
}
.contact-showcase-wrap {
  width: 100%;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
  aspect-ratio: 2 / 1;
  max-height: 320px;
  min-height: 220px;
  position: relative;
  background: #fff;
  border: 4px solid white;
  display: flex;
  align-items: center;
  justify-content: center;
}
.contact-showcase-img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  object-position: center;
  display: block;
  /* Sharper when scaled down (avoids soft bilinear blur) */
  image-rendering: -webkit-optimize-contrast;
  image-rendering: crisp-edges;
}
</style>
