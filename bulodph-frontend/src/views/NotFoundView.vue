<template>
  <div class="not-found-page">
    <v-container class="not-found-container" max-width="480">
      <v-card class="modern-card not-found-card">
        <div class="not-found-content">
          <span class="not-found-code">404</span>
          <h1 class="not-found-title">Page not found</h1>
          <p class="not-found-message">
            The page you're looking for doesn't exist or has been moved.
          </p>
          <div class="not-found-actions">
            <v-btn
              to="/"
              color="primary"
              variant="flat"
              size="large"
              rounded="lg"
              class="not-found-btn"
            >
              <v-icon start icon="mdi-home" />
              Go home
            </v-btn>
            <v-btn
              variant="outlined"
              size="large"
              rounded="lg"
              class="not-found-btn"
              @click="$router.back()"
            >
              <v-icon start icon="mdi-arrow-left" />
              Go back
            </v-btn>
          </div>
        </div>
      </v-card>
    </v-container>
  </div>
</template>

<script setup lang="ts">
// No auth required - public 404 page
</script>

<style scoped>
.not-found-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--bg-light);
  padding: var(--page-padding-x);
}

.not-found-container {
  width: 100%;
}

.not-found-card {
  padding: var(--space-12) var(--space-10) !important;
  text-align: center;
}

.not-found-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-4);
}

.not-found-code {
  font-size: 5rem;
  font-weight: 800;
  color: var(--text-muted);
  line-height: 1;
  letter-spacing: var(--tracking-tighter);
}

.not-found-title {
  font-size: var(--text-xl);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
  letter-spacing: var(--tracking-tight);
}

.not-found-message {
  font-size: var(--text-body);
  color: var(--text-secondary);
  margin: 0;
  max-width: 320px;
  line-height: var(--leading-relaxed);
}

.not-found-actions {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-3);
  justify-content: center;
  margin-top: var(--space-4);
}

.not-found-btn {
  text-transform: none !important;
  font-weight: 600 !important;
}

@media (max-width: 599px) {
  .not-found-card {
    padding: var(--space-8) var(--space-6) !important;
  }

  .not-found-code {
    font-size: 4rem;
  }
}
</style>
