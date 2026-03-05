export const MOCK_SHIFT_CLIENTS = [
  { id: 1, name: 'Mary Johnson' },
  { id: 2, name: 'Robert Williams' },
  { id: 3, name: 'Patricia Miller' },
  { id: 4, name: 'James Anderson' },
]

export const MOCK_SHIFT_STAFF = [
  { id: 1, name: 'John Smith' },
  { id: 2, name: 'Sarah Davis' },
  { id: 3, name: 'Michael Brown' },
  { id: 4, name: 'Emily Wilson' },
]

export const MOCK_SHIFTS = [
  {
    id: '1',
    client: { full_name: 'Mary Johnson', suburb: 'Sydney', address_line_1: '123 Main St', latitude: -33.8688, longitude: 151.2093 },
    staff_name: 'John Smith',
    scheduled_start: new Date(2026, 0, 27, 9, 0).toISOString(),
    scheduled_end: new Date(2026, 0, 27, 13, 0).toISOString(),
    status: 'BOOKED',
    notes: 'Regular support session',
  },
  {
    id: '2',
    client: { full_name: 'Robert Williams', suburb: 'Melbourne', address_line_1: '456 Oak Ave', latitude: -37.8136, longitude: 144.9631 },
    staff_name: 'Sarah Davis',
    scheduled_start: new Date(2026, 0, 27, 14, 0).toISOString(),
    scheduled_end: new Date(2026, 0, 27, 18, 0).toISOString(),
    status: 'INVOICED',
    notes: 'Personal care',
  },
  {
    id: '3',
    client: { full_name: 'Patricia Miller', suburb: 'Brisbane', address_line_1: '789 Pine Rd', latitude: -27.4698, longitude: 153.0251 },
    staff_name: 'Michael Brown',
    scheduled_start: new Date(2026, 0, 28, 10, 0).toISOString(),
    scheduled_end: new Date(2026, 0, 28, 14, 0).toISOString(),
    status: 'PENDING',
    notes: 'Community access',
  },
  {
    id: '4',
    client: { full_name: 'James Anderson', suburb: 'Perth', address_line_1: '321 Elm St', latitude: -31.9505, longitude: 115.8605 },
    staff_name: 'Emily Wilson',
    scheduled_start: new Date(2026, 0, 29, 9, 0).toISOString(),
    scheduled_end: new Date(2026, 0, 29, 12, 0).toISOString(),
    status: 'BOOKED',
    notes: 'Therapy session',
  },
  {
    id: '5',
    client: { full_name: 'Mary Johnson', suburb: 'Sydney', address_line_1: '123 Main St', latitude: -33.8688, longitude: 151.2093 },
    staff_name: null,
    scheduled_start: new Date(2026, 0, 30, 15, 0).toISOString(),
    scheduled_end: new Date(2026, 0, 30, 19, 0).toISOString(),
    status: 'PENDING',
    notes: 'Evening support',
  },
]
