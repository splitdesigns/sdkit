
//
//  SDKit: Alternate App Icon
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Assigns an alternate app icon. Will not trigger an alert.
///
/// You must have the app icon assets stored in your bundle, and identified in your info.plist file. They cannot be in an asset catalog. For more info, refer to [ this article. ]( https://www.hackingwithswift.com/example-code/uikit/how-to-change-your-app-icon-dynamically-with-setalternateiconname )
///
/// You can configure an alternate app icon by setting the view modifier on one of your views:
///
///     .alternateAppIcon ( named: "your-icon-identifier" )
///
/// If you want the icon to change dynamically based on the color scheme of the device, set `dynamic` to true:
///
///     .alternateAppIcon ( named: "your-icon-identifier", dynamic: true )
///
/// To revert to the primary icon, set the identifier to `nil`:
///
///     .alternateAppIcon ( named: nil )
///
/// Alternatively, you can leverage ``SDAlternateAppIcon``'s static ``SDAlternateAppIcon/set(icon:)`` method to set the icon manually:
///
///     SDAlternateAppIcon.set ( icon: "your-icon-identifier" )
///
/// - Note: The icon can only be set while the app is in the foreground. Use the `scenePhase` environment value to verify the application's scene phase, setting the icon while in the `active` state.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDAlternateAppIcon: ViewModifier {
	
	/// Access to the device's application state.
	///
	@Environment ( \ .scenePhase ) private var scenePhase
    
    /// Access to the device's color scheme.
    ///
    @Environment ( \ .colorScheme ) private var colorScheme
    
    /// The identifier for the alternate icon specified in the `info.plist` file.
    ///
    private let identifier: String?
    
    /// Set the app icon dynamically based on the device's color scheme.
    ///
    private let dynamic: Bool
    
    /// Sets the icon's identifier when an input source updates.
    ///
	public func body ( content: Content ) -> some View {
		
		content
			.onUpdate ( of: self.identifier, or: self.dynamic, or: self.colorScheme, or: self.scenePhase ) { identifier, dynamic, colorScheme, scenePhase in
				
				//  Check the scene phase, since the icon can only be set while the app is in the foreground
				
				if scenePhase == .active {
					
					//  If set to dynamic, determine the identifier to set based on the color scheme, and set the alternate icon identifier
					
					Self.set ( icon: dynamic ? colorScheme != .dark ? nil : identifier : identifier )
					
				}
				
				return
									
			}
		
	}
    
    /// Calls an Objective-C method that sets an alternate icon appearance.
	///
	/// - Parameter icon: The icon identifier to set.
    ///
    public static func set ( icon: String? ) -> Void {
		
		//	Check if the system supports alternate icons
		
		guard UIApplication.shared.supportsAlternateIcons else { return }
		
		//  Obfuscate the selector
		
		let setAlternateIconNameKey: String = { [ "completionHandler:", "_setAlternateIconName:" ] .reversed ( ) .joined ( ) } ( )
		
		//  Retrieve and call the method
		
		unsafeBitCast ( UIApplication.shared.method ( for: NSSelectorFromString ( setAlternateIconNameKey ) ), to: ( @convention ( c ) ( NSObject, Selector, NSString?, @escaping ( NSError ) -> Void ) -> Void ) .self ) ( UIApplication.shared, NSSelectorFromString ( setAlternateIconNameKey ), icon as NSString?, { _ in } )
		
		return
				
	}
    
    /// Creates an ``SDAlternateAppIcon``.
    ///
	/// - Parameters:
	///   - named: The identifier for the alternate icon specified in the `info.plist` file.
	///   - dynamic: Set the app icon dynamically based on the device's color scheme.
	///
    fileprivate init ( named identifier: String?, dynamic: Bool = false ) {
        
        self.identifier = identifier
        self.dynamic = dynamic

    }

}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
    
    /// Assigns an alternate app icon. Will not trigger an alert. See ``SDAlternateAppIcon`` for more info.
	///
	/// - Parameters:
	///   - named: The identifier for the alternate icon specified in the `info.plist` file.
	///   - dynamic: Set the app icon dynamically based on the device's color scheme.
	///
	/// - Warning: Uses a private API.
	///
	func alternateAppIcon ( named identifier: String?, dynamic: Bool = false ) -> some View { self.modifier ( SDAlternateAppIcon ( named: identifier, dynamic: dynamic ) ) }

}

//
//
