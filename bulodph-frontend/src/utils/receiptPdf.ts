import { jsPDF } from 'jspdf'
import type { ClientBooking } from '@/stores/clientBookings'
import { formatPrice } from '@/utils/priceFormat'

export function generateReceiptPdf(booking: ClientBooking): void {
  const doc = new jsPDF()
  const pageWidth = (doc as any).internal.pageSize.getWidth()
  let y = 20

  // Header
  doc.setFontSize(22)
  doc.setFont('helvetica', 'bold')
  doc.text('BulodPH', pageWidth / 2, y, { align: 'center' })
  y += 8

  doc.setFontSize(12)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(100, 116, 139)
  doc.text('Rental Receipt', pageWidth / 2, y, { align: 'center' })
  y += 20

  doc.setTextColor(15, 23, 42)

  const rows: [string, string][] = [
    ['Booking ID', booking.id],
    ['Vehicle', booking.vehicleName],
    ['Dates', `${booking.start} – ${booking.end}`],
    ['Location', booking.location],
    ['Car rental', booking.hostName ?? '—'],
    ['Total paid', formatPrice(booking.total)],
    ['Status', booking.status],
  ]

  doc.setFontSize(11)
  rows.forEach(([label, value]) => {
    doc.setFont('helvetica', 'normal')
    doc.setTextColor(100, 116, 139)
    doc.text(label + ':', 20, y)
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(15, 23, 42)
    doc.text(value, pageWidth - 20, y, { align: 'right' })
    y += 10
  })

  y += 5
  doc.setDrawColor(226, 232, 240)
  doc.line(20, y, pageWidth - 20, y)
  y += 15

  doc.setFontSize(9)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(100, 116, 139)
  doc.text(`Generated ${new Date().toLocaleString('en-PH')} · BulodPH – Car rental marketplace`, pageWidth / 2, y, { align: 'center' })

  doc.save(`bulodph-receipt-${booking.id}.pdf`)
}
