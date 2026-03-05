<template>
  <div class="public-page public-page--light">
    <section class="public-hero">
      <div class="public-hero__content">
        <span class="public-hero__badge">City Rental Guide</span>
        <h1 class="public-hero__title">Car rental in the region</h1>
        <p class="public-hero__subtitle">Local tips, pickup spots, and popular routes.</p>
      </div>
    </section>
    <section class="public-section">
      <article class="public-card">
        <p>
          This city page can be populated from your CMS to improve SEO and provide local rental guidance.
        </p>
      </article>
    </section>
  </div>
</template>

<style scoped>
.public-page {
  min-height: 100vh;
  background: #f8fafc;
}
.public-hero {
  padding: 5rem 2rem 2rem;
  background: linear-gradient(135deg, #e0f2fe 0%, #f8fafc 70%);
}
.public-hero__content {
  max-width: 860px;
  margin: 0 auto;
}
.public-hero__badge {
  display: inline-block;
  font-weight: 700;
  letter-spacing: 0.12em;
  font-size: 0.6875rem;
  text-transform: uppercase;
  color: #0369a1;
  background: rgba(14, 165, 233, 0.12);
  padding: 0.35rem 0.75rem;
  border-radius: 999px;
}
.public-hero__title {
  font-size: clamp(2rem, 3.5vw, 3rem);
  margin: 1rem 0 0.5rem;
  color: #0f172a;
}
.public-hero__subtitle {
  color: #475569;
  margin: 0;
  font-size: 1.125rem;
}
.public-section {
  max-width: 860px;
  margin: 2rem auto 4rem;
  padding: 0 2rem;
}
.public-card {
  background: #ffffff;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.06);
  color: #475569;
}
</style>
