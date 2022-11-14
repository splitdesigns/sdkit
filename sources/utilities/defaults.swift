
//
//  SDKit: Defaults
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// An `EnvironmentKey` containing a default value for the `defaults` key.
///
@available ( iOS 16.0, * )
private struct SDDefaultsKey: EnvironmentKey {
    
    /// A default value for the ``SDDefaults`` environment key.
    ///
	fileprivate static let defaultValue: SDDefaults = .init ( )
    
}

/// A collection of overridable preferences powering `SDKit`.
///
/// To use the defaults outside of `SDKit` components, grab the ``SDDefaults`` object from the environment with the `defaults` key.
///
///     @Environment ( \ .defaults ) private var defaults
///
/// To override the default configuration, create a closure with the modified properties. You can create a trailing closure directly on the view modifier if you prefer.
///
///     let configuration: ( inout SDDefaults ) -> Void = {
///
///         defaults.colors.primary = .blue
///
///     }
///
/// Inject the changes into the environment with the `setDefaults` modifier. This should be set on ``SDInterface`` or another top-level view.
///
///     .setDefaults { configuration ( $0 ) }
///
/// You can append computed properties directly to a struct with extensions:
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
///         /// A collection of custom colors.
///         ///
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
	
	/// Responsible for setting up coordination for our app.
	///
	public var coordination: Self.Coordination = .init ( )
        
    /// A collection of app metadata items.
    ///
	public var metadata: Self.Metadata = .init ( )
    
    /// A collection of colors.
    ///
	public var colors: Self.Colors = .init ( )
	
	/// A collection of animation curves.
	///
	public var animations: Self.Animations = .init ( )
    
    /// A collection of fonts.
    ///
	public var fonts: Self.Fonts = .init ( )
	
	/// A collection of values for configuring backdrop filters.
	///
	public var filters: Self.Filters = .init ( )
	
	/// Creates a ``SDDefaults``.
	///
	public init ( ) { }
    
}

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
	/// - Parameter configuration: The configuration to overwrite the defaults with.
	///
	func setDefaults ( _ configuration: SDDefaults ) -> some View {
		
		//	Set static defaults and environment value to updated object
		
		SDSystem.defaults = configuration
		return environment ( \ .defaults, configuration )
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// Responsible for setting up coordination for our app.
	///
	struct Coordination {
		
		/// The flow used to initialize the application's state.
		///
		public var flow: SDFlow = .init ( "https://apple.com" )
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of app metadata items.
	///
	struct Metadata {
		
		/// An identifier that defines the name of the app.
		///
		public var identifier: String = Bundle.main.displayName ?? Bundle.main.name ?? "Unknown"
		
		/// The name of the app developer.
		///
		public var developer: String = "Unknown"
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
    
    /// A collection of colors.
    ///
	struct Colors {
        
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
    
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of animation curves.
	///
	struct Animations {
		
		/// The animation to use for primary transitions.
		///
		public var primary: Animation = .linear
		
		/// The animation to use for secondary transitions.
		///
		public var secondary: Animation = .easeOut
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
    
    /// A collection of fonts.
    ///
	struct Fonts {
		
		/// The font to use for primary text.
		///
		public var primary: Font = SansSerif.Body ( ) .medium
		
		/// The font to use for secondary text.
		///
		public var secondary: Font = Monospaced.Body ( ) .medium
        
        /// A collection of sans-serif fonts, instantiated from `SansSerif`.
        ///
		public var sansSerif: Self.SansSerif = .init ( )
        
        /// A collection of sans-serif fonts.
        ///
        public struct SansSerif {
            
            /// A collection of title-scale sans-serif fonts, instantiated from `Title`.
            ///
			public var title: Self.Title = .init ( )
            
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
            
            /// A collection of heading-scale sans-serif fonts, instantiated from `Heading`.
            ///
			public var heading: Self.Heading = .init ( )
            
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
            
            /// A collection of body-scale sans-serif fonts, instantiated from `Body`.
            ///
			public var body: Self.Body = .init ( )
            
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
        
        /// A collection of monospaced fonts, instantiated from `Monospaced`.
        ///
		public var monospaced: Self.Monospaced = .init ( )
        
        /// A collection of monospaced fonts.
        ///
        public struct Monospaced {
            
            /// A collection of title-scale monospaced fonts, instantiated from `Title`.
            ///
			public var title: Self.Title = .init ( )
            
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
            
            /// A collection of heading-scale monospaced fonts, instantiated from `Heading`.
            ///
			public var heading: Self.Heading = .init ( )
            
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
            
            /// A collection of body-scale monospaced fonts, instantiated from `Body`.
            ///
			public var body: Self.Body = .init ( )
            
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
	    
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of values for configuring backdrop filters.
	///
	class Filters {
		
		/// A value that determines the brightness of the filter.
		///
		public var brightness: CGFloat = 0.0
		
		/// A value that determines the filter's grayscale amount.
		///
		public var grayscale: CGFloat = 0.0
		
		/// A value that determines the saturation of the filter.
		///
		public var saturation: CGFloat = 1.0
		
		/// A value that determines the contrast of the filter.
		///
		public var contrast: CGFloat = 1.0
		
		/// A value that determines whether or not to invert the filter.
		///
		public var invert: Bool = false
		
		/// A value that determines the blur radius of the filter.
		///
		public var radius: CGFloat = 1.0
		
		/// A value that determines whether the filter blur should be opaque.
		///
		public var opaque: Bool = true
		
		/// A value that determines the tint of the filter.
		///
		public var tint: Color = .clear
		
		/// A value that determines the opacity of the filter.
		///
		public var opacity: CGFloat = 1.0
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults { }

//
//
