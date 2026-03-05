<template>
  <DashboardTemplate :animate="true">
    <template #header>
      <div class="vehicle-listings-header">
        <h1 class="page-title">Vehicle Listings</h1>
        <div class="header-actions">
          <span class="header-date">{{ formattedDate }}</span>
          <v-tooltip location="bottom">
            <template #activator="{ props: tooltipProps }">
              <v-btn v-bind="tooltipProps" icon variant="text" size="small" :to="{ name: 'profile' }" aria-label="Go to profile">
                <v-icon>mdi-account-circle</v-icon>
              </v-btn>
            </template>
            Go to profile
          </v-tooltip>
        </div>
      </div>
    </template>

    <div class="vehicle-listings-toolbar">
      <v-text-field
        v-model="search"
        placeholder="Search vehicles, permits..."
        prepend-inner-icon="mdi-magnify"
        variant="outlined"
        density="comfortable"
        hide-details
        clearable
        rounded="lg"
        class="search-field"
      />
      <div class="toolbar-right">
        <span class="owners-filter">All Rentals ({{ ownerCount }})</span>
        <v-btn color="primary" variant="outlined" prepend-icon="mdi-plus" rounded="lg" class="btn-bordered" @click="openAdd">
          Add New Vehicle
        </v-btn>
      </div>
    </div>

    <div class="vehicle-filters-wrap">
      <v-btn
        variant="outlined"
        size="small"
        rounded="lg"
        :prepend-icon="showFilters ? 'mdi-chevron-up' : 'mdi-filter'"
        :color="showFilters ? 'primary' : undefined"
        class="filters-toggle-btn mb-2"
        aria-label="Toggle filters"
        @click="showFilters = !showFilters"
      >
        {{ showFilters ? 'Hide filters' : 'Filters' }}
      </v-btn>
      <v-expand-transition>
        <div v-show="showFilters" class="vehicle-filters-bar">
      <div class="choices-filter">
        <label class="choices-label">Location</label>
        <select ref="locationSelectRef" v-model="filters.location" class="choices-input">
          <option v-for="loc in locationOptions" :key="loc" :value="loc">{{ loc }}</option>
        </select>
      </div>
      <div class="choices-filter">
        <label class="choices-label">Car type</label>
        <select ref="carTypeSelectRef" v-model="filters.carType" class="choices-input">
          <option v-for="type in carTypeFilterOptions" :key="type" :value="type">{{ type }}</option>
        </select>
      </div>
      <div class="choices-filter">
        <label class="choices-label">Seats</label>
        <select ref="seatsSelectRef" v-model="filters.seats" class="choices-input">
          <option v-for="seat in seatsOptions" :key="seat" :value="seat">{{ seat }}</option>
        </select>
      </div>
      <div class="choices-filter">
        <label class="choices-label">Transmission</label>
        <select ref="transmissionSelectRef" v-model="filters.transmission" class="choices-input">
          <option v-for="transmission in transmissionOptions" :key="transmission" :value="transmission">{{ transmission }}</option>
        </select>
      </div>
      <v-text-field
        :model-value="filters.priceMin"
        @update:model-value="(v) => filters.priceMin = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined"
        type="number"
        min="0"
        placeholder="Min ₱"
        label="Min price"
        variant="outlined"
        density="compact"
        hide-details
        rounded="lg"
        class="filter-field filter-price"
      />
      <v-text-field
        :model-value="filters.priceMax"
        @update:model-value="(v) => filters.priceMax = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined"
        type="number"
        min="0"
        placeholder="Max ₱"
        label="Max price"
        variant="outlined"
        density="compact"
        hide-details
        rounded="lg"
        class="filter-field filter-price"
      />
      <v-btn
        variant="outlined"
        size="small"
        rounded="lg"
        prepend-icon="mdi-filter-off"
        class="reset-filters-btn"
        aria-label="Reset filters"
        @click="resetFilters"
      >
        Reset
      </v-btn>
        </div>
      </v-expand-transition>
    </div>

    <p class="showing-count">{{ showingRange }}</p>

    <div ref="vehiclesListRef" class="admin-vehicles-stagger">
    <v-row>
      <v-col
        v-for="v in paginatedVehicles"
        :key="v.id"
        cols="12"
        sm="6"
        md="4"
      >
        <v-card elevation="0" rounded="lg" class="vehicle-listing-card" hover>
          <div class="vehicle-listing-card__image">
            <v-img :src="v.image" :alt="v.name" cover height="140" gradient="to bottom, rgba(0,0,0,0) 50%, rgba(0,0,0,0.5) 100%" />
            <div v-if="rentalName(v)" class="vehicle-listing-card__watermark">{{ rentalName(v) }}</div>
            <div v-if="rentalName(v)" class="vehicle-listing-card__rental-badge">
              <VehicleRentalBadge :rental-name="rentalName(v)" :logo-url="rentalLogoUrl(v)" :size="36" />
            </div>
            <span class="vehicle-listing-card__type">{{ v.carType ?? v.type }}</span>
          </div>
          <v-card-text class="pa-4">
            <h3 class="vehicle-listing-card__name">{{ v.name }}</h3>
            <p v-if="v.carNumber" class="vehicle-listing-card__plate">{{ v.carNumber }}</p>
            <p class="vehicle-listing-card__business">{{ v.businessName ?? v.hostName ?? '—' }}</p>
            <div class="vehicle-listing-card__pricing">
              <span class="daily-price">{{ formatPrice(v.pricePerDay) }}</span>
              <span v-if="v.overdueChargeRate != null" class="overdue">{{ formatPrice(v.overdueChargeRate, { suffix: '/hr' }) }} overdue</span>
            </div>
            <div class="vehicle-listing-card__specs">
              <span>{{ v.transmission ?? '—' }}</span>
              <span class="dot">•</span>
              <span>{{ v.fuelType ?? '—' }}</span>
              <span class="dot">•</span>
              <span>{{ v.capacity != null ? v.capacity + ' Seats' : '—' }}</span>
            </div>
            <div class="vehicle-listing-card__meta">
              <v-chip size="x-small" color="primary" variant="tonal" prepend-icon="mdi-car-side">{{ v.carType ?? v.type }}</v-chip>
              <v-chip size="x-small" :color="v.status === 'Available' ? 'success' : 'default'" :prepend-icon="v.status === 'Available' ? 'mdi-check-circle' : 'mdi-close-circle-outline'" variant="tonal">{{ v.status ?? 'Available' }}</v-chip>
              <v-chip v-if="v.rentalMode" size="x-small" variant="tonal" color="secondary" prepend-icon="mdi-car-key">{{ rentalModeLabel(v.rentalMode) }}</v-chip>
              <v-chip v-if="minRentalChipText(v.minRentalPeriodHours)" size="x-small" variant="tonal" color="secondary">{{ minRentalChipText(v.minRentalPeriodHours) }}</v-chip>
            </div>
            <p v-if="v.hasPermit && v.businessPermitNumber" class="vehicle-listing-card__permit">Permit: {{ v.businessPermitNumber }}</p>
            <p class="vehicle-listing-card__reviews">{{ (v.reviewCount ?? 0) === 0 ? 'No reviews' : v.reviewCount + ' review(s)' }}</p>
            <div class="vehicle-listing-card__actions d-flex gap-2">
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" color="primary" rounded="lg" icon="mdi-eye" aria-label="View vehicle" class="action-btn action-btn--primary" @click="openViewDetail(v)" />
                </template>
                View
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" rounded="lg" icon="mdi-pencil" aria-label="Edit vehicle" class="action-btn action-btn--edit" @click="openEdit(v)" />
                </template>
                Edit
              </v-tooltip>
              <v-tooltip location="top">
                <template #activator="{ props: tooltipProps }">
                  <v-btn v-bind="tooltipProps" variant="outlined" size="small" color="error" rounded="lg" icon="mdi-delete-outline" aria-label="Delete vehicle" class="action-btn action-btn--error" @click="confirmDelete(v)" />
                </template>
                Delete
              </v-tooltip>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    </div>

    <v-pagination
      v-if="totalPages > 1"
      v-model="currentPage"
      :length="totalPages"
      :total-visible="7"
      density="comfortable"
      rounded="lg"
      class="mt-4"
    />

    <v-card v-if="!filteredVehicles.length" elevation="0" rounded="lg" class="modern-card">
      <v-card-text class="pa-4">
        <HpaEmptyState
          title="No vehicles yet"
          description="Add your first vehicle to show it on the client browse page. List cars from your car rental fleet."
          icon="mdi-car-side"
          action-text="Add vehicle"
          action-icon="mdi-plus"
          @action="openAdd"
        />
      </v-card-text>
    </v-card>

    <!-- Add / Edit Vehicle modal -->
    <HpaModal v-model="showForm" :title="editingId ? 'Edit vehicle' : 'Add New Vehicle'" :icon="editingId ? 'mdi-pencil' : 'mdi-plus'" max-width="640" @confirm="saveVehicle">
      <v-form ref="formRef" class="vehicle-form">
        <div class="form-section-header">
          <div class="form-section-icon">
            <v-icon icon="mdi-domain" size="18" />
          </div>
          <span>Business Information</span>
        </div>
        <v-select
          v-model="form.businessName"
          :items="businessOwnerItems"
          label="Business Name"
          placeholder="Select from registered car rental companies"
          variant="outlined"
          density="comfortable"
          class="mb-3"
          hide-details
        />

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-car-info" size="18" />
          </div>
          <span>Basic Vehicle Information</span>
        </div>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.brand" @update:model-value="(v) => form.brand = formatInput(v, 'letters')" label="Brand *" placeholder="e.g., Honda, Toyota" variant="outlined" density="comfortable" hide-details prepend-inner-icon="mdi-tag-outline" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.model" @update:model-value="(v) => form.model = formatInput(v, 'alphanumericSpaces')" label="Model *" placeholder="e.g., Civic, Camry" variant="outlined" density="comfortable" hide-details prepend-inner-icon="mdi-car-info" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.carNumber" @update:model-value="(v) => form.carNumber = formatInput(v, 'plateNumber')" label="Car Number *" placeholder="e.g., ABC123" variant="outlined" density="comfortable" hide-details prepend-inner-icon="mdi-numeric" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.businessPermitNumber" @update:model-value="(v) => form.businessPermitNumber = formatInput(v, 'idNumber')" label="Business Permit Number" placeholder="e.g., BP-2024-001" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-select v-model="form.carType" :items="carTypeItems" label="Car Type" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-select v-model="form.status" :items="['Available', 'Unavailable']" label="Status" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.capacity" @update:model-value="(v) => form.capacity = sanitizeQuantity(v, { min: 1, max: 20 }) || undefined" type="number" min="1" label="Capacity (Seats)" variant="outlined" density="comfortable" hide-details />
          </v-col>
        </v-row>

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-currency-php" size="18" />
          </div>
          <span>Pricing Information</span>
        </div>
        <v-row dense>
          <v-col cols="12" sm="4">
            <v-text-field :model-value="form.pricePerDay" @update:model-value="(v) => form.pricePerDay = sanitizePrice(v)" type="number" min="0" label="Daily Price (₱) *" placeholder="e.g., 20000" variant="outlined" density="comfortable" hide-details prepend-inner-icon="mdi-currency-php" />
          </v-col>
          <v-col cols="12" sm="4">
            <v-text-field :model-value="form.overdueChargeRate" @update:model-value="(v) => form.overdueChargeRate = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined" type="number" min="0" label="Overdue Charge Rate (₱) *" placeholder="e.g., 5000" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="4">
            <v-text-field :model-value="form.securityDeposit" @update:model-value="(v) => form.securityDeposit = (v === '' || v == null) ? undefined : sanitizePrice(v) || undefined" type="number" min="0" label="Security Deposit (₱)" placeholder="e.g., 15000" variant="outlined" density="comfortable" hide-details />
          </v-col>
        </v-row>

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-cog-outline" size="18" />
          </div>
          <span>Technical Specifications</span>
        </div>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-select v-model="form.transmission" :items="['Automatic', 'Manual']" label="Transmission" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-select v-model="form.fuelType" :items="['Gasoline', 'Diesel', 'Electric']" label="Fuel Type" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-select v-model="form.fuelReturnPolicy" :items="fuelReturnItems" label="Fuel Return Policy" variant="outlined" density="comfortable" hide-details />
          </v-col>
          <v-col cols="12" sm="6">
            <v-select
              v-model="form.rentalMode"
              :items="rentalModeItems"
              label="Rental mode"
              variant="outlined"
              density="comfortable"
              hide-details
            />
          </v-col>
          <v-col cols="12" sm="6">
            <v-text-field :model-value="form.minRentalPeriodHours" @update:model-value="(v) => form.minRentalPeriodHours = (v === '' || v == null) ? undefined : sanitizeQuantity(v, { min: 1, max: 8760 })" type="number" min="1" label="Min Rental Period (hours)" variant="outlined" density="comfortable" hide-details />
            <div class="d-flex flex-wrap gap-2 mt-1">
              <v-chip
                v-for="hr in minRentalPresetHours"
                :key="hr"
                size="small"
                :color="form.minRentalPeriodHours === hr ? 'primary' : undefined"
                :variant="form.minRentalPeriodHours === hr ? 'flat' : 'tonal'"
                @click="form.minRentalPeriodHours = hr"
              >
                {{ hr }}h
              </v-chip>
            </div>
          </v-col>
        </v-row>

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-text-box-outline" size="18" />
          </div>
          <span>Additional Information</span>
        </div>
        <v-textarea v-model="form.description" label="Description" placeholder="Additional details about the vehicle..." variant="outlined" rows="2" hide-details />

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-image-multiple-outline" size="18" />
          </div>
          <span>Vehicle Images</span>
        </div>
        <v-file-input
          v-model="mainImageFiles"
          label="Main image *"
          placeholder="Upload main photo (JPG, PNG)"
          prepend-inner-icon="mdi-camera"
          prepend-icon=""
          accept="image/*"
          show-size
          variant="outlined"
          density="comfortable"
          class="mb-2"
          hide-details
          @update:model-value="onMainImageSelect"
        />
        <v-img v-if="form.image" :src="form.image" alt="Main" cover max-height="100" class="rounded-lg mb-3" />
        <p class="text-caption text-medium-emphasis mb-2">Four sides (optional): Front, Rear, Left, Right.</p>
        <v-row dense>
          <v-col cols="12" sm="6">
            <v-file-input v-model="sideImageFiles.front" label="Front" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="comfortable" hide-details @update:model-value="(f) => onSideImageSelect('imageFront', f)" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-file-input v-model="sideImageFiles.rear" label="Rear" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="comfortable" hide-details @update:model-value="(f) => onSideImageSelect('imageRear', f)" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-file-input v-model="sideImageFiles.left" label="Left" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="comfortable" hide-details @update:model-value="(f) => onSideImageSelect('imageLeft', f)" />
          </v-col>
          <v-col cols="12" sm="6">
            <v-file-input v-model="sideImageFiles.right" label="Right" placeholder="Upload" prepend-icon="" prepend-inner-icon="mdi-camera" accept="image/*" variant="outlined" density="comfortable" hide-details @update:model-value="(f) => onSideImageSelect('imageRight', f)" />
          </v-col>
        </v-row>
        <p class="text-caption text-medium-emphasis mt-2 mb-2">Additional views (optional, max 5).</p>
        <v-file-input
          v-model="additionalImageFiles"
          label="Upload additional photos"
          placeholder="Select multiple images"
          prepend-inner-icon="mdi-image-multiple"
          prepend-icon=""
          accept="image/*"
          show-size
          multiple
          variant="outlined"
          density="comfortable"
          hide-details
          @update:model-value="onAdditionalImagesSelect"
        />

        <div class="form-section-header form-section-header--spaced">
          <div class="form-section-icon">
            <v-icon icon="mdi-alert-circle-outline" size="18" />
          </div>
          <span>Known issues</span>
        </div>
        <v-textarea v-model="form.knownIssues" label="Known issues or notes" placeholder="e.g. Minor scratch on rear bumper, AC needs refill in summer" variant="outlined" rows="2" hide-details />
      </v-form>
    </HpaModal>

    <HpaConfirmModal
      v-model="showDeleteConfirm"
      title="Delete vehicle?"
      :message="deleteMessage"
      confirm-text="Delete"
      cancel-text="Cancel"
      variant="danger"
      @confirm="doDelete"
    />

    <!-- Vehicle Details dialog (admin view) -->
    <HpaModal
      v-model="showDetailDialog"
      :title="selectedVehicle?.name ?? 'Vehicle details'"
      icon="mdi-car-info"
      max-width="720"
      :persistent="true"
      :show-actions="true"
    >
      <template v-if="selectedVehicle">
        <div class="vehicle-detail-dialog__body">
          <v-chip size="small" :color="selectedVehicle.status === 'Available' ? 'success' : 'default'" :prepend-icon="selectedVehicle.status === 'Available' ? 'mdi-check-circle' : 'mdi-close-circle-outline'" variant="tonal" class="mb-3">{{ selectedVehicle.status ?? 'Available' }}</v-chip>
          <!-- Main image + 4 sides -->
          <div class="vehicle-detail-dialog__gallery mb-4">
            <div class="vehicle-detail-dialog__hero">
              <v-img :src="detailSelectedImage" :alt="selectedVehicle.name" cover height="240" class="rounded-lg" />
            </div>
            <div v-if="detailFourSides.length" class="vehicle-detail-dialog__four-sides mt-2">
              <button
                v-for="side in detailFourSides"
                :key="side.key"
                type="button"
                class="detail-side-thumb"
                :class="{ 'detail-side-thumb--active': detailSelectedImage === side.url }"
                :aria-label="`View ${side.label} image`"
                @click="detailSelectedImage = side.url"
              >
                <v-img :src="side.url" cover height="56" class="rounded" />
                <span class="detail-side-thumb__label">{{ side.label }}</span>
              </button>
            </div>
          </div>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-car-info" size="18" />
            </div>
            <span>Basic Information</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <v-row dense>
              <v-col cols="6"><span class="detail-label">Brand:</span> {{ selectedVehicle.brand ?? '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Model:</span> {{ selectedVehicle.model ?? '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Car Number:</span> {{ selectedVehicle.carNumber ?? '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Type:</span> {{ selectedVehicle.carType ?? selectedVehicle.type }}</v-col>
              <v-col cols="6"><span class="detail-label">Vehicle Number:</span> #{{ selectedVehicle.id }}</v-col>
            </v-row>
          </v-sheet>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-currency-php" size="18" />
            </div>
            <span>Pricing</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <v-row dense>
              <v-col cols="6"><span class="detail-label">Daily Rate:</span> {{ formatPrice(selectedVehicle.pricePerDay) }}</v-col>
              <v-col cols="6"><span class="detail-label">Overdue Charge Rate:</span> {{ selectedVehicle.overdueChargeRate != null ? formatPrice(selectedVehicle.overdueChargeRate, { suffix: '/hr' }) : '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Security Deposit:</span> {{ selectedVehicle.securityDeposit != null ? formatPrice(selectedVehicle.securityDeposit) : '—' }}</v-col>
            </v-row>
          </v-sheet>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-cog-outline" size="18" />
            </div>
            <span>Specifications</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <v-row dense>
              <v-col cols="6"><span class="detail-label">Transmission:</span> {{ selectedVehicle.transmission ?? '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Capacity:</span> {{ selectedVehicle.capacity != null ? selectedVehicle.capacity + ' seats' : '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Fuel Type:</span> {{ selectedVehicle.fuelType ?? '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Rental mode:</span> {{ selectedVehicle.rentalMode ? rentalModeLabel(selectedVehicle.rentalMode) : '—' }}</v-col>
              <v-col cols="6"><span class="detail-label">Min Rental:</span> {{ selectedVehicle.minRentalPeriodHours != null ? (selectedVehicle.minRentalPeriodHours === 24 ? '1 day' : selectedVehicle.minRentalPeriodHours + ' hours') : '—' }}</v-col>
            </v-row>
          </v-sheet>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-text-box-outline" size="18" />
            </div>
            <span>Features &amp; Description</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <p class="text-body-2 mb-0">{{ selectedVehicle.description || '—' }}</p>
          </v-sheet>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-file-document-outline" size="18" />
            </div>
            <span>Rental Terms</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <p class="text-body-2 mb-0">Fuel Policy: {{ selectedVehicle.fuelReturnPolicy ?? '—' }}</p>
            <p class="text-body-2 mb-0">Business: {{ selectedVehicle.businessName ?? selectedVehicle.hostName ?? '—' }}</p>
          </v-sheet>

          <template v-if="selectedVehicle.knownIssues">
            <div class="form-section-header">
              <div class="form-section-icon">
                <v-icon icon="mdi-alert-circle-outline" size="18" color="warning" />
              </div>
              <span>Known issues</span>
            </div>
            <v-sheet rounded="lg" class="pa-3 mb-4 detail-section detail-section--warning">
              <p class="text-body-2 mb-0">{{ selectedVehicle.knownIssues }}</p>
            </v-sheet>
          </template>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-star-outline" size="18" />
            </div>
            <span>Recent Reviews</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <p class="text-body-2 text-medium-emphasis mb-0">{{ (selectedVehicle.reviewCount ?? 0) === 0 ? 'No reviews yet for this rental' : selectedVehicle.reviewCount + ' review(s)' }}</p>
          </v-sheet>

          <div class="form-section-header">
            <div class="form-section-icon">
              <v-icon icon="mdi-database-outline" size="18" />
            </div>
            <span>Record Information</span>
          </div>
          <v-sheet rounded="lg" class="pa-3 mb-4 detail-section">
            <p class="text-body-2 mb-0"><span class="detail-label">Created:</span> {{ selectedVehicle.createdAt ?? '—' }}</p>
            <p class="text-body-2 mb-0"><span class="detail-label">Updated:</span> {{ selectedVehicle.updatedAt ?? '—' }}</p>
          </v-sheet>
        </div>
      </template>
      <template #actions>
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <v-btn v-bind="tooltipProps" variant="outlined" color="primary" rounded="lg" icon="mdi-eye" aria-label="View on browse" :to="{ name: 'client-vehicle-detail', params: { id: selectedVehicle?.id } }" @click="showDetailDialog = false" />
          </template>
          View on browse
        </v-tooltip>
        <v-spacer />
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <v-btn v-bind="tooltipProps" variant="outlined" rounded="lg" icon="mdi-pencil" aria-label="Edit vehicle" class="action-btn action-btn--edit" @click="showDetailDialog = false; selectedVehicle && openEdit(selectedVehicle)" />
          </template>
          Edit vehicle
        </v-tooltip>
        <v-tooltip location="top">
          <template #activator="{ props: tooltipProps }">
            <v-btn v-bind="tooltipProps" variant="outlined" color="error" rounded="lg" icon="mdi-delete-outline" aria-label="Delete vehicle" class="action-btn action-btn--error" @click="showDetailDialog = false; selectedVehicle && confirmDelete(selectedVehicle)" />
          </template>
          Delete vehicle
        </v-tooltip>
      </template>
    </HpaModal>
  </DashboardTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import DashboardTemplate from '@/components/DashboardTemplate.vue'
import HpaEmptyState from '@/components/base/HpaEmptyState.vue'
import HpaModal from '@/components/base/HpaModal.vue'
import HpaConfirmModal from '@/components/base/HpaConfirmModal.vue'
import { useVehicles } from '@/composables/useVehicles'
import { useCarRentalProfiles } from '@/composables/useCarRentalProfiles'
import { useChoices } from '@/composables/useChoices'
import { formatPrice } from '@/utils/priceFormat'
import { useToastStore } from '@/stores/toast'
import { filesToDataUrls } from '@/composables/useImageUpload'
import { formatInput } from '@/utils/inputFormatters'
import { sanitizePrice, sanitizeQuantity } from '@/utils/numericValidation'
import VehicleRentalBadge from '@/components/VehicleRentalBadge.vue'
import { BUSINESS_OWNERS, rentalModeLabel, minRentalChipText } from '@/constants/vehicleSeed'
import type { VehicleSeedItem, VehicleImagesFourSides } from '@/constants/vehicleSeed'
import { useGsapStagger } from '@/composables/useGsapStagger'

function rentalName(v: { businessName?: string; hostName?: string }) {
  return (v.businessName ?? v.hostName ?? '').trim() || undefined
}

const { rentals } = useCarRentalProfiles()

function normRentalName(name: string): string {
  return name
    .replace(/\s*rental\s*/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
}

function rentalLogoUrl(vehicle: { businessName?: string; hostName?: string }): string | undefined {
  const name = rentalName(vehicle)
  if (!name) return undefined
  const norm = normRentalName(name)
  const match = rentals.value.find(rental => {
    const raw = (rental.businessName ?? (rental as { business_name?: string }).business_name ?? '') as string
    const rn = normRentalName(raw)
    if (!rn) return false
    if (rn === norm) return true
    if (norm.includes(rn) || rn.includes(norm)) return true
    return false
  })
  const url = (match as { logoUrl?: string; logo_url?: string } | undefined)?.logoUrl
    ?? (match as { logoUrl?: string; logo_url?: string } | undefined)?.logo_url
  return typeof url === 'string' && url.trim() ? url.trim() : undefined
}

const toast = useToastStore()
const vehiclesListRef = ref<HTMLElement | null>(null)
useGsapStagger(vehiclesListRef, { selector: '.v-col', y: 14, duration: 0.42, stagger: 0.06 })

const mainImageFiles = ref<File[] | null>(null)
const sideImageFiles = ref<{ front: File[] | null; rear: File[] | null; left: File[] | null; right: File[] | null }>({
  front: null, rear: null, left: null, right: null,
})
const additionalImageFiles = ref<File[] | null>(null)

async function onMainImageSelect(files: File[] | null) {
  const url = await filesToDataUrls(files) as string | null
  if (url) form.value.image = url
}

async function onSideImageSelect(field: 'imageFront' | 'imageRear' | 'imageLeft' | 'imageRight', files: File[] | null) {
  const url = await filesToDataUrls(files) as string | null
  if (url) form.value[field] = url
}

async function onAdditionalImagesSelect(files: File[] | null) {
  const urls = await filesToDataUrls(files, true) as string[] | null
  if (urls?.length) form.value.additionalImagesStr = urls.slice(0, 5).join(', ')
}
const { vehicles, add, update, remove, fetchFromApi } = useVehicles()

const showFilters = ref(false)
const search = ref('')
const showForm = ref(false)
const showDetailDialog = ref(false)
const selectedVehicle = ref<VehicleSeedItem | null>(null)
const detailSelectedImage = ref('')
const showDeleteConfirm = ref(false)
const editingId = ref<string | null>(null)
const vehicleToDelete = ref<VehicleSeedItem | null>(null)
const formRef = ref<{ validate: () => Promise<{ valid: boolean }> } | null>(null)

watch(selectedVehicle, (v) => {
  detailSelectedImage.value = v?.image ?? ''
}, { immediate: true })

const detailFourSides = computed((): { key: keyof VehicleImagesFourSides; label: string; url: string }[] => {
  const sides = selectedVehicle.value?.imagesFourSides
  if (!sides) return []
  return [
    { key: 'front', label: 'Front', url: sides.front },
    { key: 'rear', label: 'Rear', url: sides.rear },
    { key: 'left', label: 'Left', url: sides.left },
    { key: 'right', label: 'Right', url: sides.right },
  ]
})

const carTypeItems = ['Sedan', 'SUV', 'MPV', 'Hatchback', 'Van']
const fuelReturnItems = ['Return with Same Level', 'Full Tank', 'Empty']
const rentalModeItems = [
  { title: 'Driver only', value: 'driver_only' },
  { title: 'Self-drive only', value: 'self_drive_only' },
  { title: 'Both', value: 'both' },
]
const minRentalPresetHours = [12, 24, 36, 48]
const businessOwnerItems = ['', ...BUSINESS_OWNERS]

const filters = ref({
  location: 'All',
  carType: 'All',
  seats: 'All',
  transmission: 'All',
  priceMin: undefined as number | undefined,
  priceMax: undefined as number | undefined,
})

const locationSelectRef = ref<HTMLSelectElement | null>(null)
const carTypeSelectRef = ref<HTMLSelectElement | null>(null)
const seatsSelectRef = ref<HTMLSelectElement | null>(null)
const transmissionSelectRef = ref<HTMLSelectElement | null>(null)

const locationOptions = computed(() => {
  const locs = new Set(vehicles.value.map(v => v.location).filter(Boolean))
  return ['All', ...Array.from(locs).sort()]
})

const carTypeFilterOptions = ['All', 'Sedan', 'SUV', 'MPV', 'Hatchback', 'Van']
const seatsOptions = ['All', '2+', '4+', '5+', '7+', '12+']
const transmissionOptions = ['All', 'Automatic', 'Manual']

useChoices(locationSelectRef, { searchEnabled: true })
useChoices(carTypeSelectRef, { searchEnabled: false })
useChoices(seatsSelectRef, { searchEnabled: false })
useChoices(transmissionSelectRef, { searchEnabled: false })

onMounted(() => {
  fetchFromApi()
})

const formattedDate = computed(() => {
  const d = new Date()
  const options: Intl.DateTimeFormatOptions = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
  return d.toLocaleDateString('en-PH', options)
})

const ownerCount = computed(() => {
  const names = new Set(vehicles.value.map(v => v.businessName ?? v.hostName).filter(Boolean))
  return names.size || 1
})

const form = ref({
  name: '',
  businessName: '' as string,
  brand: '',
  model: '',
  carNumber: '',
  businessPermitNumber: '',
  carType: 'Sedan' as string,
  status: 'Available' as 'Available' | 'Unavailable',
  capacity: 4,
  pricePerDay: 2000,
  overdueChargeRate: 500,
  securityDeposit: undefined as number | undefined,
  transmission: 'Automatic' as string,
  fuelType: 'Gasoline' as string,
  fuelReturnPolicy: 'Return with Same Level' as string,
  rentalMode: 'both' as string,
  minRentalPeriodHours: 24,
  description: '',
  image: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop',
  additionalImagesStr: '',
  imageFront: '',
  imageRear: '',
  imageLeft: '',
  imageRight: '',
  knownIssues: '',
  type: 'Car',
  location: 'Vigan',
  approved: true,
  featured: false,
  verified: true,
  hasPermit: false,
})

const filteredVehicles = computed(() => {
  let list = vehicles.value
  if (search.value) {
    const q = search.value.toLowerCase()
    list = list.filter(
      v =>
        v.name.toLowerCase().includes(q) ||
        v.location?.toLowerCase().includes(q) ||
        v.carNumber?.toLowerCase().includes(q) ||
        v.businessPermitNumber?.toLowerCase().includes(q) ||
        v.businessName?.toLowerCase().includes(q) ||
        v.hostName?.toLowerCase().includes(q)
    )
  }
  if (filters.value.location !== 'All') list = list.filter(v => v.location === filters.value.location)
  if (filters.value.carType !== 'All') list = list.filter(v => (v.carType ?? v.type) === filters.value.carType)
  if (filters.value.seats !== 'All') {
    const minSeats = parseInt(filters.value.seats.replace('+', ''), 10)
    list = list.filter(v => (v.capacity ?? 0) >= minSeats)
  }
  if (filters.value.transmission !== 'All') list = list.filter(v => v.transmission === filters.value.transmission)
  if (filters.value.priceMin != null && filters.value.priceMin > 0) list = list.filter(v => v.pricePerDay >= filters.value.priceMin!)
  if (filters.value.priceMax != null && filters.value.priceMax > 0) list = list.filter(v => v.pricePerDay <= filters.value.priceMax!)
  return list
})

const ITEMS_PER_PAGE = 12
const currentPage = ref(1)
const totalPages = computed(() => Math.max(1, Math.ceil(filteredVehicles.value.length / ITEMS_PER_PAGE)))
const paginatedVehicles = computed(() => {
  const list = filteredVehicles.value
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE
  return list.slice(start, start + ITEMS_PER_PAGE)
})
const showingRange = computed(() => {
  const total = filteredVehicles.value.length
  if (total === 0) return 'Showing 0 of ' + vehicles.value.length + ' vehicles'
  const start = (currentPage.value - 1) * ITEMS_PER_PAGE + 1
  const end = Math.min(currentPage.value * ITEMS_PER_PAGE, total)
  return total <= ITEMS_PER_PAGE
    ? `Showing ${total} of ${vehicles.value.length} vehicles`
    : `Showing ${start}–${end} of ${total} vehicles`
})

watch([search, () => filters.value], () => { currentPage.value = 1 })

function resetFilters() {
  filters.value = { location: 'All', carType: 'All', seats: 'All', transmission: 'All', priceMin: undefined, priceMax: undefined }
}

const deleteMessage = computed(() =>
  vehicleToDelete.value ? `Remove "${vehicleToDelete.value.name}"? This will no longer show on the client browse page.` : ''
)

function buildName() {
  const b = form.value.brand?.trim()
  const m = form.value.model?.trim()
  if (b && m) return `${b} ${m}`
  return form.value.name || 'Vehicle'
}

function openAdd() {
  editingId.value = null
  mainImageFiles.value = null
  sideImageFiles.value = { front: null, rear: null, left: null, right: null }
  additionalImageFiles.value = null
  form.value = {
    name: '',
    businessName: '',
    brand: '',
    model: '',
    carNumber: '',
    businessPermitNumber: '',
    carType: 'Sedan',
    status: 'Available',
    capacity: 4,
    pricePerDay: 2000,
    overdueChargeRate: 500,
    securityDeposit: undefined,
    transmission: 'Automatic',
    fuelType: 'Gasoline',
    fuelReturnPolicy: 'Return with Same Level',
    rentalMode: 'both',
    minRentalPeriodHours: 24,
    description: '',
    image: 'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800&q=80&fit=crop',
    additionalImagesStr: '',
    imageFront: '',
    imageRear: '',
    imageLeft: '',
    imageRight: '',
    knownIssues: '',
    type: 'Car',
    location: 'Vigan',
    approved: true,
    featured: false,
    verified: true,
    hasPermit: !!form.value.businessPermitNumber,
  }
  showForm.value = true
}

function openEdit(v: VehicleSeedItem) {
  editingId.value = v.id
  mainImageFiles.value = null
  sideImageFiles.value = { front: null, rear: null, left: null, right: null }
  additionalImageFiles.value = null
  const additional = v.additionalImages && v.additionalImages.length ? v.additionalImages.join(', ') : ''
  const four = v.imagesFourSides
  form.value = {
    name: v.name,
    businessName: v.businessName ?? v.hostName ?? '',
    brand: v.brand ?? '',
    model: v.model ?? '',
    carNumber: v.carNumber ?? '',
    businessPermitNumber: v.businessPermitNumber ?? '',
    carType: (v.carType as string) ?? 'Sedan',
    status: v.status ?? 'Available',
    capacity: v.capacity ?? 4,
    pricePerDay: v.pricePerDay,
    overdueChargeRate: v.overdueChargeRate ?? 500,
    securityDeposit: v.securityDeposit,
    transmission: (v.transmission as string) ?? 'Automatic',
    fuelType: (v.fuelType as string) ?? 'Gasoline',
    fuelReturnPolicy: (v.fuelReturnPolicy as string) ?? 'Return with Same Level',
    rentalMode: (v.rentalMode ?? 'both') as string,
    minRentalPeriodHours: v.minRentalPeriodHours ?? 24,
    description: v.description ?? '',
    image: v.image,
    additionalImagesStr: additional,
    imageFront: four?.front ?? '',
    imageRear: four?.rear ?? '',
    imageLeft: four?.left ?? '',
    imageRight: four?.right ?? '',
    knownIssues: v.knownIssues ?? '',
    type: v.type,
    location: v.location ?? 'Vigan',
    approved: v.approved ?? true,
    featured: v.featured ?? false,
    verified: v.verified ?? false,
    hasPermit: v.hasPermit ?? !!v.businessPermitNumber,
  }
  showForm.value = true
}

async function saveVehicle() {
  const name = form.value.name || buildName()
  const additionalUrls = form.value.additionalImagesStr
    ? form.value.additionalImagesStr.split(',').map(s => s.trim()).filter(Boolean).slice(0, 5)
    : undefined
  const front = form.value.imageFront?.trim()
  const rear = form.value.imageRear?.trim()
  const left = form.value.imageLeft?.trim()
  const right = form.value.imageRight?.trim()
  const imagesFourSides =
    front && rear && left && right
      ? { front, rear, left, right }
      : undefined
  const payload: Partial<VehicleSeedItem> = {
    name,
    type: form.value.type,
    location: form.value.location,
    pricePerDay: sanitizePrice(form.value.pricePerDay),
    description: form.value.description,
    image: form.value.image,
    hostName: form.value.businessName || undefined,
    businessName: form.value.businessName || undefined,
    approved: form.value.approved,
    featured: form.value.featured,
    verified: form.value.verified,
    hasPermit: !!form.value.businessPermitNumber,
    brand: form.value.brand || undefined,
    model: form.value.model || undefined,
    carNumber: form.value.carNumber || undefined,
    businessPermitNumber: form.value.businessPermitNumber || undefined,
    carType: form.value.carType as VehicleSeedItem['carType'],
    status: form.value.status,
    capacity: form.value.capacity != null ? sanitizeQuantity(form.value.capacity, { min: 1, max: 20 }) : undefined,
    overdueChargeRate: form.value.overdueChargeRate != null ? sanitizePrice(form.value.overdueChargeRate) : undefined,
    securityDeposit: form.value.securityDeposit != null ? sanitizePrice(form.value.securityDeposit) : undefined,
    transmission: form.value.transmission as VehicleSeedItem['transmission'],
    fuelType: form.value.fuelType as VehicleSeedItem['fuelType'],
    fuelReturnPolicy: form.value.fuelReturnPolicy as VehicleSeedItem['fuelReturnPolicy'],
    rentalMode: form.value.rentalMode as VehicleSeedItem['rentalMode'],
    minRentalPeriodHours: form.value.minRentalPeriodHours != null ? sanitizeQuantity(form.value.minRentalPeriodHours, { min: 1, max: 8760 }) : undefined,
    additionalImages: additionalUrls?.length ? additionalUrls : undefined,
    imagesFourSides,
    knownIssues: form.value.knownIssues?.trim() || undefined,
  }
  if (editingId.value) {
    const updated = await update(editingId.value, payload)
    if (updated) {
      toast.success('Vehicle updated.')
      showForm.value = false
    } else {
      toast.error('Could not update vehicle. Please try again.')
    }
  } else {
    const created = await add({ ...payload, status: 'Available' } as Omit<VehicleSeedItem, 'id'>)
    if (created) {
      toast.success('Vehicle added. It will appear on the client browse page.')
      showForm.value = false
    } else {
      toast.error('Could not add vehicle. Please try again.')
    }
  }
}

function openViewDetail(v: VehicleSeedItem) {
  selectedVehicle.value = v
  detailSelectedImage.value = v.image
  showDetailDialog.value = true
}

function confirmDelete(v: VehicleSeedItem) {
  vehicleToDelete.value = v
  showDeleteConfirm.value = true
}

async function doDelete() {
  if (vehicleToDelete.value) {
    const id = vehicleToDelete.value.id
    vehicleToDelete.value = null
    showDeleteConfirm.value = false
    const result = await remove(id)
    if (result.ok) {
      toast.success('Vehicle removed.')
    } else {
      toast.error(result.message || 'Could not remove vehicle. Please try again.')
    }
  } else {
    showDeleteConfirm.value = false
  }
}
</script>

<style scoped>
.vehicle-listings-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 0.75rem;
}
.vehicle-listings-header .page-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
}
.header-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.header-date {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
}
.vehicle-listings-toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1rem;
  margin-bottom: 0.75rem;
}
.search-field {
  max-width: 320px;
}
.toolbar-right {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.vehicle-filters-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
  margin-top: 0.75rem;
  margin-bottom: 1rem;
  padding-top: 0.25rem;
}
.vehicle-filters-bar .filter-field {
  min-width: 120px;
}
.vehicle-filters-bar .filter-price {
  max-width: 100px;
}
.owners-filter {
  font-size: 0.9375rem;
  font-weight: 500;
  color: var(--text-secondary, #64748b);
}
.showing-count {
  font-size: 0.875rem;
  color: var(--text-secondary, #64748b);
  margin-bottom: 1rem;
}
.vehicle-listing-card__image {
  position: relative;
  overflow: hidden;
  border-radius: 12px 12px 0 0;
}
.vehicle-listing-card__type {
  position: absolute;
  top: 8px;
  left: 8px;
  background: rgba(0,0,0,0.6);
  color: #fff;
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 0.75rem;
}
.vehicle-listing-card__watermark {
  position: absolute;
  bottom: 8px;
  left: 8px;
  right: 8px;
  font-size: 0.7rem;
  color: rgba(255,255,255,0.85);
  text-shadow: 0 1px 2px rgba(0,0,0,0.6);
  pointer-events: none;
  z-index: 1;
}
.vehicle-listing-card__rental-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  z-index: 2;
}
.vehicle-listing-card__name {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 2px 0;
}
.vehicle-listing-card__plate {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 4px 0;
}
.vehicle-listing-card__business {
  font-size: 0.875rem;
  font-weight: 500;
  margin: 0 0 8px 0;
}
.vehicle-listing-card__pricing {
  margin-bottom: 6px;
}
.vehicle-listing-card__pricing .daily-price {
  font-size: 1.125rem;
  font-weight: 700;
  color: rgb(var(--v-theme-primary));
}
.vehicle-listing-card__pricing .overdue {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin-left: 8px;
}
.vehicle-listing-card__specs {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin-bottom: 8px;
}
.vehicle-listing-card__specs .dot {
  margin: 0 4px;
}
.vehicle-listing-card__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 4px;
}
.vehicle-listing-card__permit {
  font-size: 0.75rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 4px 0;
}
.vehicle-listing-card__reviews {
  font-size: 0.8125rem;
  color: var(--text-secondary, #64748b);
  margin: 0 0 8px 0;
}
.vehicle-listing-card__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding-top: 8px;
  border-top: 1px solid rgba(0,0,0,0.08);
}

/* Action buttons: thin border with respective colors (not flat) */
.action-btn {
  min-width: auto;
  font-weight: 600;
  text-transform: none;
  border-width: 1.5px !important;
}
.action-btn--primary { border-color: rgb(var(--v-theme-primary)) !important; }
.action-btn--edit { border-color: var(--metallic-dark, #64748b) !important; color: var(--text-secondary, #64748b) !important; }
.action-btn--error { border-color: rgb(var(--v-theme-error)) !important; }
.btn-bordered {
  border-width: 1.5px !important;
  font-weight: 600;
}

.form-section-label {
  font-size: 0.875rem;
  font-weight: 600;
  margin: 0 0 8px 0;
  color: var(--text-primary, #1F2937);
}

/* Vehicle Details dialog */
.vehicle-detail-dialog__title { font-size: 1.125rem; font-weight: 700; }
.vehicle-detail-dialog__body { max-height: 70vh; overflow-y: auto; }
.vehicle-detail-dialog__gallery { }
.vehicle-detail-dialog__hero { border-radius: 8px; overflow: hidden; }
.vehicle-detail-dialog__four-sides {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}
.detail-side-thumb {
  display: flex;
  flex-direction: column;
  align-items: center;
  border: 2px solid transparent;
  border-radius: 8px;
  padding: 4px;
  background: transparent;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.detail-side-thumb:hover { border-color: rgba(30, 58, 95, 0.3); box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
.detail-side-thumb--active { border-color: rgb(var(--v-theme-primary)); box-shadow: 0 0 0 2px rgba(var(--v-theme-primary), 0.2); }
.detail-side-thumb__label { font-size: 0.6875rem; font-weight: 600; margin-top: 4px; }
.detail-section { background: rgba(0,0,0,0.03); }
.detail-section--warning { background: rgba(245, 158, 11, 0.08); }
.detail-label { font-weight: 600; margin-right: 4px; color: var(--text-secondary, #64748b); }
</style>
