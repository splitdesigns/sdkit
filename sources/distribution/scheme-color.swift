
//
//  SDKit: Scheme Color
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A color model that can switch between colors based on the device's color scheme.
///
/// To create a ``SDSchemeColor``, initialize it with a color for each color scheme.
///
///     let backgroundColor: SDSchemeColor = .init ( light: .white, dark: .black )
///
/// Once created, use it by specifying an interpretation:
///
///     //  Dynamically changes based on the device's color scheme
///
///     .background ( backgroundColor.auto )
///
///     //  Always returns white
///
///     .background ( backgroundColor.light )
///
@available ( iOS 16.0, * )
public struct SDSchemeColor {
    
    /// A light interpretation of the scheme color.
    ///
    public var light: Color
    
    /// A dark interpretation of the scheme color.
    ///
    public var dark: Color
    
    /// A color that automatically switches between the light and dark interpretation of the scheme color, based the device's color scheme.
    ///
	public var auto: Color { .init ( uiColor: UIColor { $0.userInterfaceStyle == .light ? UIColor ( self.light ) : UIColor ( self.dark ) } ) }
    
    /// Creates a ``SDSchemeColor`` from a color representing each interface style.
	///
	/// - Parameters:
	///   - light: A light interpretation of the scheme color.
	///   - dark: A dark interpretation of the scheme color.
    ///
    public init ( light: Color, dark: Color ) {
        
        self.light = light
        self.dark = dark
        
    }
    
}

//
//
