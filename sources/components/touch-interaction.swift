
//
//  SDKit: Press Interaction
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A container for working with simple gestures.
///
@available ( iOS 16.0, * )
public struct SDTouchInteraction < Content: View > : View {
	
	/// Access to the device's scene phase.
	///
	@Environment ( \ .scenePhase ) private var scenePhase
	
	/// The tappable content.
	///
	private let content: ( ( isPressed: Bool, isContained: Bool, data: DragGesture.Value? ) ) -> Content
	
	/// Whether or not the screen is being pressed.
	///
	@State private var isPressed: Bool = .init ( )
	
	/// The resulting drag gesture data from screen contact.
	///
	@State private var gestureData: DragGesture.Value? = nil
	
	/// The bounds of the tappable content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// Whether or not the drag is within the bounds of the tappable content.
	///
	private var isContained: Bool { return self.gestureData?.location.x ?? .infinity >= 0.0 && self.gestureData?.location.x ?? .infinity <= self.bounds.width && self.gestureData?.location.y ?? .infinity >= 0.0 && self.gestureData?.location.y ?? .infinity <= self.bounds.height && scenePhase == .active }
	
	/// Gets the bounds and gesture data of the content and interpolates animation values.
	///
	public var body: some View {
		
		self.content ( ( self.isPressed, self.isContained, self.gestureData ) )
			.gesture (
				
				DragGesture ( minimumDistance: 0.0 )
					.onChanged { gestureData in
						
						if self.scenePhase == .active {
							
							self.gestureData = gestureData
							self.isPressed = true
							
						}
						
					}
					.onEnded { gestureData in
						
						self.gestureData = gestureData
						self.isPressed = false
						
					}
				
			)
			.task ( id: self.scenePhase ) { if self.isPressed { self.isPressed.toggle ( ) } }
			.exportBounds ( to: self.$bounds )
		
	}
	
	/// Creates a ``SDTouchInteraction`` from an animation and some content.
	///
	/// - Parameters:
	///   - content: The tappable content.
	///
	public init ( @ViewBuilder _ content: @escaping ( ( isPressed: Bool, isContained: Bool, data: DragGesture.Value? ) ) -> Content ) { self.content = content }
	
}

//
//


