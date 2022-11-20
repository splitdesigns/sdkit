
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
	private let brightness: CGFloat?
	
	/// The grayscale value of the filter.
	///
	private let grayscale: CGFloat?
	
	/// The saturation of the filter.
	///
	private let saturation: CGFloat?
	
	/// The contrast of the filter.
	///
	private let contrast: CGFloat?
	
	/// Determines whether the content will be inverted.
	///
	private let invert: Bool?
	
	/// The blur radius of the filter.
	///
	private let radius: CGFloat?
	
	/// Whether the filter blur should be opaque.
	///
	private let opaque: Bool?
	
	/// The tint color of the filter.
	///
	private let tint: Color?
	
	/// The opacity of the filter.
	///
	private let opacity: CGFloat?
	
	/// Applies the filters to a ``SDBackdrop`` view.
	///
	public var body: some View {
		
		SDBackdrop ( )
			.brightness ( self.brightness ?? self.defaults.filters.brightness )
			.grayscale ( self.grayscale ?? self.defaults.filters.grayscale )
			.saturation ( self.saturation ?? self.defaults.filters.saturation )
			.contrast ( self.contrast ?? self.defaults.filters.contrast )
			.if ( self.invert ?? self.defaults.filters.invert ) { $0.colorInvert ( ) }
			.blur ( radius: self.radius ?? self.defaults.filters.radius, opaque: self.opaque ?? self.defaults.filters.opaque )
			.overlay ( self.tint ?? self.defaults.filters.tint )
			.opacity ( self.opacity ?? self.defaults.filters.opacity )
			.clipped ( antialiased: true )
		
	}
	
	/// Creates a ``SDBackdropFilter`` from a set of filter values.
	///
	/// - Parameter brightness: The brightness of the filter.
	/// - Parameter grayscale: The grayscale value of the filter.
	/// - Parameter saturation: The saturation of the filter.
	/// - Parameter contrast: The contrast of the filter.
	/// - Parameter invert: Determines whether the content should be inverted.
	/// - Parameter radius: The blur radius of the filter.
	/// - Parameter opaque: Whether the filter blur should be opaque.
	/// - Parameter tint: The tint color of the filter.
	/// - Parameter opacity: The opacity of the filter.
	///
	public init (
		
		brightness: CGFloat? = nil,
		grayscale: CGFloat? = nil,
		saturation: CGFloat? = nil,
		contrast: CGFloat? = nil,
		invert: Bool? = nil,
		radius: CGFloat? = nil,
		opaque: Bool? = nil,
		tint: Color? = nil,
		opacity: CGFloat? = nil
		
	) {
		
		self.brightness = brightness
		self.grayscale = grayscale
		self.saturation = saturation
		self.contrast = contrast
		self.invert = invert
		self.radius = radius
		self.opaque = opaque
		self.tint = tint
		self.opacity = opacity
		
	}
	
}

//
//
