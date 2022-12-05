
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
public struct SDAnimation < Content: View, Value: Equatable > : View, Identifiable, Equatable, Hashable {
	
	/// Access to the defaults object.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The end value of the animation.
	///
	private let target: Value
	
	/// The timing curve for the animation.
	///
	private let timingCurve: Animation?
	
	/// The view content.
	///
	private let content: ( Value ) -> Content
	
	/// An identifier for the view.
	///
	public let id: UUID
	
	/// Manages the animation state.
	///
	@State private var animation: Value
	
	/// Starts the animation.
	///
	public var body: some View {
		
		self.content ( self.animation ) .onAppear { withAnimation ( self.timingCurve ?? self.defaults.animations.primary.repeatForever ( autoreverses: false ) ) { self.animation = self.target } }
		
	}
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	public static func == ( lhs: SDAnimation < Content, Value >, rhs: SDAnimation < Content, Value > ) -> Bool { return rhs.id == lhs.id }
	
	/// A hasher for hashable conformance.
	///
	/// - Parameter into: The hasher used to hash the value.
	///
	public func hash ( into hasher: inout Hasher ) { hasher.combine ( self.id ) }
	
	/// Creates a ``SDAnimation`` from some animation values and content.
	///
	/// - Parameters:
	///   - from: The start value for the animation.
	///   - to: The end value for the animation.
	///   - with: The timing curve for the animation.
	///   - content: The content to display.
	///
	public init ( from start: Value, to end: Value, with timingCurve: Animation? = nil, @ViewBuilder content: @escaping ( Value ) -> Content ) {
		
		self.target = end
		self.timingCurve = timingCurve
		self.content = content
		
		self.id = .init ( )
		self._animation = .init ( wrappedValue: start )
		
	}
	
}

//
//
