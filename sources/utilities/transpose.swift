
//
//  SDKit: Transpose
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Structures

/// A helper class for managing animations.
///
@available ( iOS 16.0, * )
public struct SDTranspose {
	
	/// The value to animate to. Set this property with an animation.
	///
	public var target: CGFloat = 0.0 { didSet { cache = oldValue } }
	
	/// A literal interpolation of the current value. Set this property in the setter of an `animatableData` instance.
	///
	public var literal: CGFloat = 0.0
	
	/// The previous animation target. Set this as the starting value of the animation. Consecutive target changes will set this automatically.
	///
	public var cache: CGFloat = 0.0
	
	/// The difference between the current target and cache.
	///
	public var difference: CGFloat { abs ( cache - target ) }
	
	/// The amount of progress from the cache value.
	///
	public var progress: CGFloat { difference - remaining }
	
	/// The amount remaining before reaching the target.
	///
	public var remaining: CGFloat { abs ( literal - target ) }
	
	/// A reversed interpolation of the current animation state, between zero and one.
	///
	public var reversed: CGFloat { remaining / difference }
	
	/// An interpolation of the current animation state, between zero and one.
	///
	public var normalized: CGFloat { 1.0 - reversed }
	
	/// Interpolates between a start and an end value. If the value is out of bounds, the function's `progress` and `remaining` return values will be `nil`.
	///
	/// - Parameter value: The value to interpolate.
	/// - Parameter from: The start bound of the interpolation range.
	/// - Parameter to: The end bound of the interpolation range.
	///
	/// - Returns: `( active: Bool )` a tuple indicating whether the current value is within the interpolation range, `( difference: CGFloat )` the difference between the interpolation bounds, `( progress: CGFloat? )` the progress from the start bound to the end bound, `( remaining: CGFloat? )` the amount remaining before reaching the end bound.
	///
	public func interpolate ( _ value: CGFloat, from start: CGFloat, to end: CGFloat ) -> ( active: Bool, difference: CGFloat, progress: CGFloat?, remaining: CGFloat? ) {
		
		let active: Bool = value >= start && value <= end
		let difference: CGFloat = abs ( end - start )
		let remaining: CGFloat? = active ? abs ( end - value ) / difference : nil
		let progress: CGFloat? = remaining != nil ? 1.0 - ( remaining ?? 0.0 ) : nil
		
		return ( active, difference, progress, remaining )
		
	}
	
	/// Creates a ``SDTranspose`` instance.
	///
	public init ( ) { }
	
}

//
//
