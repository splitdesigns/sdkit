
//
//  SDKit: Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Interpolates an animation, passing the transposed reference as a parameter.
///
@available ( iOS 16.0, * )
public struct SDAnimation < Content: View > : View {
	
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
	/// - Parameter content: The content to modify.
	///
	public var body: some View {
		
		content ( animation )
			.onAppear {
				
				if let start = start { animation.cache = start }
				if let end = end, let bezier = bezier { withAnimation ( bezier ) { animation.target = end } }
				
			}
			.interpolateAnimation ( for: animation.target ) { animation.literal = $0 }
		
	}
	
	/// Creates a ``SDAnimation`` from some animation values and content.
	///
	/// - Parameter from: The start value for the animation.
	/// - Parameter to: The end value for the animation.
	/// - Parameter with: The bezier curve for the animation.
	/// - Parameter content: The content to display.
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
