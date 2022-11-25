
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
	
	/// The animation for the shimmer effect.
	///
	private let animation: Animation?
	
	/// Whether or not to apply the shine as a mask.
	///
	private var mask: Bool { return ( self.color ?? self.defaults.colors.background.auto ) == .clear }
	
	/// Overlays or masks an animated gradient on some content.
	///
	public func body ( content: Content ) -> some View {
		
		SDAnimation ( to: 2.0, with: self.animation ?? defaults.animations.expoInOut ( duration: 4.0 ) .repeatForever ( autoreverses: false ) ) { animation in
			
			if !mask { content.overlay { self.shine ( content, phase: animation.literal ) } } else { content.mask { self.shine ( content, phase: animation.literal ) } }
			
		}
		
	}
	
	/// An animated gradient that represents a reflection.
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
	///   - animation: The animation for the shimmer effect.
	///
	public init (
		
		color: Color? = nil,
		start: UnitPoint = .topLeading,
		end: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		animation: Animation? = nil
		
	) {
		
		self.color = color
		self.start = start
		self.end = end
		self.freeform = freeform
		self.animation = animation
		
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
	///   - animation: The animation for the shimmer effect.
	///
	func shimmer (
		
		color: Color? = nil,
		start: UnitPoint = .topLeading,
		end: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		animation: Animation? = nil
		
	) -> some View { self.modifier ( SDShimmer (
		
		color: color,
		start: start,
		end: end,
		freeform: freeform,
		animation: animation
		
	) ) }
	
}

//
//
