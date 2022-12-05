
//
//  SDKit: Shimmer
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Adds a shine effect to a view.
///
@available ( iOS 16.0, * )
public struct SDShimmer: ViewModifier {
	
	/// Access to the ``SDDefaults`` struct.
	///
	@Environment ( \.defaults ) private var defaults
	
	/// The color of the shimmer effect.
	///
	private let color: Color?
	
	/// The start position of the shimmer.
	///
	private let start: UnitPoint
	
	/// The end position of the shimmer.
	///
	private let end: UnitPoint
	
	/// Disables the default behavior of framing the shimmer effect to an aspect ratio of one. Useful for relative unit point positioning.
	///
	private let freeform: Bool
	
	/// The position of the shimmer effect.
	///
	private var phase: CGFloat?
	
	/// The animation curve for the effect.
	///
	private var timingCurve: Animation?
	
	/// Whether or not to apply the shine as a mask.
	///
	private var mask: Bool { return ( self.color ?? self.defaults.colors.background.auto ) == .clear }
	
	/// Overlays or masks an animatable gradient on some content.
	///
	public func body ( content: Content ) -> some View {
		
		SDInterpolatedAnimation ( from: 0.0, to: 1.0, with: self.timingCurve ?? self.defaults.animations.expoInOut ( duration: 4.0 ) .repeatForever ( autoreverses: false ) ) { animation in
			
			if !mask { content.overlay { self.shine ( content, phase: ( self.phase?.truncatingRemainder ( dividingBy: 1.0 ) ?? animation.literal ) * 2.0 ) } } else { content.mask { self.shine ( content, phase: ( self.phase ?? animation.literal ) * 2.0 ) } }
			
		}
		
	}
	
	/// An animatable gradient that simulates a reflection.
	///
	/// - Parameters:
	///   - content: The content shape to mask to.
	///   - phase: The position of the shimmer effect.
	///
	private func shine ( _ content: Content, phase: CGFloat ) -> some View {
		
		LinearGradient ( gradient: .init ( stops: [
			
			.init ( color: !mask ? .clear : .black, location: phase - 1.0 ),
			.init ( color: !mask ? ( self.color ?? self.defaults.colors.background.auto ) : .clear, location: phase - 0.5 ),
			.init ( color: !mask ? .clear : .black, location: phase )
			
		] ), startPoint: self.start, endPoint: self.end )
		
		.if ( !self.freeform ) { $0.aspectRatio ( 1.0, contentMode: .fill ) }
		.mask ( content )
		.allowsHitTesting ( false )
		
	}
	
	/// Creates a ``SDShimmer`` from a configuration.
	///
	/// - Parameters:
	///   - color: The color of the shimmer effect.
	///   - start: The start position of the shimmer.
	///   - end: The end position of the shimmer.
	///   - freeform: Disables the default behavior of framing the shimmer effect to an aspect ratio of one. Useful for relative unit point positioning.
	///   - phase: The position of the shimmer effect.
	///   - animation: The animation curve for the effect.
	///
	public init (
		
		color: Color? = nil,
		start: UnitPoint = .topLeading,
		end: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		phase: CGFloat? = nil,
		animation timingCurve: Animation? = nil
		
	) {
		
		self.color = color
		self.start = start
		self.end = end
		self.freeform = freeform
		self.phase = phase
		self.timingCurve = timingCurve
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Adds a shine effect to a view.
	///
	/// - Parameters:
	///   - color: The color of the shimmer effect.
	///   - start: The start position of the shimmer.
	///   - end: The end position of the shimmer.
	///   - freeform: Disables the default behavior of framing the shimmer effect to an aspect ratio of one. Useful for relative unit point positioning.
	///   - phase: The position of the shimmer effect.
	///   - animation: The animation curve for the effect.
	///
	func shimmer (
		
		color: Color? = nil,
		start: UnitPoint = .topLeading,
		end: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		phase: CGFloat? = nil,
		animation timingCurve: Animation? = nil
		
	) -> some View { self.modifier ( SDShimmer (
		
		color: color,
		start: start,
		end: end,
		freeform: freeform,
		phase: phase,
		animation: timingCurve
		
	) ) }
	
}

//
//
