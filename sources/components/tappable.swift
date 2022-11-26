
//
//  SDKit: Tappable
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A wrapper for working with tap gestures.
///
@available ( iOS 16.0, * )
public struct SDTappable < Content: View > : View {
	
	/// Access to the `SDDefaults` configuration.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The animation curve to use for response values.
	///
	private let bezier: Animation?
	
	/// The tappable content.
	///
	private let content: ( ( active: Bool, animation: SDTranspose ), ( contained: Bool, data: DragGesture.Value? ) ) -> Content
	
	/// The gesture state required for acquiring gesture data on update. Unused.
	///
	@GestureState private var gesture: Bool = .init ( )
	
	/// Whether or not the screen is being pressed.
	///
	@State private var active: Bool = .init ( )
	
	/// An animation for screen presses and releases.
	///
	@State private var animation: SDTranspose = .init ( )
	
	/// The resulting drag gesture data from screen contact.
	///
	@State private var data: DragGesture.Value? = nil
	
	/// The bounds of the tappable content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// Whether or not the drag is within the bounds of the tappable content.
	///
	private var contained: Bool { return self.data?.location.x ?? 0.0 >= 0.0 && self.data?.location.x ?? 0.0 <= self.bounds.width && self.data?.location.y ?? 0.0 >= 0.0 && self.data?.location.y ?? 0.0 <= self.bounds.height }
	
	/// Gets the bounds and gesture data of the content and interpolates animation values.
	///
	public var body: some View {
		
		self.content ( ( self.active, self.animation ), ( self.contained, self.data ) )
			.gesture (
				
				DragGesture ( minimumDistance: 0.0 )
					.updating ( self.$gesture ) { currentState, gestureState, transaction in
						
						DispatchQueue.main.async {
							
							self.data = currentState
							
							withAnimation ( self.bezier ?? self.defaults.animations.primary ) {
								
								self.animation.target = 1.0
								self.active = true
								
							}
							
						}
						
					}
					.onEnded { currentState in
						
						DispatchQueue.main.async {
							
							self.data = currentState
							
							withAnimation ( self.bezier ?? self.defaults.animations.primary ) {
								
								self.animation.target = 0.0
								self.active = false
								
							}
							
						}
						
					}
				
			)
			.exportBounds ( to: self.$bounds )
			.interpolateAnimation ( for: self.animation.target ) { self.animation.literal = $0 }
		
	}
	
	/// Creates a ``SDTappable`` from an animation and some content.
	///
	/// - Parameters:
	///   - animation: The animation curve to use for response values.
	///   - content: The tappable content.
	///
	public init ( animation bezier: Animation? = nil, @ViewBuilder _ content: @escaping ( ( active: Bool, animation: SDTranspose ), ( contained: Bool, data: DragGesture.Value? ) ) -> Content ) {
		
		self.bezier = bezier
		self.content = content
		
	}
	
}

//
//
