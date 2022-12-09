
//
//  SDKit: Alternate App Icon
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Sets an alternate app icon. Will not trigger an alert.
///
/// You must have the app icon assets stored in your bundle, and identified in your info.plist file. They cannot be in an asset catalog. For more info, refer to [ this article. ]( https://www.hackingwithswift.com/example-code/uikit/how-to-change-your-app-icon-dynamically-with-setalternateiconname )
///
/// You can set an alternate app icon dynamically to match the color scheme when the app enters the foreground. Add the view modifier to one of your views:
///
///     .dynamicAppIcon ( named: "your-icon-identifier" )
///
/// If you want to maintain the dynamic functionality, but disable it programatically to ignore color scheme changes, use the override parameter:
///
///     .dynamicAppIcon ( named: "your-icon-identifier", override: true )
///
/// Alternatively, you can leverage ``SDAlternateAppIcon``'s static ``SDAlternateAppIcon/set(icon:)`` method to set an icon manually:
///
///     SDAlternateAppIcon.set ( icon: "your-icon-identifier" )
///
///	Setting the alternate icon name to `nil` will revert the icon to it's primary image.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDAlternateAppIcon: ViewModifier {
    
    /// Access to the device's color scheme.
    ///
    @Environment ( \ .colorScheme ) private var colorScheme
    
    /// Access to the device's application state.
    ///
    @Environment ( \ .scenePhase ) private var scenePhase
    
    /// The identifier for the alternate icon specified in the info.plist file.
    ///
    private let identifier: String?
    
    /// An override to ignore color scheme changes.
    ///
    private let override: Bool
    
    /// Triggers an icon update when the app enters the foreground.
    ///
	public func body ( content: Content ) -> some View { content.onUpdate ( of: self.scenePhase ) { if self.scenePhase == .active {
                            
        //  Determine whether an alternate icon should be present
        
		let identifier: String? = self.override ? self.identifier : self.colorScheme != .dark ? nil : self.identifier
        
        //  Set the alternate icon identifier and log the result
        
		Self.set ( icon: identifier )
		print ( "UIApplication.shared.alternateIconName set to `\( String ( identifier ?? "nil" ) )`" )
        
        return
                    
    } } }
    
    /// Calls an Objective-C method that sets an alternate icon appearance.
	///
	/// - Parameter icon: The icon identifier to set.
    ///
    public static func set ( icon: String? ) -> Void { if UIApplication.shared.supportsAlternateIcons {
                    
            //  Obfuscation
            
            let setAlternateApplicationIconKey = { [ "completionHandler:", "_setAlternateIconName:" ] .reversed ( ) .joined ( ) } ( )
            
            //  Get the method

            let setAlternateApplicationIcon = unsafeBitCast ( UIApplication.shared.method ( for: NSSelectorFromString ( setAlternateApplicationIconKey ) ), to: ( @convention ( c ) ( NSObject, Selector, NSString?, @escaping ( NSError ) -> ( ) ) -> ( ) ) .self )
            
            // Call the method
            
            setAlternateApplicationIcon ( UIApplication.shared, NSSelectorFromString ( setAlternateApplicationIconKey ), icon as NSString?, { _ in } )
            
            return
            
    } }
    
    /// Creates a ``SDAlternateAppIcon`` from an identifier and an override.
    ///
	/// - Parameters:
	///   - named: The identifier to set.
	///   - override: Locks the dynamism of the icon to the specified identifier.
	///
    fileprivate init ( named identifier: String, override: Bool ) {
        
        self.identifier = identifier
        self.override = override

    }

}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
    
    /// Sets an alternate app icon to match the color scheme when the app enters the foreground. Will not trigger an alert.
    ///
	/// - Parameters:
	///   - named: The identifier to set.
	///   - override: Locks the dynamism of the icon to the specified identifier.
	///
	/// - Warning: Uses a private API.
	///
	func dynamicAppIcon ( named identifier: String, override: Bool = false ) -> some View { self.modifier ( SDAlternateAppIcon ( named: identifier, override: override ) ) }

}

//
//
