import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useUserSessionStore } from '@/stores/userSession'
import { CAR_OWNER_AGREEMENT, CLIENT_RENTAL_AGREEMENT } from '@/constants/platformAgreement'

const STORAGE_KEY_CAR_OWNER = 'bulodph_car_owner_agreement_v'
const STORAGE_KEY_CLIENT = 'bulodph_client_rental_agreement_v'

function getKeyPrefix(baseKey: string, userId: string | undefined): string {
  return `${baseKey}_${userId ?? 'guest'}_`
}

function getAcceptedVersion(keyPrefix: string): string | null {
  try {
    return localStorage.getItem(keyPrefix + 'accepted')
  } catch {
    return null
  }
}

function setAcceptedVersion(keyPrefix: string, version: string) {
  try {
    localStorage.setItem(keyPrefix + 'accepted', version)
    localStorage.setItem(keyPrefix + 'accepted_at', new Date().toISOString())
  } catch {
    // ignore
  }
}

export const useAgreementAcceptanceStore = defineStore('agreementAcceptance', () => {
  const userSession = useUserSessionStore()
  const carOwnerVersion = CAR_OWNER_AGREEMENT.version
  const clientVersion = CLIENT_RENTAL_AGREEMENT.version

  /** Bump after accept so computed re-reads from localStorage */
  const acceptStamp = ref(0)

  const carOwnerKeyPrefix = computed(
    () => getKeyPrefix(STORAGE_KEY_CAR_OWNER, userSession.user?.id)
  )
  const clientKeyPrefix = computed(
    () => getKeyPrefix(STORAGE_KEY_CLIENT, userSession.user?.id)
  )

  const carOwnerAccepted = computed(() => {
    acceptStamp.value // dependency
    return getAcceptedVersion(carOwnerKeyPrefix.value)
  })
  const clientAccepted = computed(() => {
    acceptStamp.value
    return getAcceptedVersion(clientKeyPrefix.value)
  })

  const hasAcceptedCarOwnerAgreement = computed(() => carOwnerAccepted.value === carOwnerVersion)
  const hasAcceptedClientRentalAgreement = computed(() => clientAccepted.value === clientVersion)

  function acceptCarOwnerAgreement() {
    setAcceptedVersion(carOwnerKeyPrefix.value, carOwnerVersion)
    acceptStamp.value++
  }

  function acceptClientRentalAgreement() {
    setAcceptedVersion(clientKeyPrefix.value, clientVersion)
    acceptStamp.value++
  }

  return {
    hasAcceptedCarOwnerAgreement,
    hasAcceptedClientRentalAgreement,
    acceptCarOwnerAgreement,
    acceptClientRentalAgreement,
    carOwnerVersion,
    clientVersion,
  }
})
