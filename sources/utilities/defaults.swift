
//
//  SDKit: Defaults
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension EnvironmentValues {
    
    /// The default configuration set by ``SDDefaults``.
    ///
    var defaults: SDDefaults {
        
        get { return self [ SDDefaultsKey.self ] }
        set { return self [ SDDefaultsKey.self ] = newValue }
        
    }
    
}

@available ( iOS 16.0, * )
public extension View {
    
    /// Override the defaults set by ``SDDefaults`` with your own configuration.
    ///
    func setDefaults ( _ defaults: SDDefaults ) -> some View { return environment ( \.defaults, defaults ) }
    
}

//
//

//  MARK: - Structures

/// An `EnvironmentKey` struct containing a default value for the ``SDDefaults`` environment key.
///
@available ( iOS 16.0, * )
private struct SDDefaultsKey: EnvironmentKey {
    
    /// A default value for the ``SDDefaults`` environment key.
    ///
    internal static let defaultValue: SDDefaults = .init ( )
    
}

/// A collection of overridable preferences powering `SDKit`.
///
/// To use the defaults outside of `SDKit` components, grab the ``SDDefaults`` object from the environment with the `defaults` key.
///
///     @Environment ( \.defaults ) private var defaults
///
/// To override the default configuration, create a new instance, and make your changes. Doing so inside a closure often works well.
///
///     let configuration: SDDefaults = {
///
///         let defaults: SDDefaults = .init ( )
///         defaults.colors.primary = .blue
///         return defaults
///
///     } ( )
///
/// Inject the new object into the environment with the `setDefaults` modifier. This should be set on ``SDInterface`` or another top-level view.
///
///     .setDefaults ( configuration )
///
/// You can append computed properties directly to the struct with extensions:
///
///     extension SDDefaults.Colors {
///
///         /// A monochromatic color with a luminance value of half of one.
///         ///
///         public var neutral: SDSchemeColor { .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) ) }
///
///     }
///
///
/// Alternatively, you can create new structs inside of ``SDDefaults``, and initialize them with computed properties:
///
///     extension SDDefaults.Colors {
///
///         /// A collection of custom colors, instantiated from the Custom struct.
///         ///
///         public var custom: Custom { .init ( ) }
///
///         struct Custom {
///
///             /// A monochromatic color with a luminance value of half of one.
///             ///
///             public var neutral: SDSchemeColor = .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) )
///
///         }
///
///     }
///     
@available ( iOS 16.0, * )
public struct SDDefaults {
        
    /// A collection of app metadata items, instantiated from the `Metadata` struct.
    ///
    public var metadata: Metadata = .init ( )
    
    /// A collection of app metadata items.
    ///
    public struct Metadata {
        
        /// An identifier that defines the name of the app.
        ///
        public var identifier: String = Bundle.main.displayName ?? Bundle.main.name ?? "Unknown"
        
        /// The name of the app developer.
        ///
        public var developer: String = "Unknown"

    }
    
    /// A collection of colors, instantiated from the `Colors` struct.
    ///
    public var colors: Colors = .init ( )
    
    /// A collection of colors.
    ///
    public class Colors {
            
        /// The color to use for primary content.
        ///
        public var primary: SDSchemeColor = .init ( light: .primary, dark: .primary )
        
        /// The color to use for secondary content.
        ///
        public var secondary: SDSchemeColor = .init ( light: .secondary, dark: .secondary )
        
        /// The color to use for tinting and accents.
        ///
        public var accent: SDSchemeColor = .init ( light: .accentColor, dark: .accentColor )
        
        /// The color to use for the background.
        ///
        public var background: SDSchemeColor = .init ( light: .white, dark: .black )
            
    }
    
    /// A collection of fonts, instantiated from the `Fonts` struct.
    ///
    public var fonts: Fonts = .init ( )
    
    /// A collection of fonts.
    ///
    public struct Fonts {
        
        /// A collection of sans-serif fonts, instantiated from the `SansSerif` struct.
        ///
        public var sansSerif: SansSerif = .init ( )
        
        /// A collection of sans-serif fonts.
        ///
        public struct SansSerif {
            
            /// A collection of title-scale sans-serif fonts, instantiated from the `Title` struct.
            ///
            public var title: Title = .init ( )
            
