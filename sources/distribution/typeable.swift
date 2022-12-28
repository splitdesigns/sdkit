
//
//  SDKit: Typeable
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A control that displays an editable text interface.
///
@available ( iOS 16.0, * )
public struct SDTypeable < Value: Hashable > : View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The text to display when the source is empty.
	///
	private let placeholder: String
	
	/// The source binding for the text field.
	///
	private var source: Binding < String >?
	
	/// The focus state for the text field.
	///
	private let focusState: FocusState < Value? > .Binding?
	
	/// The value to compare the focus state against.
	///
	private let focusIdentifier: Value?

	/// The local source binding for the text field.
	///
	@State private var localSource: String = .init ( )
	
	///	The local focus state for the text field.
	///
	@FocusState private var localFocusState: Value?
	
	///	Contains a text field with some custom styling and interactions.
	///
	public var body: some View {
		
		SDTouchInteraction { response in
			
			TextField ( self.placeholder, text: self.source ?? self.$localSource )
				.padding ( 16.0 )
				.contentShape ( Rectangle ( ) )
				.focused ( self.focusState ?? self.$localFocusState, equals: self.focusIdentifier )
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
					
					if !$0 && response.isContained {
						
						//	Check if a focus state binding was provided
						
						if self.focusState != nil {
							
							//	Set the focus state to the identifier
							
							self.focusState!.wrappedValue = self.focusIdentifier
							
							//	Set the local focus state to the identifier
							
						} else { self.localFocusState = self.focusIdentifier }

					}
					
				}
			
		}
		
	}
	
	/// Creates an ``SDTypeable`` instance from a placeholder, source binding, focus state, and a focus identifier.
	///
	/// - Parameters:
	///   - placeholder: The text to display when the source is empty.
	///   - source: The source binding for the text field.
	///   - focusState: The focus state for the text field.
	///   -	focusIdentifier: The value to compare the focus state against.
	///
	public init ( placeholder: String = "SDTypeable", source: Binding < String >? = nil, focusState: FocusState < Value? > .Binding? = nil, focusIdentifier: Value? = true ) {
		
		self.placeholder = placeholder
		self.source = source
		self.focusState = focusState
		self.focusIdentifier = focusIdentifier
		
	}
	
}

//
//
