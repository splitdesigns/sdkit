
//
//  SDKit: Tappable
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A button containing some text.
///
@available ( iOS 16.0, * )
public struct SDTappable < Content: View > : View {
	
	/// Access to the `SDDefaults` configuration.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The content to display.
	///
	private let content: ( ) -> Content
	
	/// The action to run when the button is pressed.
	///
	private let action: ( ) -> Void
	
	/// A press interaction containing some styled text.
	///
	public var body: some View {
		
		SDTouchInteraction { response in
			
			content ( )
				.font ( defaults.fonts.monospaced ( ) )
				.padding ( 12.0 )
				.padding ( .horizontal, 6.0 )
				.background ( SDBackdropFilter ( tint: response.isPressed ? defaults.colors.accent.auto.opacity ( 0.5 ) : nil ) )
				.relativeCornerStyle ( subject: 0.0, relative: 64.0 )
				.shadow ( color: defaults.shadows.color, radius: defaults.shadows.radius )
				.animation ( defaults.animations.expoOut ( duration: 0.5 ), value: response.isPressed )
				.animation ( defaults.animations.expoOut ( duration: 0.5 ), value: response.isContained )
				.onUpdate ( of: response.isPressed ) { if !response.isPressed && response.isContained { action ( ) } }
			
		}
		
	}
	
	/// Creates a ``SDTappable`` from some text and an action.
	///
	/// - Parameters:
	///   - content: The content to display.
	///   - action: The action to run when the button is tapped.
	///
	public init ( @ViewBuilder content: @escaping ( ) -> Content, perform action: @escaping ( ) -> Void ) {
		
		self.content = content
		self.action = action
		
	}
	
}

//
//
