<template>
  <PublicLayout>
    <div class="public-page public-page--light">
      <GlobalHero
        title="Travel tips and rental guides"
        subtitle="Stories, updates, and local rental insights from the BulodPH community."
        :imageUrl="blogHeroImage"
        altText="A majestic mountain road in the Philippines"
      />

      <!-- Blog Content Arena -->
      <BulodSection theme="light" id="blog" :watermark="true" watermarkVariant="receipt" :padded="true" class="bg-surface-light">
        <v-container class="position-relative z-index-2 blog-section-inner">
          
          <!-- Featured Post Billboard -->
          <div class="scroll-reveal scroll-reveal-up mb-16">
            <BulodMetallicCard padding="p-0" rounded="rounded-xl" :innerWatermark="true" class="overflow-hidden d-flex flex-column flex-md-row position-relative blog-featured-watermark" style="border: 1px solid rgba(14, 165, 233, 0.15);">
              
              <div class="featured-post-img-wrap w-100 w-md-50 position-relative">
                <v-img 
                  :src="featuredImageSrc"
                  alt="Scenic coastal road trip"
                  cover
                  class="h-100 image-zoom transition-transform"
                  min-height="400"
                  @error="featuredImageSrc = BLOG_FALLBACK_IMAGE"
                >
                  <template v-slot:error>
                    <div class="blog-img-fallback fill-height d-flex align-center justify-center bg-grey-lighten-3">
                      <v-icon icon="mdi-image-outline" size="64" color="grey-lighten-1"></v-icon>
                    </div>
                  </template>
                </v-img>
                <div class="position-absolute d-md-none" style="top: 20px; left: 20px; z-index: 5;">
                   <span class="bg-primary text-white text-caption font-weight-bold px-4 py-1 rounded-pill shadow-sm">Featured</span>
                </div>
              </div>

              <div class="featured-post-content w-100 w-md-50 pa-8 pa-md-12 d-flex flex-column justify-center bg-white position-relative overflow-hidden z-index-2">
                <div class="position-absolute" style="top: -40px; right: -20px; font-size: 20rem; color: rgba(14, 165, 233, 0.03); font-family: serif; font-weight: 900; line-height: 1; pointer-events: none; user-select: none;">"</div>
                
                <span class="text-overline text-primary font-weight-bold mb-3 section-badge d-none d-md-inline-block align-self-start z-index-3">Editors Pick</span>
                <h2 class="text-h4 font-weight-bold mb-5 z-index-3 blog-hover-title transition cursor-pointer" style="color: var(--trust-blue); line-height: 1.25; letter-spacing: -0.02em;" @click="$router.push('/blog/scenic-road-trips')">Top 5 Scenic Road Trips in Northern Luzon You Can Take This Weekend</h2>
                <p class="text-body-1 text-grey-darken-2 mb-8 z-index-3" style="line-height: 1.7; font-size: 1.05rem;">Escape the city heat and hit the open road. From the winding switchbacks of the Cordilleras to the hidden coastal highways across the region, discover the best routes for your next adventure.</p>
                
                <v-divider class="mb-6 opacity-20 z-index-3"></v-divider>

                <div class="d-flex align-center mt-auto z-index-3 w-100">
                  <v-avatar size="56" class="mr-4 border team-avatar elevation-2 transition-transform cursor-pointer">
                    <v-img :src="featuredAuthorAvatar" cover @error="featuredAuthorAvatar = BLOG_FALLBACK_AVATAR">
                      <template v-slot:error>
                        <span class="text-h4 font-weight-bold text-grey-darken-1">A</span>
                      </template>
                    </v-img>
                  </v-avatar>
                  <div>
                    <div class="font-weight-bold text-subtitle-1" style="color: var(--trust-blue); letter-spacing: -0.01em;">Ana Lim</div>
                    <div class="text-caption text-grey-darken-1 font-weight-medium">October 15 • 8 min read</div>
                  </div>
                  <v-spacer></v-spacer>
                  <v-btn color="primary" variant="text" append-icon="mdi-arrow-right" class="font-weight-bold text-none plate-btn-text transition px-4 py-2 rounded-lg" @click="$router.push('/blog/scenic-road-trips')">Read Article</v-btn>
                </div>
              </div>
            </BulodMetallicCard>
          </div>

          <!-- Latest News Filter -->
          <div class="d-flex align-center justify-space-between flex-wrap gap-4 mb-10 scroll-reveal scroll-reveal-up">
            <h3 class="text-h4 font-weight-bold" style="color: var(--trust-blue); letter-spacing: -0.02em;">Latest Articles</h3>
            <div class="d-flex gap-2 flex-wrap filter-group">
              <v-btn class="font-weight-bold bg-primary text-white plate-btn shadow-hover" size="large" rounded="pill">All Posts</v-btn>
              <v-btn class="font-weight-medium bg-white border text-grey-darken-3 filter-btn shadow-hover-light" size="large" rounded="pill" variant="outlined" style="border-color: rgba(0,0,0,0.1) !important;">Travel Guides</v-btn>
              <v-btn class="font-weight-medium bg-white border text-grey-darken-3 filter-btn shadow-hover-light" size="large" rounded="pill" variant="outlined" style="border-color: rgba(0,0,0,0.1) !important;">Hosting Tips</v-btn>
              <v-btn class="font-weight-medium bg-white border text-grey-darken-3 filter-btn shadow-hover-light" size="large" rounded="pill" variant="outlined" style="border-color: rgba(0,0,0,0.1) !important;">Company News</v-btn>
            </div>
          </div>

          <!-- Masonry/Grid of Posts -->
          <v-row class="mb-10">
            <v-col cols="12" sm="6" md="4" v-for="(post, i) in posts" :key="i" class="scroll-reveal scroll-reveal-up mb-4" :style="`transition-delay: ${(i % 3) * 100}ms`">
              <v-card class="blog-card h-100 rounded-xl elevation-3 d-flex flex-column bg-white overflow-hidden" style="border: 1px solid rgba(0,0,0,0.06);">
                <div class="blog-img-wrap position-relative cursor-pointer" @click="$router.push(`/blog/post-${i}`)">
                  <v-img
                    :src="getPostImage(i)"
                    height="240"
                    cover
                    class="blog-img transition-transform"
                    @error="setPostImageError(i)"
                  >
                    <template v-slot:placeholder>
                      <div class="d-flex align-center justify-center fill-height bg-grey-lighten-3">
                        <v-progress-circular indeterminate color="primary"></v-progress-circular>
                      </div>
                    </template>
                    <template v-slot:error>
                      <div class="blog-img-fallback fill-height d-flex align-center justify-center bg-grey-lighten-3">
                        <v-icon icon="mdi-image-outline" size="48" color="grey-lighten-1"></v-icon>
                      </div>
                    </template>
                  </v-img>
                  <div class="blog-category-badge transition shadow-sm">{{ post.category }}</div>
                </div>
                
                <v-card-text class="pa-6 d-flex flex-column flex-grow-1 cursor-pointer" @click="$router.push(`/blog/post-${i}`)">
                  <div class="text-caption font-weight-bold text-primary text-uppercase tracking-wide mb-3">{{ post.date }} • {{ post.readTime }}</div>
                  <h3 class="text-h6 font-weight-bold mb-3 blog-title transition" style="color: var(--trust-blue); line-height: 1.4; letter-spacing: -0.01em;">{{ post.title }}</h3>
                  <p class="text-body-2 text-grey-darken-2 mb-6 flex-grow-1" style="line-height: 1.6;">{{ post.excerpt }}</p>
                  
                  <v-divider class="mb-5 opacity-20"></v-divider>
                  
                  <div class="d-flex align-center mt-auto">
                    <v-avatar size="32" class="mr-3 border" color="grey-lighten-2">
                       <span class="text-caption font-weight-bold text-grey-darken-3">{{ post.author.charAt(0) }}</span>
                    </v-avatar>
                    <div class="font-weight-medium text-body-2" style="color: var(--trust-blue);">{{ post.author }}</div>
                  </div>
                </v-card-text>
              </v-card>
            </v-col>
          </v-row>
          
          <div class="text-center mt-6 scroll-reveal scroll-reveal-up">
            <v-btn color="primary" variant="outlined" size="x-large" rounded="pill" class="px-10 bg-white font-weight-bold shadow-hover" style="border-width: 2px;">Load More Articles</v-btn>
          </div>

        </v-container>
      </BulodSection>

    </div>
  </PublicLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import PublicLayout from '@/layouts/PublicLayout.vue'
