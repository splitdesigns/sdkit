
//
//  SDKit: Interface
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A base container that applies styling, injects defaults, and orients content on the z-axis.
///
/// ``SDInterface`` is intended for use at the top level of your project, and should contain all of your other views. It applies most of the styling defaults set in ``SDDefaults``, decluttering your main view, and passes it as a parameter to the container for external use.
///
/// The most common way to create a ``SDInterface`` is with a closure:
///
///     SDInterface { defaults in }
///
@available ( iOS 16.0, * )
public struct SDInterface < Content: View > : View {
    
    /// Access to the ``SDDefaults`` struct.
    ///
    @Environment ( \.defaults ) private var defaults
    
    /// A container for ``SDInterface`` content.
    ///
    private let content: ( _ defaults: SDDefaults ) -> Content
    
    /// The main view of the ``SDInterface`` struct.
    ///
    public var body: some View {
        
        return ZStack { content ( defaults ) }
            .frame ( maxWidth: .infinity, maxHeight: .infinity )
            .font ( defaults.fonts.sansSerif.body.medium )
            .foregroundColor ( defaults.colors.primary.auto )
            .tint ( defaults.colors.accent.auto )
            .background ( defaults.colors.background.auto )
            .persistentSystemOverlays ( .hidden )
            .onAppear { print ( "Launched: \( defaults.metadata.identifier ) by \( defaults.metadata.developer )" ) }
        
    }
    
    /// A public initializer for the ``SDInterface`` struct.
    ///
    public init ( @ViewBuilder content: @escaping ( _ defaults: SDDefaults ) -> Content ) { self.content = content }

}

//
//
