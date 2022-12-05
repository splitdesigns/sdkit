
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
	
	/// Sets the state of privacy layer regardless of the device's scene phase.
	///
	private let override: Bool?
	
	/// The timing curve for animating filter changes.
	///
	private let timingCurve: Animation?
	
	/// A configuration for the privacy filter.
	///
	private let configuration: SDBackdropFilter
	
	/// Whether or not to obscure the content.
	///
	private var active: Bool { return self.override != nil ? self.override! : self.scenePhase != .active }
	
	/// Animates a filter that redacts content based on the device's scene phase.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.overlay { SDBackdropFilter (
				
				brightness: self.active ? ( self.configuration.brightness ?? self.defaults.filters.brightness ) : 0.0,
				clip: self.active ? ( self.configuration.clip ?? self.defaults.filters.clip ) : true,
				contrast: self.active ? ( self.configuration.contrast ?? self.defaults.filters.contrast ) : 1.0,
				grayscale: self.active ? ( self.configuration.grayscale ?? self.defaults.filters.grayscale ) : 0.0,
				invert: self.active ? ( self.configuration.invert ?? self.defaults.filters.invert ) : false,
				opacity: self.active ? ( self.configuration.opacity ?? self.defaults.filters.opacity ) : 1.0,
				opaque: self.active ? ( self.configuration.opaque ?? self.defaults.filters.opaque ) : true,
				radius: self.active ? ( self.configuration.radius ?? self.defaults.filters.radius ) : 0.0,
				saturation: self.active ? ( self.configuration.saturation ?? self.defaults.filters.saturation ) : 1.0,
				tint: self.active ? ( self.configuration.tint ?? self.defaults.filters.tint ) : .clear
				
			) .allowsHitTesting ( self.active ) }
			.animation ( self.timingCurve ?? self.defaults.animations.primary, value: self.active )
		
	}
	
	/// Creates a ``SDPrivacyFilter`` from a set of values.
	///
	/// - Parameters:
	///   - override: Sets the state of privacy layer regardless of the device's scene phase.
	///   - animation: The timing curve for animating filter changes.
	///   - filter: A configuration for the privacy filter.
	///
	public init ( override: Bool? = nil, animation timingCurve: Animation? = nil, filter configuration: SDBackdropFilter = .init ( ) ) {
		
		self.override = override
		self.timingCurve = timingCurve
		self.configuration = configuration
		
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
	///   - override: Sets the state of privacy layer regardless of the device's scene phase.
	///   - animation: The timing curve for animating filter changes.
	///   - filter: A configuration for the privacy filter.
	///
	func sensitive ( override: Bool? = nil, animation timingCurve: Animation? = nil, filter configuration: SDBackdropFilter = .init ( ) ) -> some View { self.modifier ( SDPrivacyFilter ( override: override, animation: timingCurve, filter: configuration ) ) }
	
}

//
//
