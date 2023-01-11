
//
//  SDKit: Interface
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A base container that applies styling, injects defaults, orients content on the z-axis, and passes in ``SDFlow`` components for routing.
///
/// ``SDInterface`` is intended for use at the top level of your project, and should contain all of your other views. It applies most of the styling defaults set in ``SDDefaults``, decluttering your main view, and passes it as a parameter to the container for external use.
///
/// The most common way to create a ``SDInterface`` is with a closure:
///
///     SDInterface { defaults, identifiers, parameters in }
///
/// Routes for view coordination can be created with if / else or a switch block.
///
///     if identifiers.matches ( nil, at: 0 ) {
///
///         Text ( "Root View" )
///
///     } else if identifiers.matches ( "messages", at: 0 ) {
///
///         if identifiers.matches ( nil, at: 1 ) {
///
///             Text ( "Messages View" )
///
///         } if else ( { $0.representsInt }, at: 1 ) {
///
///             Text ( "Thread: \( identifiers [ 1 ] )" )
///
///         } else {
///
///             Text ( "404" )
///
///         }
///
///     } else {
///
///         Text ( "404" )
///
///     }
///
///	Make sure to use `nil` for the root paths, and always add an else block or default case to catch unexpected path components.
///
@available ( iOS 16.0, * )
public struct SDInterface < Content: View > : View {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
    
	/// The flow to parse.
	///
	private let flow: SDFlow?
	
	/// The path components from the flow.
	///
	private var identifiers: [ String ] { return self.flow?.identifiers ?? self.defaults.coordination.flow.identifiers }
	
	/// The query strings from the flow.
	///
	private var parameters: [ String: String ] { return self.flow?.parameters ?? self.defaults.coordination.flow.parameters }
	
	/// The font to set.
	///
	private let font: ( ( _ style: SDFontStyle ) -> Font )?
	
	/// The font style to set.
	///
	private let fontStyle: SDFontStyle?
	
	/// The foreground color.
	///
    private let foregroundColor: Color?
	
	/// The tint for application accents.
	///
    private let tint: Color?
	
	/// The background color.
	///
    private let background: Color?
	
	/// The persistent system overlay visibility.
	///
    private let persistentSystemOverlays: Visibility
	
	/// The multiline text alignment.
	///
    private let multilineTextAlignment: TextAlignment
    
    /// The view content.
    ///
    private let content: ( SDDefaults, [ String ], [ String: String ] ) -> Content
    
    /// Applies some styling to some content, passing in ``SDDefaults`` and the ``SDFlow`` components.
    ///
    public var body: some View {
        
		return ZStack { self.content ( self.defaults, self.identifiers, self.parameters ) }
            .frame ( maxWidth: .infinity, maxHeight: .infinity )
			.adaptiveFont ( self.font ?? self.defaults.fonts.primary, style: self.fontStyle ?? .body )
			.foregroundColor ( self.foregroundColor ?? self.defaults.colors.primary.auto )
			.tint ( self.tint ?? self.defaults.colors.accent.auto )
			.background ( self.background ?? self.defaults.colors.background.auto )
			.persistentSystemOverlays ( self.persistentSystemOverlays )
			.multilineTextAlignment ( self.multilineTextAlignment )
			.onAppear { print ( "Launched: \( self.defaults.metadata.identifier ) by \( self.defaults.metadata.developer )" ) }
        
    }
    
    /// Creates an ``SDInterface`` instance from a flow to parse, some style preferences, and some content.
	///
	/// - Parameters:
	///   - parse: The flow to parse.
	///   - font: The font to set.
	///   - fontStyle: The font style to set.
	///   - foregroundColor: The foreground color.
	///   - tint: The tint for application accents.
	///   - background: The background color.
	///   - persistentSystemOverlays: The persistent system overlay visibility.
	///   - multilineTextAlignment: The multiline text alignment.
	///   - content: The view content.
	///
	public init (
		
		parse flow: SDFlow? = nil,
		font: ( ( _ style: SDFontStyle ) -> Font )? = nil,
		fontStyle: SDFontStyle? = nil,
		foregroundColor: Color? = nil,
		tint: Color? = nil,
		background: Color? = nil,
		persistentSystemOverlays: Visibility = .hidden,
		multilineTextAlignment: TextAlignment = .leading,
		@ViewBuilder content: @escaping ( SDDefaults, [ String ], [ String : String ] ) -> Content
	
	) {
			
		self.flow = flow
		self.font = font
		self.fontStyle = fontStyle
		self.foregroundColor = foregroundColor
		self.tint = tint
		self.background = background
		self.persistentSystemOverlays = persistentSystemOverlays
		self.multilineTextAlignment = multilineTextAlignment
		self.content = content
		
	}

}

//
//
