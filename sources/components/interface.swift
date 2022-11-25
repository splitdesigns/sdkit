
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
///	Make sure to use `nil` for the root paths, and always add an else block to catch unexpected path components.
///
@available ( iOS 16.0, * )
public struct SDInterface < Content: View > : View {
	
	/// Manages the application's coordination.
	/// 
	@EnvironmentObject private var systemCoordinator: SDSystem.Coordinator
	
	/// Access to the `SDDefaults` configuration.
	///
	@Environment ( \ .defaults ) private var defaults
    
	/// The flow to parse.
	///
    private let flow: SDFlow?
	
	/// The path components from the flow.
	///
	private var identifiers: [ String ] { return self.flow?.identifiers ?? self.systemCoordinator.flow.identifiers }
	
	/// The query strings from the flow.
	///
	private var parameters: [ String: String ] { return self.flow?.parameters ?? self.systemCoordinator.flow.parameters }
    
	/// The font to apply.
	///
    private let font: Font?
	
	/// The foreground color to use.
	///
    private let foregroundColor: Color?
	
	/// The tint to apply.
	///
    private let tint: Color?
	
	/// The background color to use.
	///
    private let background: Color?
	
	/// The persistent system overlay visibility setting to apply.
	///
    private let persistentSystemOverlays: Visibility
	
	/// A default multiline text alignment.
	///
    private let multilineTextAlignment: TextAlignment
    
    /// A container for the view content.
    ///
    private let content: ( SDDefaults, [ String ], [ String: String ] ) -> Content
    
    /// Applies the defaults to a ZStack containing the content.
    ///
    public var body: some View {
        
		return ZStack { self.content ( self.defaults, self.identifiers, self.parameters ) }
            .frame ( maxWidth: .infinity, maxHeight: .infinity )
			.font ( self.font ?? defaults.fonts.primary )
			.foregroundColor ( self.foregroundColor ?? self.defaults.colors.primary.auto )
			.tint ( self.tint ?? self.defaults.colors.accent.auto )
			.background ( self.background ?? self.defaults.colors.background.auto )
			.persistentSystemOverlays ( self.persistentSystemOverlays )
			.multilineTextAlignment ( self.multilineTextAlignment )
			.onAppear { print ( "Launched: \( self.defaults.metadata.identifier ) by \( self.defaults.metadata.developer )" ) }
        
    }
    
    /// Creates a ``SDInterface`` from a variety of defaults and application state.
	/// 
	/// - Parameters:
	///   - parse: The flow to parse.
	///   - font: The font to apply.
	///   - foregroundColor: The foreground color to use.
	///   - tint: The tint to apply.
	///   - background: The background color to use.
	///   - persistentSystemOverlays: The persistent system overlay visibility setting to apply.
	///   - multilineTextAlignment: A default multiline text alignment.
	///   - content: The content to show in this view.
	///
	public init (
		
		parse flow: SDFlow? = nil,
		font: Font? = nil,
		foregroundColor: Color? = nil,
		tint: Color? = nil,
		background: Color? = nil,
		persistentSystemOverlays: Visibility = .hidden,
		multilineTextAlignment: TextAlignment = .leading,
		@ViewBuilder content: @escaping ( SDDefaults, [ String ], [ String : String ] ) -> Content
	
	) {
			
		self.flow = flow
		self.font = font
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