            /// A collection of title-scale sans-serif fonts.
            ///
            public struct Title {
                
                /// A light, title-scale sans-serif font.
                ///
                public var light: Font = .system ( size: 48.0, weight: .light, design: .default )
                
                /// A medium, title-scale sans-serif font.
                ///
                public var medium: Font = .system ( size: 48.0, weight: .medium, design: .default )
                
                /// A bold, title-scale sans-serif font.
                ///
                public var bold: Font = .system ( size: 48.0, weight: .bold, design: .default )
                
            }
            
            /// A collection of heading-scale sans-serif fonts, instantiated from the `Heading` struct.
            ///
            public var heading: Heading = .init ( )
            
            /// A collection of heading-scale sans-serif fonts.
            ///
            public struct Heading {
                
                /// A light, heading-scale sans-serif font.
                ///
                public var light: Font = .system ( size: 24.0, weight: .light, design: .default )
                
                /// A medium, heading-scale sans-serif font.
                ///
                public var medium: Font = .system ( size: 24.0, weight: .medium, design: .default )
                
                /// A bold, heading-scale sans-serif font.
                ///
                public var bold: Font = .system ( size: 24.0, weight: .bold, design: .default )
                
            }
            
            /// A collection of body-scale sans-serif fonts, instantiated from the `Body` struct.
            ///
            public var body: Body = .init ( )
            
            /// A collection of body-scale sans-serif fonts.
            ///
            public struct Body {
                
                /// A light, body-scale sans-serif font.
                ///
                public var light: Font = .system ( size: 16.0, weight: .light, design: .default )
                
                /// A medium, body-scale sans-serif font.
                ///
                public var medium: Font = .system ( size: 16.0, weight: .medium, design: .default )
                
                /// A bold, body-scale sans-serif font.
                ///
                public var bold: Font = .system ( size: 16.0, weight: .bold, design: .default )
                
            }
            
        }
        
        /// A collection of monospaced fonts, instantiated from the `Monospaced` struct.
        ///
        public var monospaced: Monospaced = .init ( )
        
        /// A collection of monospaced fonts.
        ///
        public struct Monospaced {
            
            /// A collection of title-scale monospaced fonts, instantiated from the `Title` struct.
            ///
            public var title: Title = .init ( )
            
            /// A collection of title-scale monospaced fonts.
            ///
            public struct Title {
                
                /// A light, title-scale monospaced font.
                ///
                public var light: Font = .system ( size: 48.0, weight: .light, design: .monospaced )
                
                /// A medium, title-scale monospaced font.
                ///
                public var medium: Font = .system ( size: 48.0, weight: .medium, design: .monospaced )
                
                /// A bold, title-scale monospaced font.
                ///
                public var bold: Font = .system ( size: 48.0, weight: .bold, design: .monospaced )
                
            }
            
            /// A collection of heading-scale monospaced fonts, instantiated from the `Heading` struct.
            ///
            public var heading: Heading = .init ( )
            
            /// A collection of heading-scale monospaced fonts.
            ///
            public struct Heading {
                
                /// A light, heading-scale monospaced font.
                ///
                public var light: Font = .system ( size: 24.0, weight: .light, design: .monospaced )
                
                /// A medium, heading-scale monospaced font.
                ///
                public var medium: Font = .system ( size: 24.0, weight: .medium, design: .monospaced )
                
                /// A bold, heading-scale monospaced font.
                ///
                public var bold: Font = .system ( size: 24.0, weight: .bold, design: .monospaced )
                
            }
            
            /// A collection of body-scale monospaced fonts, instantiated from the `Body` struct.
            ///
            public var body: Body = .init ( )
            
            /// A collection of body-scale monospaced fonts.
            ///
            public struct Body {
                
                /// A light, body-scale monospaced font.
                ///
                public var light: Font = .system ( size: 16.0, weight: .light, design: .monospaced )
                
                /// A medium, body-scale monospaced font.
                ///
                public var medium: Font = .system ( size: 16.0, weight: .medium, design: .monospaced )
                
                /// A bold, body-scale monospaced font.
                ///
                public var bold: Font = .system ( size: 16.0, weight: .bold, design: .monospaced )
                
            }

        }

    }
    
    /// A public initializer for the ``SDDefaults`` struct.
    ///
    public init ( ) { }
    
}

//
//