import GlobalHero from '@/components/GlobalHero.vue'
import BulodSection from '@/components/ui/BulodSection.vue'
import BulodMetallicCard from '@/components/ui/BulodMetallicCard.vue'

// Reliable placeholder service (Picsum) so images always load; fallback data URIs if that fails
const BLOG_FALLBACK_IMAGE = 'data:image/svg+xml,' + encodeURIComponent(
  '<svg xmlns="http://www.w3.org/2000/svg" width="800" height="600" viewBox="0 0 800 600"><rect fill="#e2e8f0" width="800" height="600"/><text x="50%" y="50%" fill="#94a3b8" font-family="sans-serif" font-size="24" text-anchor="middle" dy=".3em">Image</text></svg>'
)
const BLOG_FALLBACK_AVATAR = 'data:image/svg+xml,' + encodeURIComponent(
  '<svg xmlns="http://www.w3.org/2000/svg" width="150" height="150" viewBox="0 0 150 150"><rect fill="#e2e8f0" width="150" height="150"/><text x="50%" y="50%" fill="#64748b" font-family="sans-serif" font-size="48" text-anchor="middle" dy=".35em">?</text></svg>'
)

const blogHeroImage = ref('https://picsum.photos/seed/bulod-blog-hero/2000/1200')
const featuredImageSrc = ref('https://picsum.photos/seed/bulod-featured/1200/800')
const featuredAuthorAvatar = ref('https://picsum.photos/seed/ana-lim/150/150')
const postImageErrors = ref<Record<number, boolean>>({})

