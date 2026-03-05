Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$inputPath = "C:/Users/Cocotantan/Downloads/PROJECT POVERTY/bulodph-frontend/public/images/section-fullwidth.png"
$outputPath = $inputPath

$bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
$bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
$bitmap.UriSource = New-Object System.Uri($inputPath)
$bitmap.EndInit()
$bitmap.Freeze()

$format = [System.Windows.Media.PixelFormats]::Bgra32
$converted = New-Object System.Windows.Media.Imaging.FormatConvertedBitmap($bitmap, $format, $null, 0)
$width = $converted.PixelWidth
$height = $converted.PixelHeight
$stride = [int](($width * $format.BitsPerPixel + 7) / 8)
$pixels = New-Object byte[] ($stride * $height)
$converted.CopyPixels($pixels, $stride, 0)

function Get-Index([int]$x, [int]$y, [int]$stride) {
    return ($y * $stride) + ($x * 4)
}

$x0 = 0
$y0 = 0
$x1 = [Math]::Min(160, $width - 1)
$y1 = [Math]::Min(70, $height - 1)
$offsetY = 100

for ($y = $y0; $y -le $y1; $y++) {
    for ($x = $x0; $x -le $x1; $x++) {
        $srcY = [Math]::Min($height - 1, $y + $offsetY)
        $srcIdx = Get-Index $x $srcY $stride
        $dstIdx = Get-Index $x $y $stride

        $pixels[$dstIdx] = $pixels[$srcIdx]
        $pixels[$dstIdx + 1] = $pixels[$srcIdx + 1]
        $pixels[$dstIdx + 2] = $pixels[$srcIdx + 2]
        $pixels[$dstIdx + 3] = $pixels[$srcIdx + 3]
    }
}

$writeable = New-Object System.Windows.Media.Imaging.WriteableBitmap($converted)
$rect = New-Object System.Windows.Int32Rect(0, 0, $width, $height)
$writeable.WritePixels($rect, $pixels, $stride, 0)

$encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
$encoder.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($writeable))
$stream = [System.IO.File]::Open($outputPath, [System.IO.FileMode]::Create)
$encoder.Save($stream)
$stream.Close()
