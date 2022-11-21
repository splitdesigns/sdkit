
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
	
	/// Access to the ``SDDefaults`` struct.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The brightness of the filter.
	///
	public let brightness: CGFloat?
	
	/// The contrast of the filter.
	///
	public let contrast: CGFloat?
	
	/// The grayscale value of the filter.
	///
	public let grayscale: CGFloat?
	
	/// Determines whether the content will be inverted.
	///
	public let invert: Bool?
	
	/// The opacity of the filter.
	///
	public let opacity: CGFloat?
	
	/// Whether the filter blur should be opaque.
	///
	public let opaque: Bool?
	
	/// The blur radius of the filter.
	///
	public let radius: CGFloat?
	
	/// The saturation of the filter.
	///
	public let saturation: CGFloat?
	
	/// The tint color of the filter.
	///
	public let tint: Color?
	
	/// Applies the filters to a ``SDBackdrop`` view.
	///
	public var body: some View {
		
		SDBackdrop ( )
			.brightness ( self.brightness ?? self.defaults.filters.brightness )
			.blur ( radius: self.radius ?? self.defaults.filters.radius, opaque: self.opaque ?? self.defaults.filters.opaque )
			.contrast ( self.contrast ?? self.defaults.filters.contrast )
			.grayscale ( self.grayscale ?? self.defaults.filters.grayscale )
			.saturation ( self.saturation ?? self.defaults.filters.saturation )
			.opacity ( self.opacity ?? self.defaults.filters.opacity )
			.overlay ( self.tint ?? self.defaults.filters.tint )
			.if ( self.invert ?? self.defaults.filters.invert ) { $0.colorInvert ( ) }
			.clipped ( antialiased: true )
		
	}
	
	/// Creates a ``SDBackdropFilter`` from a set of filter values.
	///
	/// - Parameter brightness: The brightness of the filter.
	/// - Parameter contrast: The contrast of the filter.
	/// - Parameter grayscale: The grayscale value of the filter.
	/// - Parameter invert: Determines whether the content should be inverted.
	/// - Parameter opacity: The opacity of the filter.
	/// - Parameter opaque: Whether the filter blur should be opaque.
	/// - Parameter radius: The blur radius of the filter. 
	/// - Parameter saturation: The saturation of the filter.
	/// - Parameter tint: The tint color of the filter.
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
		tint: Color? = nil
		
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
		
	}
	
}

//
//
