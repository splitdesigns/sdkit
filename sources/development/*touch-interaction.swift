//
////
////  SDKit: Touch Interaction
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
///// A container for implementing simple drag interactions.
/////
//@available ( iOS 16.0, * )
//public struct SDTouchInteraction < Content: View > : View {
//	
//	/// Access to the device's scene phase.
//	///
//	@Environment ( \ .scenePhase ) private var scenePhase
//	
//	/// The interactive content.
//	///
//	private let content: ( _ response: SDTouchInteractionResponse ) -> Content
//	
//	/// The bounds of the interactive content.
//	///
//	@State private var bounds: CGRect = .init ( )
//	
//	/// The interaction response to pass to the content.
//	///
//	@State private var response: SDTouchInteractionResponse = .init ( )
//	
//	/// Calculates the bounds and gesture data for the interaction and passes it to the content.
//	///
//	public var body: some View {
//		
//		self.content ( self.response )
//			.gesture (
//				
//				DragGesture ( minimumDistance: .zero )
//					.onChanged { gestureData in
//						
//						if self.scenePhase == .active {
//							
//							self.response.data = gestureData
//							self.response.isPressed = true
//							
//						}
//						
//					}
//					.onEnded { gestureData in
//						
//						self.response.data = gestureData
//						self.response.isPressed = false
//						
//					}
//				
//			)
//			.onUpdate ( of: self.response.data?.location.x ?? .infinity >= .zero && self.response.data?.location.x ?? .infinity <= self.bounds.width && self.response.data?.location.y ?? .infinity >= .zero && self.response.data?.location.y ?? .infinity <= self.bounds.height && self.scenePhase == .active ) { self.response.isContained = $0 }
//			.onUpdate ( of: self.scenePhase ) { _ in self.response.isPressed = false }
//			.exportBounds ( to: self.$bounds )
//		
//	}
//	
//	/// Creates a ``SDTouchInteraction`` from an animation and some content.
//	///
//	/// - Parameters:
//	///   - content: The tappable content.
//	///
//	public init ( @ViewBuilder _ content: @escaping ( _ response: SDTouchInteractionResponse ) -> Content ) { self.content = content }
//	
//}
//
///// A gesture response for ``SDTouchInteraction``.
/////
//@available ( iOS 16.0, * )
//public struct SDTouchInteractionResponse: Equatable {
//	
//	/// Whether or not the screen is being pressed.
//	///
//	public var isPressed: Bool = false
//	
//	/// Whether or not the drag is within the bounds of the tappable content.
//	///
//	public var isContained: Bool = false
//	
//	/// The resulting drag gesture data from screen contact.
//	///
//	public var data: DragGesture.Value?
//	
//	/// Creates an ``SDTouchInteractionResponse``.
//	///
//	public init ( ) { }
//	
//}
//
////
////
//