const posts = [
  {
    title: 'How to Maximize Your Earnings as a Car Host in the Provinces',
    excerpt: 'Hosting your car in non-metro areas presents a unique opportunity. Learn the top tips for pricing, maintenance, and attracting long-term renters from tourists visiting the region.',
    image: 'https://picsum.photos/seed/bulod-host-1/800/600',
    category: 'Hosting Tips',
    date: 'Oct 10, 2026',
    readTime: '6 min read',
    author: 'Carlos Reyes'
  },
  {
    title: 'The Best SUVs for Family Travel and Out of Town Trips',
    excerpt: 'Not all SUVs are created equal when it comes to long road trips with the family. We review the top 3 high-capacity vehicles available on BulodPH for ultimate comfort and luggage space.',
    image: 'https://picsum.photos/seed/bulod-suv-2/800/600',
    category: 'Travel Guides',
    date: 'Oct 05, 2026',
    readTime: '5 min read',
    author: 'Miguel Torre'
  },
  {
    title: 'Understanding Our New Escrow Payment Policy',
    excerpt: 'To protect both renters and hosts, BulodPH has launched a new escrow payment shield. Here is a breakdown of how it completely eliminates scams and ensures fair handovers.',
    image: 'https://picsum.photos/seed/bulod-escrow-3/800/600',
    category: 'Company News',
    date: 'Sep 28, 2026',
    readTime: '4 min read',
    author: 'Trust & Safety Team'
  },
  {
    title: 'Hidden Food Spots in Cagayan Valley Accessible by Car',
    excerpt: 'Skip the standard tourist traps and drive your rental straight to these authentic culinary destinations hidden away in the valley. A 3-day gastronomic road trip itinerary.',
    image: 'https://picsum.photos/seed/bulod-food-4/800/600',
    category: 'Travel Guides',
    date: 'Sep 22, 2026',
    readTime: '7 min read',
    author: 'Ana Lim'
  },
  {
    title: 'The Essential Car Pre-Trip Inspection Checklist',
    excerpt: 'Before handing over the keys or starting a road trip, always run through this essential 5-point inspection checklist to guarantee safety on the road and avoid disputes.',
    image: 'https://picsum.photos/seed/bulod-checklist-5/800/600',
    category: 'Hosting Tips',
    date: 'Sep 15, 2026',
    readTime: '5 min read',
    author: 'Carlos Reyes'
  },
  {
    title: 'BulodPH Expands Operations to the Ilocos Region',
    excerpt: 'We are thrilled to announce that our car rental marketplace is officially sweeping through Ilocos Norte and Ilocos Sur. Heres what hosts and renters need to expect.',
    image: 'https://picsum.photos/seed/bulod-ilocos-6/800/600',
    category: 'Company News',
    date: 'Sep 02, 2026',
    readTime: '3 min read',
    author: 'Juan Dela Cruz'
  }
]

