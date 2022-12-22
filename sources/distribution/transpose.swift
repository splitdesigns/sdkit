
//
//  SDKit: Transpose
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Manages complex animation state. Use in tandem with an interpolated animation literal to produce various metrics.
///
/// To start an animation, simply set the target property. If a custom start value is required, set the target to the start value before the end value.
///
///		@State private var animation: SDTranspose = .init ( )
///
///		...
///
///		Text ( "Hello, world!" )
///			.onAppear {
///
///				//	Set the start value, then the end value
///
///				self.animation.target = 4.0
///				withAnimation ( .linear ( duration: 2.0 ) ) { self.animation.target = 8.0 }
///
///			}
///			.interpolateAnimation ( for: self.animation.target ) { print ( $0 ) }
///
@available ( iOS 16.0, * )
public struct SDTranspose {
	
	/// The status of an animation.
	///
	public enum AnimationStatus: String, CaseIterable { case initial, partial, complete }
	
	/// The animated value. Set with a SwiftUI animation.
	///
	public var target: CGFloat = .zero { didSet { self.cache = oldValue } willSet { self.static = newValue } }
	
	/// The previous animation target.
	///
	public private ( set ) var cache: CGFloat = .init ( )
	
	/// A static representation of the animation target.
	///
	public private ( set ) var `static`: CGFloat = .init ( )
	
	/// A literal interpolation of the animation target. Set this property in the setter of an `animatableData` instance.
	///
	public var literal: CGFloat = .init ( )
	
	/// The status of the animation.
	///
	public var status: Self.AnimationStatus { return self.literal == self.static ? .complete : self.literal == self.cache ? .initial : .partial }
	
	/// The separation between the animation's start value and end value.
	///
	public var difference: CGFloat { return self.static - self.cache }
	
	/// The amount of progress from the animation's start value.
	///
	public var progress: CGFloat { return self.difference - self.remaining }
	
	/// The amount remaining until the animation target is reached.
	///
	public var remaining: CGFloat { return self.static - self.literal }
	
	/// An linear interpolation of the current animation.
	///
	public var normalized: CGFloat { return self.progress / self.difference }
	
	/// Creates an animation segment from a literal, a start value, and an end value.
	///
	/// - Parameters:
	///   - value: The literal value to interpolate.
	///   - from: The start of the animation.
	///   - to: The end of the animation.
	///
	/// - Returns: An ``SDTranspose`` instance representing the animation segment.
	///
	public func fractionate ( _ value: CGFloat, from start: CGFloat, to end: CGFloat ) -> SDTranspose {
		
		//	Initialize an animation manager
		
		var animation: Self = .init ( )
		
		//	Implicitly set the start and end values
		
		animation.target = start
		animation.target = end
				
		//	Sort the start end end values, using the result as range bounds to clamp the animation literal
		
		let rangeBounds: [ CGFloat ] = [ start, end ] .sorted ( )
		animation.literal = value.clamped ( in: rangeBounds.first! ... rangeBounds.last! )
		
		//	Return the animation manager
		
		return animation
		
	}
	
	/// Creates an ``SDTranspose`` instance.
	///
	public init ( ) { }
	
}

//
//
