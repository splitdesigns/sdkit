
//
//  SDKit: Interpolate Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Uses `AnimatableData` to interpolate a literal from a SwiftUI animation.
///
@available ( iOS 16.0, * )
private struct SDInterpolateAnimation < Value: VectorArithmetic > : ViewModifier, Animatable {
	
	/// The value to interpolate.
	///
	private var value: Value
	
	/// The closure to run when the animation updates.
	///
	private let onUpdate: ( ( Value ) -> Void )?
	
	/// The closure to run when the animation is complete.
	///
	private let onCompletion: ( ( ) -> Void )?
	
	/// Calculates a literal from a SwiftUI animation.
	///
	public var animatableData: Value
	
	/// Runs a task on every update.
	///
	/// - Parameter content: The content to modify.
	///
	public func body ( content: Content ) -> some View { content.onUpdate ( of: self.animatableData ) {
		
		if let onUpdate = self.onUpdate { onUpdate ( self.animatableData ) }
		if self.animatableData == self.value, let onCompletion = self.onCompletion { onCompletion ( ) }
		
	} }
	
	/// Creates a ``SDInterpolateAnimation`` from a value, update closure, and completion closure.
	///
	/// - Parameters:
	///   - for: The value to interpolate.
	///   - onUpdate: The closure to run when the animation updates.
	///   - onCompletion: The closure to run when the animation is complete.
	///
	public init ( for value: Value, onUpdate: ( ( Value ) -> Void )? = nil, onCompletion: ( ( ) -> Void )? = nil ) {
		
		self.value = value
		self.onUpdate = onUpdate
		self.onCompletion = onCompletion
		
		self.animatableData = value
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Uses `AnimatableData` to interpolate a literal from a SwiftUI animation.
	///
	/// - Parameters:
	///   - for: The value to interpolate.
	///   - onUpdate: The closure to run when the animation updates.
	///   - onCompletion: The closure to run when the animation is complete.
	///
	func interpolateAnimation < Value: VectorArithmetic > ( for value: Value, onUpdate: ( ( Value ) -> Void )? = nil, onCompletion: ( ( ) -> Void )? = nil ) -> some View { self.modifier ( SDInterpolateAnimation ( for: value, onUpdate: onUpdate, onCompletion: onCompletion ) ) }
	
}

//
//
