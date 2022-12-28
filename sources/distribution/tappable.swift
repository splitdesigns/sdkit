
//
//  SDKit: Tappable
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// An interactive container for content that performs an action when tapped.
///
@available ( iOS 16.0, * )
public struct SDTappable < Content: View > : View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The interactive content.
	///
	private let content: ( ) -> Content
	
	/// The action to perform.
	///
	private let action: ( ) -> Void
	
	/// A touch interaction that triggers an animation and background color change.
	///
	public var body: some View {
		
		SDTouchInteraction { response in
			
			content ( )
				.contentShape ( Rectangle ( ) )
				.overlay {
					
					//	Overlay a color to signify an interaction
					
					defaults.colors.primary.auto
						.opacity ( response.isPressed ? 0.25 : 0.0 )
						.allowsHitTesting ( false )
					
				}
				.animation ( self.defaults.animations.primary ( 0.5 ), value: response.isPressed )
				.animation ( self.defaults.animations.primary ( 0.5 ), value: response.isContained )
				.onUpdate ( of: response.isPressed ) {
					
					//	Perform the action on touch release
					
					if !$0 && response.isContained { action ( ) }
					
				}
			
		}
		
	}
	
	/// Creates an ``SDTappable`` instance from some content and an action to perform.
	///
	/// - Parameters:
	///   - content: The interactive content.
	///   - perform: The action to perform.
	///
	public init ( @ViewBuilder content: @escaping ( ) -> Content = { return Text ( "SDTappable" ) .padding ( 16.0 ) }, perform action: @escaping ( ) -> Void = { return print ( "Tapped" ) } ) {
		
		self.content = content
		self.action = action
		
	}
	
}

//
//
