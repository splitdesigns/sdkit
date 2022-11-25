
//
//  SDKit: Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Interpolates an animation, passing the animation object as a parameter.
///
@available ( iOS 16.0, * )
public struct SDAnimation < Content: View > : View {
	
	/// Access to the ``SDDefaults`` struct.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The start value of the animation.
	///
	private let start: CGFloat?
	
	/// The end value of the animation.
	///
	private let end: CGFloat?
	
	/// The bezier curve of the animation.
	///
	private let bezier: Animation?
	
	/// The view content.
	///
	private let content: ( SDTranspose ) -> Content
	
	/// Manages the animation state.
	///
	@State private var animation: SDTranspose = .init ( )
	
	/// Sets the animation values, and starts the animation with interpolation.
	///
	public var body: some View {
		
		self.content ( animation )
			.onAppear {
				
				if let start = self.start { self.animation.cache = start }
				withAnimation ( bezier ?? defaults.animations.primary.repeatForever ( autoreverses: false ) ) { self.animation.target = end ?? 1.0 }
				
			}
			.interpolateAnimation ( for: self.animation.target ) { self.animation.literal = $0 }
		
	}
	
	/// Creates a ``SDAnimation`` from some animation values and content.
	///
	/// - Parameters:
	///   - from: The start value for the animation.
	///   - to: The end value for the animation.
	///   - with: The bezier curve for the animation.
	///   - content: The content to display.
	///
	public init ( from start: CGFloat? = nil, to end: CGFloat? = nil, with bezier: Animation? = nil, @ViewBuilder content: @escaping ( SDTranspose ) -> Content ) {
		
		self.start = start
		self.end = end
		self.bezier = bezier
		self.content = content
		
	}
	
}

//
//
