
//
//  SDKit: Transpose
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A helper class for managing animations.
///
@available ( iOS 16.0, * )
public struct SDTranspose: Hashable, Equatable {
	
	/// Defines the animation states.
	///
	public enum AnimationStatus: String, CaseIterable { case initial, partial, complete }
	
	/// The value to animate to. Set this property with an animation.
	///
	public var target: CGFloat = .zero { didSet { self.cache = oldValue } willSet {
		
		self.static = newValue
//		self.literal = newValue
		
	} }
	
	/// A static representation of the target value.
	///
	public var `static`: CGFloat = .init ( )
	
	/// A literal interpolation of the current value. Set this property in the setter of an `animatableData` instance.
	///
	public var literal: CGFloat = .init ( )
	
	/// The previous animation target. Set this as the starting value of the animation. Consecutive target changes will set this automatically.
	///
	public var cache: CGFloat = .init ( )
	
	/// Indicates the state of the animation.
	///
	public var status: Self.AnimationStatus { return literal == target ? .complete : literal == cache ? .initial : .partial }
	
	/// The difference between the current target and cache.
	///
	public var difference: CGFloat { return abs ( self.cache - self.target ) }
	
	/// The amount of progress from the cache value.
	///
	public var progress: CGFloat { return self.difference - self.remaining }
	
	/// The amount remaining before reaching the target.
	///
	public var remaining: CGFloat { return abs ( self.literal - self.target ) }
	
	/// A reversed interpolation of the current animation state, between zero and one.
	///
	public var reversed: CGFloat { return self.remaining / self.difference }
	
	/// An interpolation of the current animation state, between zero and one.
	///
	public var normalized: CGFloat { return 1.0 - self.reversed }
	
	/// Interpolates between a start and an end value. If the value is out of bounds, the function's `progress` and `remaining` return values will be `nil`.
	///
	/// - Parameters:
	///   - value: The value to interpolate.
	///   - from: The start bound of the interpolation range.
	///   - to: The end bound of the interpolation range.
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
