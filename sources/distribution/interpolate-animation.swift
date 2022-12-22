
//
//  SDKit: Interpolate Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Uses `AnimatableData` to interpolate a literal value from a SwiftUI animation.
///
/// To capture the literal of an animation, attach the ``SDInterpolatedAnimation`` modifier to any view that has access to the animation source. The `onUpdate` closure will be passed the interpolated value.
///
///		/// The value to animate.
///		///
/// 	@State private var animated: CGFloat = .zero
///
/// 	/// The literal interpolation of the animated value.
/// 	///
/// 	@State private var interpolated: CGFloat = .init ( )
///
/// 	...
///
/// 	//	Displays the interpolated value
///
/// 	Text ( "Animation literal: \( self.interpolated )" )
/// 		.onAppear { withAnimation { self.animated = 10.0 } }
/// 		.interpolateAnimation { self.interpolated = $0 }
///
@available ( iOS 16.0, * )
private struct SDInterpolateAnimation < Value: VectorArithmetic > : ViewModifier, Animatable {
	
	/// The value to interpolate.
	///
	private let target: Value
	
	/// The closure to run when the animation literal changes.
	///
	private let onUpdate: ( ( _ literal: Value ) -> Void )?
	
	/// The closure to run when the animation is complete.
	///
	private let onCompletion: ( ( ) -> Void )?
	
	/// Interpolates a literal from a SwiftUI animation.
	///
	fileprivate var animatableData: Value
	
	/// Interpolates the animated value, running a closure on each update and once finished.
	///
	fileprivate func body ( content: Content ) -> some View {
		
		content
			.onUpdate ( of: self.animatableData ) {
				
				//	Check if an update closure was provided, then run the closure passing in the literal
				
				if let onUpdate = self.onUpdate { onUpdate ( $0 ) }
				
				//	Check if the literal equals the target, and check if a completion closure was provided, then run the closure
				
				if $0 == self.target, let onCompletion = self.onCompletion { onCompletion ( ) }
				return
				
			}
		
	}
	
	/// Creates an ``SDInterpolateAnimation`` instance from a value, an update closure, and a completion closure.
	///
	/// - Parameters:
	///   - for: The value to interpolate.
	///   - onUpdate: The closure to run when the animation literal changes.
	///   - onCompletion: The closure to run when the animation is complete.
	///
	fileprivate init ( for target: Value, onUpdate: ( ( _ literal: Value ) -> Void )? = nil, onCompletion: ( ( ) -> Void )? = nil ) {
		
		self.target = target
		self.onUpdate = onUpdate
		self.onCompletion = onCompletion
		
		self.animatableData = self.target
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Uses `AnimatableData` to interpolate a literal value from a SwiftUI animation. See ``SDInterpolateAnimation`` for more info.
	///
	/// - Parameters:
	///   - for: The value to interpolate.
	///   - onUpdate: The closure to run when the animation literal changes.
	///   - onCompletion: The closure to run when the animation is complete.
	///
	func interpolateAnimation < Value: VectorArithmetic > ( for target: Value, onUpdate: ( ( _ literal: Value ) -> Void )? = nil, onCompletion: ( ( ) -> Void )? = nil ) -> some View { return self.modifier ( SDInterpolateAnimation ( for: target, onUpdate: onUpdate, onCompletion: onCompletion ) ) }
	
}

//
//
