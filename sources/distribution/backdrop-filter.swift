
//
//  SDKit: Backdrop Filter
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A layer that filters the content behind it.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDBackdropFilter: View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The brightness of the content.
	///
	internal let brightness: CGFloat?
	
	/// The contrast of the content.
	///
	internal let contrast: CGFloat?
	
	/// The grayscale value of the content.
	///
	internal let grayscale: CGFloat?
	
	/// Invert the content.
	///
	internal let invert: Bool?
	
	/// The opacity of the content.
	///
	internal let opacity: CGFloat?
	
	/// Make the content blur opaque.
	///
	internal let opaque: Bool?
	
	/// The radius of the content blur.
	///
	internal let radius: CGFloat?
	
	/// The saturation of the content.
	///
	internal let saturation: CGFloat?
	
	/// The color to tint the content.
	///
	internal let tint: Color?
	
	/// Clip the filter.
	///
	internal let clip: Bool?
	
	/// Applies some filters to a ``SDBackdrop`` layer.
	///
	public var body: some View {
		
		SDBackdrop ( )
			.brightness ( self.brightness ?? self.defaults.filters.brightness )
			.blur ( radius: self.radius ?? self.defaults.filters.radius, opaque: self.opaque ?? self.defaults.filters.opaque )
			.contrast ( self.contrast ?? self.defaults.filters.contrast )
			.grayscale ( self.grayscale ?? self.defaults.filters.grayscale )
			.saturation ( self.saturation ?? self.defaults.filters.saturation )
			.opacity ( self.opacity ?? self.defaults.filters.opacity )
			.overlay ( self.tint ?? self.defaults.filters.tint.auto )
			.if ( self.invert ?? self.defaults.filters.invert ) { $0.colorInvert ( ) }
			.if ( self.clip ?? self.defaults.filters.clip ) { $0.clipped ( antialiased: self.defaults.optimizations.antialiasing ) }
		
	}
	
	/// Creates an ``SDBackdropFilter`` instance from some filter values.
	///
	/// - Parameters:
	///   - brightness: The brightness of the content.
	///   - contrast: The contrast of the content.
	///   - grayscale: The grayscale value of the content.
	///   - invert: Invert the content.
	///   - opacity: The opacity of the content.
	///   - opaque: Make the content blur opaque.
	///   - radius: The radius of the content blur.
	///   - saturation: The saturation of the content.
	///   - tint: The color to tint the content.
	///   - clip: Clip the filter.
	///
	public init (
		
		brightness: CGFloat? = nil,
		contrast: CGFloat? = nil,
		grayscale: CGFloat? = nil,
		invert: Bool? = nil,
		opacity: CGFloat? = nil,
		opaque: Bool? = nil,
		radius: CGFloat? = nil,
		saturation: CGFloat? = nil,
		tint: Color? = nil,
		clip: Bool? = nil
		
	) {
		
		self.contrast = contrast
		self.brightness = brightness
		self.grayscale = grayscale
		self.invert = invert
		self.opacity = opacity
		self.opaque = opaque
		self.radius = radius
		self.saturation = saturation
		self.tint = tint
		self.clip = clip
		
	}
	
}

//
//
