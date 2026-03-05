/**
 * Read image dimensions from local PNG/JPEG files.
 * Usage: node scripts/get-image-dimensions.js
 */

const fs = require('fs')
const path = require('path')

const root = path.join(__dirname, '..', 'public')

function getPngDimensions(buf) {
  if (buf.length < 24) return null
  return {
    width: buf.readUInt32BE(16),
    height: buf.readUInt32BE(20),
  }
}

function getJpegDimensions(buf) {
  let i = 2
  while (i < buf.length - 9) {
    if (buf[i] === 0xff && (buf[i + 1] === 0xc0 || buf[i + 1] === 0xc2)) {
      return {
        height: buf.readUInt16BE(i + 5),
        width: buf.readUInt16BE(i + 7),
      }
    }
    i++
  }
  return null
}

function getDimensions(filePath) {
  const buf = fs.readFileSync(filePath)
  if (buf[0] === 0x89 && buf[1] === 0x50 && buf[2] === 0x4e) {
    return { ...getPngDimensions(buf), format: 'PNG' }
  }
  if (buf[0] === 0xff && buf[1] === 0xd8) {
    return { ...getJpegDimensions(buf), format: 'JPEG' }
  }
  return { width: null, height: null, format: 'unknown' }
}

const images = [
  'logo.png',
  'images/hero-banner.png',
  'images/hero-adventure.png',
  'images/explore-philippines.png',
  'images/beat-the-traffic.png',
  'images/hero-grid.png',
  'images/hero-bg.png',
  'images/partners/aims-healthcare.png',
  'images/partners/amg-victoria.png',
  'images/partners/awesome-healthcare.png',
  'images/partners/denat-support-services.png',
  'images/partners/filled-with-hope.png',
  'images/partners/inclusive-abilities-care.png',
  'images/people/caregiver-elderly.png',
  'images/people/client-hearing-aid.png',
  'images/people/engagement-phone.png',
]

const results = []
for (const rel of images) {
  const full = path.join(root, rel)
  if (!fs.existsSync(full)) {
    results.push({ path: rel, error: 'file not found' })
    continue
  }
  try {
    const d = getDimensions(full)
    const ratio = d.width && d.height ? (d.width / d.height).toFixed(4) : null
    results.push({
      path: rel,
      width: d.width,
      height: d.height,
      aspectRatio: ratio,
      format: d.format,
    })
  } catch (e) {
    results.push({ path: rel, error: e.message })
  }
}

console.log(JSON.stringify(results, null, 2))
