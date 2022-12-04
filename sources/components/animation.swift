
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
	@Environment ( \ .defaults ) private var defaults
	
	/// The end value of the animation.
	///
	private let target: Value
	
	/// The bezier curve of the animation.
	///
	private let bezier: Animation?
	
	/// The view content.
	///
	private let content: ( Value ) -> Content
	
	/// Manages the animation state.
	///
	@State private var animation: Value
	
	/// Starts the animation.
	///
	public var body: some View {
		
		self.content ( animation ) .onAppear { withAnimation ( bezier ?? defaults.animations.primary.repeatForever ( autoreverses: false ) ) { self.animation = target } }
		
	}
	
	/// Creates a ``SDAnimation`` from some animation values and content.
	///
	/// - Parameters:
	///   - from: The start value for the animation.
	///   - to: The end value for the animation.
	///   - with: The bezier curve for the animation.
	///   - content: The content to display.
	///
	public init ( from start: Value, to end: Value, with bezier: Animation? = nil, @ViewBuilder content: @escaping ( Value ) -> Content ) {
		
		self.target = end
		self.bezier = bezier
		self.content = content
		self._animation = .init ( wrappedValue: start )
		
	}
	
}

//
//
