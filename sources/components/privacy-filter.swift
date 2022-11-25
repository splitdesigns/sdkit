
//
//  SDKit: Privacy Filter
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A filter that redacts sensitive content when the app moves to the background.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDPrivacyFilter: ViewModifier {
	
	/// Access to the defaults object.
	///
	@Environment ( \.defaults ) private var defaults
	
	/// Access to the device's scene phase.
	///
	@Environment ( \.scenePhase ) private var scenePhase
	
	/// Sets the state of privacy layer, ignoring the device's scene phase.
	///
	private let override: Bool?
	
	/// Sets the animation for the filter.
	///
	private let animation: Animation?
	
	/// A configuration for the privacy filter.
	///
	private let filter: SDBackdropFilter
	
	/// Whether or not to obscure the content.
	///
	private var active: Bool { return self.override != nil ? self.override! : self.scenePhase != .active }
	
	/// Animates a filter that redacts content based on the device's scene phase.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.overlay { SDBackdropFilter (
				
				brightness: self.active ? ( self.filter.brightness ?? self.defaults.filters.brightness ) : 0.0,
				contrast: self.active ? ( self.filter.contrast ?? self.defaults.filters.contrast ) : 1.0,
				grayscale: self.active ? ( self.filter.grayscale ?? self.defaults.filters.grayscale ) : 0.0,
				invert: self.active ? ( self.filter.invert ?? self.defaults.filters.invert ) : false,
				opacity: self.active ? ( self.filter.opacity ?? self.defaults.filters.opacity ) : 1.0,
				opaque: self.active ? ( self.filter.opaque ?? self.defaults.filters.opaque ) : true,
				radius: self.active ? ( self.filter.radius ?? self.defaults.filters.radius ) : 0.0,
				saturation: self.active ? ( self.filter.saturation ?? self.defaults.filters.saturation ) : 1.0,
				tint: self.active ? ( self.filter.tint ?? self.defaults.filters.tint ) : .clear
				
			) .allowsHitTesting ( self.active ) }
			.animation ( self.animation ?? self.defaults.animations.primary, value: self.active )
		
	}
	
	/// Creates a ``SDPrivacyFilter`` from a set of values.
	///
	/// - Parameters:
	///   - override: Sets the state of privacy layer, ignoring the device's scene phase.
	///   - animation: Sets the animation for the filter.
	///   - filter: A configuration for the privacy filter.
	///
	public init ( override: Bool? = nil, animation: Animation? = nil, filter: SDBackdropFilter = .init ( ) ) {
		
		self.override = override
		self.animation = animation
		self.filter = filter
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// A filter that redacts sensitive content when the app moves to the background.
	///
	/// - Warning: Uses a private API.
	///
	/// - Parameters:
	///   - override: Sets the state of privacy layer, ignoring the device's scene phase.
	///   - animation: Sets the animation for the filter.
	///   - filter: A configuration for the privacy filter.
	///
	func sensitive ( override: Bool? = nil, animation: Animation? = nil, filter: SDBackdropFilter = .init ( ) ) -> some View { self.modifier ( SDPrivacyFilter ( override: override, animation: animation, filter: filter ) ) }
	
}

//
//
