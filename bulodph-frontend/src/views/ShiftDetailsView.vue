<template>
  <DashboardTemplate
    :animate="true"
    :back-to="{ name: 'shifts' }"
    back-label="Back to Shifts"
  >
    <template #header>
      <div>
        <h1 class="page-title mb-1">Shift Details</h1>
        <p class="page-subtitle">View and manage shift information</p>
      </div>
      <v-btn variant="outlined" color="primary" rounded="lg" class="mr-2">
        <v-icon start>mdi-pencil</v-icon>
        Edit
      </v-btn>
      <v-btn color="primary" rounded="lg">
        <v-icon start>mdi-calendar-check</v-icon>
        Complete
      </v-btn>
    </template>

    <v-row>
      <v-col cols="12" lg="8">
        <!-- Key info -->
        <v-card elevation="0" rounded="lg" class="modern-card mb-4">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-calendar-clock" size="20" />
            </div>
            <span class="section-card-title">Shift #{{ $route.params.id }}</span>
          </div>
          <v-divider class="detail-divider" />
          <v-card-text class="pa-4">
            <v-row>
              <v-col cols="12" sm="6">
                <div class="detail-label">Client</div>
                <div class="detail-value">—</div>
              </v-col>
              <v-col cols="12" sm="6">
                <div class="detail-label">Staff</div>
                <div class="detail-value">—</div>
              </v-col>
              <v-col cols="12" sm="6">
                <div class="detail-label">Start</div>
                <div class="detail-value">—</div>
              </v-col>
              <v-col cols="12" sm="6">
                <div class="detail-label">End</div>
                <div class="detail-value">—</div>
              </v-col>
              <v-col cols="12" sm="6">
                <div class="detail-label">Status</div>
                <v-chip color="primary" size="small">—</v-chip>
              </v-col>
              <v-col cols="12">
                <div class="detail-label">Notes</div>
                <div class="detail-value text-medium-emphasis">No notes</div>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" lg="4">
        <v-card elevation="0" rounded="lg" class="modern-card">
          <div class="section-card-header">
            <div class="section-card-icon">
              <v-icon icon="mdi-map-marker" size="20" />
            </div>
            <span class="section-card-title">Location</span>
          </div>
          <v-divider class="detail-divider" />
          <v-card-text class="pa-4">
            <p class="text-body-2 text-medium-emphasis mb-0">Address will load from shift data</p>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import DashboardTemplate from '@/components/DashboardTemplate.vue'
</script>

<style scoped>
.detail-divider {
  border-color: rgba(30, 58, 95, 0.08);
}

.detail-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text-secondary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 4px;
}

.detail-value {
  font-size: 0.9375rem;
  font-weight: 500;
  color: var(--trust-blue);
}
</style>