function getPostImage(index: number) {
  if (postImageErrors.value[index]) return BLOG_FALLBACK_IMAGE
  return posts[index].image
}
function setPostImageError(index: number) {
  postImageErrors.value = { ...postImageErrors.value, [index]: true }
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
.blog-section-inner {
  position: relative;
}
.blog-section-inner::before {
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
.blog-section-inner > * {
  position: relative;
  z-index: 1;
}
.page-container {
  max-width: 1250px;
}
.z-index-2 {
  z-index: 2;
}
.z-index-3 {
  z-index: 3;
}
.gap-2 {
  gap: 0.5rem;
}
.gap-4 {
  gap: 1rem;
}
.tracking-wide {
  letter-spacing: 0.05em;
}
.w-md-50 {
  width: 100%;
}
@media (min-width: 960px) {
  .w-md-50 {
    width: 50% !important;
  }
}
.cursor-pointer {
  cursor: pointer;
}

/* Featured Post Hover – ensure container never empty */
.featured-post-img-wrap {
  overflow: hidden;
  min-height: 400px;
  background-color: #e2e8f0;
}
.blog-img-wrap {
  min-height: 240px;
  background-color: #e2e8f0;
}
.blog-img-fallback {
  min-height: inherit;
}
.transition-transform {
  transition: transform 0.8s cubic-bezier(0.25, 1, 0.5, 1);
}
.container-metallic:hover .image-zoom {
  transform: scale(1.05);
}
.blog-hover-title {
  transition: color 0.3s ease;
}
.blog-hover-title:hover {
  color: var(--primary-cyan) !important;
}
.team-avatar {
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.team-avatar:hover {
  transform: scale(1.1) rotate(2deg);
  border-color: var(--primary-cyan) !important;
}
.plate-btn-text:hover {
  background: rgba(14, 165, 233, 0.1);
}

/* Card Grids */
.blog-card {
  transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), box-shadow 0.3s ease;
}
.blog-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 40px rgba(0,0,0,0.08) !important;
}
.blog-img-wrap {
  overflow: hidden;
}
.blog-card:hover .blog-img {
  transform: scale(1.05);
}
.blog-title {
  transition: color 0.3s ease;
}
.blog-card:hover .blog-title {
  color: var(--primary-cyan) !important;
}
.blog-category-badge {
  position: absolute;
  top: 16px;
  left: 16px;
  background: white;
  color: var(--trust-blue);
  font-size: 0.75rem;
  font-weight: 800;
  padding: 6px 14px;
  border-radius: 999px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  z-index: 2;
  letter-spacing: 0.02em;
}
.blog-card:hover .blog-category-badge {
  color: var(--primary-cyan);
}

/* General Utilities */
.transition {
  transition: all 0.3s ease;
}
.opacity-20 {
  opacity: 0.2;
}
.shadow-hover {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.shadow-hover:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(14, 165, 233, 0.3) !important;
}
.shadow-hover-light {
  transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease, color 0.2s ease;
}
.shadow-hover-light:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.08) !important;
  color: var(--primary-cyan) !important;
  border-color: var(--primary-cyan) !important;
}
</style>
