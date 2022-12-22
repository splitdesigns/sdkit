
//
//  SDKit: Interpolated Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Interpolates a literal from a SwiftUI animation, passing the animation manager as a parameter.
///
@available ( iOS 16.0, * )
public struct SDInterpolatedAnimation < Content: View > : View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults

	/// The start value for the animation.
	///
	private let start: CGFloat?

	/// The end value for the animation.
	///
	private let end: CGFloat?

	/// The timing curve for the animation.
	///
	private let timingCurve: Animation?

	/// The view content.
	///
	private let content: ( _ animation: SDTranspose ) -> Content

	/// Manages the animation state.
	///
	@State private var animation: SDTranspose = .init ( )

	/// Starts an animation managed by a ``SDTranspose`` instance.
	///
	public var body: some View {

		self.content ( self.animation )
			.onAppear {
				
				//	Check if a start value exists, then using it to implicitly set the cached value

				if let start = self.start { self.animation.target = start }
				
				//	Start the animation
				
				withAnimation ( self.timingCurve ?? self.defaults.animations.primary ( 1.0 ) .repeatForever ( autoreverses: false ) ) { self.animation.target = self.end ?? 1.0 }

			}
			.interpolateAnimation ( for: self.animation.target ) { self.animation.literal = $0 }

	}
	
	/// Creates a ``SDInterpolatedAnimation`` instance from some animation values and some content.
	///
	/// - Parameters:
	///   - from: The start value for the animation.
	///   - to: The end value for the animation.
	///   - with: The timing curve for the animation.
	///   - for: The view content.
	///
	public init ( from start: CGFloat? = nil, to end: CGFloat? = nil, with timingCurve: Animation? = nil, @ViewBuilder for content: @escaping ( _ animation: SDTranspose ) -> Content ) {
		
		self.start = start
		self.end = end
		self.timingCurve = timingCurve
		self.content = content
		
	}

}

//
//
