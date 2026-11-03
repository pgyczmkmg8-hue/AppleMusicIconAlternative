// usage: swift make_variants.swift <in.png> <out-dir>
// Writes icon_dark.png (dimmed) and icon_tinted.png (greyscale) next to each other, opaque 1024px.
import Foundation
import CoreImage
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let args = CommandLine.arguments
// no colour management, so the flip happens on the stored sRGB values instead of linear light
let src = CIImage(contentsOf: URL(fileURLWithPath: args[1]), options: [.colorSpace: NSNull()])!
let context = CIContext(options: [.workingColorSpace: NSNull()])
let space = CGColorSpace(name: CGColorSpace.sRGB)!

func write(_ image: CIImage, _ name: String) {
	let rect = src.extent
	let cg = context.createCGImage(image, from: rect, format: .RGBX8, colorSpace: space)!
	let url = URL(fileURLWithPath: args[2]).appendingPathComponent(name)
	let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
	CGImageDestinationAddImage(dest, cg, nil)
	CGImageDestinationFinalize(dest)
	print("wrote \(name) \(cg.width)x\(cg.height)")
}

// pull the near-black left by the flip down to pure black
func levels(_ image: CIImage) -> CIImage {
	let f = CIFilter(name: "CIColorMatrix")!
	f.setValue(image, forKey: kCIInputImageKey)
	f.setValue(CIVector(x: 1.08, y: 0, z: 0, w: 0), forKey: "inputRVector")
	f.setValue(CIVector(x: 0, y: 1.08, z: 0, w: 0), forKey: "inputGVector")
	f.setValue(CIVector(x: 0, y: 0, z: 1.08, w: 0), forKey: "inputBVector")
	f.setValue(CIVector(x: 0, y: 0, z: 0, w: 1), forKey: "inputAVector")
	f.setValue(CIVector(x: -0.08, y: -0.08, z: -0.08, w: 0), forKey: "inputBiasVector")
	return f.outputImage!
}

// dark: flip the lightness but keep the hues, so the white icon becomes a black one with a light note
let invert = CIFilter(name: "CIColorInvert")!
invert.setValue(src, forKey: kCIInputImageKey)
let hue = CIFilter(name: "CIHueAdjust")!
hue.setValue(invert.outputImage!, forKey: kCIInputImageKey)
hue.setValue(Double.pi, forKey: kCIInputAngleKey)
write(levels(hue.outputImage!), "icon_dark.png")

// tinted: greyscale with the same flip, iOS maps its luminance onto the chosen tint
let grey = CIFilter(name: "CIColorControls")!
grey.setValue(invert.outputImage!, forKey: kCIInputImageKey)
grey.setValue(0.0, forKey: kCIInputSaturationKey)
write(levels(grey.outputImage!), "icon_tinted.png")
