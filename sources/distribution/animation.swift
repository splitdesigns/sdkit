
//
//  SDKit: Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A container that passes in a SwiftUI animation.
///
@available ( iOS 16.0, * )
public struct SDAnimation < Content: View, Value: Equatable > : View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The end value for the animation.
	///
	private let target: Value
	
	/// The timing curve for the animation.
	///
	private let timingCurve: Animation?
	
	/// The content to animate.
	///
	private let content: ( Value ) -> Content
	
	/// The animation.
	///
	@State private var animation: Value
	
	/// Starts the animation, and passes it to the content.
	///
	public var body: some View {
		
		self.content ( self.animation ) .onAppear { withAnimation ( self.timingCurve ?? self.defaults.animations.primary ( 1.0 ) .repeatForever ( autoreverses: false ) ) { self.animation = self.target } }
		
	}
	
	/// Creates an ``SDAnimation`` instance from some animation values and some content.
	///
	/// - Parameters:
	///   - from: The start value for the animation.
	///   - to: The end value for the animation.
	///   - with: The timing curve for the animation.
	///   - for: The content to animate.
	///
	public init ( from start: Value = 0.0, to end: Value = 1.0, with timingCurve: Animation? = nil, @ViewBuilder for content: @escaping ( Value ) -> Content ) {
		
		self.target = end
		self.timingCurve = timingCurve
		self.content = content
		
		self._animation = .init ( wrappedValue: start )
		
	}
	
}

//
//
