
//
//  SDKit: Focus
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A transition that overlays, desaturates, scales, and blurs the content to create an illusion of losing focus.
///
@available ( iOS 16.0, * )
public struct SDFocus: ViewModifier, Animatable {
	
	/// Access to the ``SDDefaults`` struct.
	///
	@Environment ( \.defaults ) private var defaults
	
	/// The blur radius.
	///
	private let radius: CGFloat?
	
	/// The amount to desaturate,
	///
	private let saturation: CGFloat?
	
	/// The tint color.
	///
	private let tint: Color?
	
	/// The size to scale down to.
	///
	private let scale: CGFloat?
	
	/// Provides literal animation data.
	///
	public var animatableData: CGFloat { get { animation.target } set { animation.literal = newValue } }
	
	/// Manages animation state.
	///
	private var animation: SDTranspose = .init ( )
	
	/// Interpolates a set of values to use for the transition.
	///
	private var delayedAnimation: ( active: Bool, difference: CGFloat, progress: CGFloat?, remaining: CGFloat? ) { animation.interpolate ( animation.normalized.replace ( with: animation.reversed, if: animation.cache > animation.target ), from: 0.5, to: 1.0 ) }
	
	/// Applies modifiers to the content.
	///
	/// - Parameter content: The content to modify.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.opacity ( delayedAnimation.active ? 1.0 : 0.0 )
			.overlay {
				
				SDBackdropFilter ( saturation: 1.0 - ( delayedAnimation.remaining ?? 0.0 ) * ( 1.0 - ( saturation ?? defaults.filters.saturation ) ), radius: ( delayedAnimation.remaining ?? 0.0 ) * ( radius ?? defaults.filters.radius ), opaque: true, tint: ( tint ?? defaults.filters.tint ) .opacity ( delayedAnimation.remaining ?? 0.0 ) )
					.mask ( content )
					.allowsHitTesting ( false )
				
			}
			.scaleEffect ( 1.0 - ( delayedAnimation.remaining ?? 1.0 ) * ( 1.0 - ( scale ?? 0.875 ) ) )
			.transaction { $0.animation = nil }
		
	}
	
	/// Creates a ``SDFocus`` from a start value, end value, blur radius, saturation amount, tint color, and a size to scale down to.
	///
	/// - Parameter start: The start value for the animation.
	/// - Parameter end: The end value for the animation.
	/// - Parameter radius: The blur radius.
	/// - Parameter saturation: The saturation amount.
	/// - Parameter tint: The tint color.
	/// - Parameter scale: The size to scale down to.
	///
	public init ( start: CGFloat, end: CGFloat, radius: CGFloat? = nil, saturation: CGFloat? = nil, tint: Color? = nil, scale: CGFloat? = nil ) {
		
		self.animation.target = end
		self.animation.literal = end
		self.animation.cache = start
		
		self.radius = radius
		self.saturation = saturation
		self.tint = tint
		self.scale = scale
		
	}
	
}

//
//

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension AnyTransition {
	
	/// Creates the illusion of a loss of focus.
	///
	/// - Parameter radius: The blur radius.
	/// - Parameter saturation: The saturation amount.
	/// - Parameter tint: The tint color.
	/// - Parameter scale: The size to scale down to.
	///
	static func focus ( radius: CGFloat? = nil, saturation: CGFloat? = nil, tint: Color? = nil, scale: CGFloat? = nil ) -> AnyTransition { .modifier ( active: SDFocus ( start: 1.0, end: 0.0, radius: radius, saturation: saturation, tint: tint, scale: scale ), identity: SDFocus ( start: 0.0, end: 1.0, radius: radius, saturation: saturation, tint: tint, scale: scale ) ) }
	
}

//
//
