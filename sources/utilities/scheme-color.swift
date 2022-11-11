
//
//  SDKit: Scheme Color
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A color initializer that switches between colors based on the device's color scheme.
///
/// To create a ``SDSchemeColor``, initialize it with a color for each color scheme.
///
///     let backgroundColor: SDSchemeColor = .init ( light: .white, dark: .black )
///
/// Once created, use it by specifying the interpretation:
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
    
    /// A color that automatically adapts to the device's color scheme.
    ///
	public var auto: Color { .init ( uiColor: UIColor { $0.userInterfaceStyle == .light ? UIColor ( self.light ) : UIColor ( self.dark ) } ) }
    
    /// Creates a ``SDSchemeColor`` from a light and dark color.
    ///
    public init ( light: Color, dark: Color ) {
        
        self.light = light
        self.dark = dark
        
    }
    
}

//
//
