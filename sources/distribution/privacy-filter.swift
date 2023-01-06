
//
//  SDKit: Privacy Filter
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Filters sensitive content when the app moves to the background.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDPrivacyFilter: ViewModifier {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// Access to the device's scene phase.
	///
	@Environment ( \.scenePhase ) private var scenePhase
	
	/// A configuration for the privacy filter.
	///
	private let configuration: SDBackdropFilter
	
	/// The timing curve to use for animating filter changes.
	///
	private let timingCurve: Animation?
	
	/// Overrides the state of the privacy filter.
	///
	private let enabled: Bool?
	
	/// Whether or not to filter the content.
	///
	private var active: Bool { return self.enabled != nil ? self.enabled! : self.scenePhase != .active }
	
	/// Animates properties of a backdrop filter over some content based on the device's scene phase.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.overlay { SDBackdropFilter (
				
				brightness: self.active ? ( self.configuration.brightness ?? self.defaults.filters.brightness ) : 0.0,
				contrast: self.active ? ( self.configuration.contrast ?? self.defaults.filters.contrast ) : 1.0,
				grayscale: self.active ? ( self.configuration.grayscale ?? self.defaults.filters.grayscale ) : 0.0,
				invert: self.active ? ( self.configuration.invert ?? self.defaults.filters.invert ) : false,
				opacity: self.active ? ( self.configuration.opacity ?? self.defaults.filters.opacity ) : 1.0,
				opaque: self.active ? ( self.configuration.opaque ?? self.defaults.filters.opaque ) : true,
				radius: self.active ? ( self.configuration.radius ?? self.defaults.filters.radius ) : 0.0,
				saturation: self.active ? ( self.configuration.saturation ?? self.defaults.filters.saturation ) : 1.0,
				tint: self.active ? ( self.configuration.tint ?? self.defaults.filters.tint.auto ) : .clear,
				clip: self.active ? ( self.configuration.clip ?? self.defaults.filters.clip ) : true
				
			) .allowsHitTesting ( self.active ) }
			.animation ( self.timingCurve ?? self.defaults.animations.primary ( 1.0 ), value: self.active )
		
	}
	
	/// Creates an ``SDPrivacyFilter`` instance from a filter configuration and an animation.
	///
	/// - Parameters:
	///   - configuration: A configuration for the privacy filter.
	///   - animation: The timing curve to use for animating filter changes.
	///   - enabled: Overrides the state of the privacy filter.
	///
	public init ( _ configuration: SDBackdropFilter = .init ( ), animation timingCurve: Animation? = nil, enabled: Bool? = nil ) {
		
		self.configuration = configuration
		self.timingCurve = timingCurve
		self.enabled = enabled
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Filters sensitive content when the app moves to the background.
	///
	/// - Warning: Uses a private API.
	///
	/// - Parameters:
	///   - configuration: A configuration for the privacy filter.
	///   - animation: The timing curve to use for animating filter changes.
	///   - enabled: Overrides the state of the privacy filter.
	///
	func privacyFilter ( _ configuration: SDBackdropFilter = .init ( ), animation timingCurve: Animation? = nil, enabled: Bool? = nil ) -> some View { self.modifier ( SDPrivacyFilter ( configuration, animation: timingCurve, enabled: enabled ) ) }
	
}

//
//
