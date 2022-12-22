
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
	
	/// The color of the shine.
	///
	private let color: Color?
	
	/// The start position of the shine.
	///
	private let startPoint: UnitPoint
	
	/// The end position of the shine.
	///
	private let endPoint: UnitPoint
	
	/// Disables the default behavior of framing the shine to an aspect ratio of one. Useful when relative point positioning is needed.
	///
	private let freeform: Bool
	
	/// The timing curve for the shine animation.
	///
	private var timingCurve: Animation?
	
	/// The position of the shine.
	///
	private var phase: CGFloat?
	
	/// Apply the shine as a mask.
	///
	private var mask: Bool { return ( self.color ?? SDDefaults.Colors.background.auto ) == .clear }
	
	/// Overlays or masks a simulated shine on some content.
	///
	public func body ( content: Content ) -> some View {
		
		SDInterpolatedAnimation ( with: self.timingCurve ?? SDLibrary.Animations.expoInOut ( duration: 4.0 ) .repeatForever ( autoreverses: false ) ) { animation in
			
			if !mask { content.overlay { self.shine ( phase: ( self.phase?.truncatingRemainder ( dividingBy: 1.0 ) ?? animation.literal ) * 2.0, mask: content ) } } else { content.mask { self.shine ( phase: ( self.phase?.truncatingRemainder ( dividingBy: 1.0 ) ?? animation.literal ) * 2.0, mask: content ) } }
			
		}
		
	}
	
	/// A gradient that simulates a reflection.
	///
	/// - Parameters:
	///   - phase: The position of the shine.
	///   - mask: The shape for masking the shine.
	///
	private func shine ( phase: CGFloat, mask: Content ) -> some View {
		
		LinearGradient ( gradient: .init ( stops: [
			
			.init ( color: !self.mask ? .clear : .black, location: phase - 1.0 ),
			.init ( color: !self.mask ? ( self.color ?? SDDefaults.Colors.background.auto ) : .clear, location: phase - 0.5 ),
			.init ( color: !self.mask ? .clear : .black, location: phase )
			
		] ), startPoint: self.startPoint, endPoint: self.endPoint )
		
		.if ( !self.freeform ) { $0.aspectRatio ( 1.0, contentMode: .fill ) }
		.mask ( mask )
		.allowsHitTesting ( false )
		
	}
	
	/// Creates a ``SDShimmer`` instance.
	///
	/// - Parameters:
	///   - color: The color of the shine.
	///   - startPoint: The start position of the shine.
	///   - endPoint: The end position of the shine.
	///   - freeform: Disables the default behavior of framing the shine to an aspect ratio of one. Useful when relative point positioning is needed.
	///   - animation: The timing curve for the shine animation.
	///   - phase: The position of the shine.
	///
	public init (
		
		color: Color? = nil,
		startPoint: UnitPoint = .topLeading,
		endPoint: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		animation timingCurve: Animation? = nil,
		phase: CGFloat? = nil
		
	) {
		
		self.color = color
		self.startPoint = startPoint
		self.endPoint = endPoint
		self.freeform = freeform
		self.timingCurve = timingCurve
		self.phase = phase
		
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
	///   - color: The color of the shine.
	///   - startPoint: The start position of the shine.
	///   - endPoint: The end position of the shine.
	///   - freeform: Disables the default behavior of framing the shine to an aspect ratio of one. Useful when relative point positioning is needed.
	///   - animation: The timing curve for the shine animation.
	///   - phase: The position of the shine.
	///
	func shimmer (
		
		color: Color? = nil,
		startPoint: UnitPoint = .topLeading,
		endPoint: UnitPoint = .bottomTrailing,
		freeform: Bool = false,
		animation timingCurve: Animation? = nil,
		phase: CGFloat? = nil
		
	) -> some View { return self.modifier ( SDShimmer (
		
		color: color,
		startPoint: startPoint,
		endPoint: endPoint,
		freeform: freeform,
		animation: timingCurve,
		phase: phase
		
	) ) }
	
}

//
//
