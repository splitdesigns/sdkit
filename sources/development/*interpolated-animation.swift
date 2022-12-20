//
////
////  SDKit: Interpolated Animation
////  Developed by SPLIT Designs
////
//
////  MARK: - Imports
//
//import SwiftUI
//
////
////
//
////  MARK: - Structures
//
///// Interpolates an animation, passing the animation object as a parameter.
/////
///// - Warning: Reading animation literals is expensive.
/////
//@available ( iOS 16.0, * )
//public struct SDInterpolatedAnimation < Content: View > : View {
//	
//	/// Access to the ``SDDefaults`` struct.
//	///
//	@Environment ( \ .defaults ) private var defaults
//	
//	/// The start value of the animation.
//	///
//	private let start: CGFloat?
//	
//	/// The end value of the animation.
//	///
//	private let end: CGFloat?
//	
//	/// The timing curve for the animation.
//	///
//	private let timingCurve: Animation?
//	
//	/// The view content.
//	///
//	private let content: ( SDTranspose ) -> Content
//	
//	/// Manages the animation state.
//	///
//	@State private var animation: SDTranspose = .init ( )
//	
//	/// Sets the animation values, and starts the animation with interpolation.
//	///
//	public var body: some View {
//		
//		self.content ( self.animation )
//			.onAppear {
//				
//				if let start = self.start { self.animation.cache = start }
//				withAnimation ( self.timingCurve ?? self.defaults.animations.primary.repeatForever ( autoreverses: false ) ) { self.animation.target = self.end ?? 1.0 }
//				
//			}
//			.interpolateAnimation ( for: self.animation.target ) { self.animation.literal = $0 }
//		
//	}
//	
//	/// Creates a ``SDAnimation`` from some animation values and content.
//	///
//	/// - Parameters:
//	///   - from: The start value for the animation.
//	///   - to: The end value for the animation.
//	///   - with: The timing curve for the animation.
//	///   - content: The content to display.
//	///
//	public init ( from start: CGFloat? = nil, to end: CGFloat? = nil, with timingCurve: Animation? = nil, @ViewBuilder content: @escaping ( SDTranspose ) -> Content ) {
//		
//		self.start = start
//		self.end = end
//		self.timingCurve = timingCurve
//		self.content = content
//		
//	}
//	
//}
//
////
////
