
//
//  SDKit: Touch Interaction
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A container for creating advanced drag interactions.
///
/// ``SDTouchInteraction`` provides a response that updates whenever an interaction with the device's screen changes. Unlike `onTapGesture(count:perform:)` and `onLongPressGesture(minimumDuration:maximumDistance:perform:onPressingChanged:)`, the container offers all of the data produced by a drag gesture, wrapped in an API suitable for the simplest tap and press interactions.
///
/// Simply encapsulate the interactive content in an ``SDTouchInteraction`` instance to observe and react to interaction changes.
///
@available ( iOS 16.0, * )
public struct SDTouchInteraction < Content: View > : View {
	
	/// Access to the device's scene phase.
	///
	@Environment ( \ .scenePhase ) private var scenePhase
	
	/// The coordinate space to capture gesture data in.
	///
	private let coordinateSpace: CoordinateSpace
	
	/// The interactive content.
	///
	private let content: ( _ response: SDTouchInteractionResponse ) -> Content
	
	/// The bounds of the interactive content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// The interaction response to pass to the content.
	///
	@State private var response: SDTouchInteractionResponse = .init ( )
	
	/// Captures interaction data and passes it to the content.
	///
	public var body: some View {
		
		self.content ( self.response )
			.gesture (
				
				//	Capture a drag interaction for the most data
				
				DragGesture ( minimumDistance: .zero, coordinateSpace: self.coordinateSpace )
					.onChanged { gestureData in
						
						//	Check if the app is in the foreground
						
						if self.scenePhase == .active {
							
							//	Update the interaction response
							
							self.response.data = gestureData
							self.response.isPressed = true
							
						}
						
					}
					.onEnded { gestureData in
						
						//	Update the interaction response
						
						self.response.data = gestureData
						self.response.isPressed = false
						
					}
				
			)
			.exportBounds ( to: self.$bounds )
			.onUpdate ( of: self.response.data?.location.x ?? .infinity >= .zero && self.response.data?.location.x ?? .infinity <= self.bounds.width && self.response.data?.location.y ?? .infinity >= .zero && self.response.data?.location.y ?? .infinity <= self.bounds.height && self.scenePhase == .active ) {
				
				//	Update the interaction response
				
				self.response.isContained = $0
				
			}
			.onUpdate ( of: self.scenePhase ) { _ in
				
				//	Cancel the interaction on scene phase changes
				
				self.response.isPressed = false
				
			}
		
	}
	
	/// Creates an ``SDTouchInteraction`` instance from a gesture coordinate space and some content.
	///
	/// - Parameters:
	///   - in: The coordinate space to capture gesture data in.
	///   - for: The interactive content.
	///
	public init ( in coordinateSpace: CoordinateSpace = .local, @ViewBuilder for content: @escaping ( _ response: SDTouchInteractionResponse ) -> Content ) {
		
		self.coordinateSpace = coordinateSpace
		self.content = content
		
	}
	
}

/// An interaction response created by an ``SDTouchInteraction`` instance.
///
@available ( iOS 16.0, * )
public struct SDTouchInteractionResponse: Equatable {
	
	/// The screen is being pressed.
	///
	public var isPressed: Bool = .init ( )
	
	/// The touch location is within the bounds of the interactive content.
	///
	public var isContained: Bool = .init ( )
	
	/// The drag gesture data from the touch interaction.
	///
	public var data: DragGesture.Value?
	
	/// Creates an ``SDTouchInteractionResponse`` instance.
	///
	fileprivate init ( ) { }
	
}

//
//
