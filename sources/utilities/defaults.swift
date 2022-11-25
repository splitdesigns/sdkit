
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
		
		/// A monochromatic color with a luminance value of zero.
		///
		public var minimum: SDSchemeColor = .init ( light: Color ( red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0 ), dark: Color ( red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly above zero.
		///
		public var main: SDSchemeColor = .init ( light: Color ( red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0 ), dark: Color ( red: 221.0 / 255.0, green: 221.0 / 255.0, blue: 221.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly below half of one.
		///
		public var lower: SDSchemeColor = .init ( light: Color ( red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0 ), dark: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value of half of one.
		///
		public var neutral: SDSchemeColor = .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly above half of one.
		///
		public var upper: SDSchemeColor = .init ( light: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0 ), dark: Color ( red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly below one.
		///
		public var alternate: SDSchemeColor = .init ( light: Color ( red: 221.0 / 255.0, green: 221.0 / 255.0, blue: 221.0 / 255.0 ), dark: Color ( red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value of one.
		///
		public var maximum: SDSchemeColor = .init ( light: Color ( red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0 ), dark: Color ( red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0 ) )
        
    }
    
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of animation curves.
	///
	struct Animations {
		
		/// The animation to use for primary transitions.
		///
		public var primary: Animation = .easeOut
		
		/// The animation to use for secondary transitions.
		///
		public var secondary: Animation = .easeInOut
		
		/// An expo-out animation curve with a custom duration.
		///
		/// - Parameter duration: The length of the animation.
		///
		public func expoOut ( duration: CGFloat = 1.0 ) -> Animation { return .timingCurve ( 0.125, 1.0, 0.25, 1.0, duration: duration ) }
		
		/// An expo-in-out animation curve with a custom duration.
		///
		/// - Parameter duration: The length of the animation.
		///
		public func expoInOut ( duration: CGFloat = 1.0 ) -> Animation { return .timingCurve ( 0.875, 0.0, 0.125, 1.0, duration: duration ) }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
    
    /// A collection of fonts.
    ///
	struct Fonts {
		
		/// The font to use for primary text.
		///
		public var primary: Font = .system ( .body, design: .default )
		
		/// The font to use for secondary text.
		///
		public var secondary: Font = .system ( .body, design: .monospaced )
		
		/// A custom sans-serif font.
		///
		/// - Parameters:
		///   - weight: The weight of the font.
		///   - size: The size of the font.
		///   - relativeStyle: The relative text style for dynamic type scaling.
		///
		public func sansSerif ( _ weight: Font.Weight = .regular, size: CGFloat = 16.0, relativeStyle: Font.TextStyle = .body ) -> Font {
			
			//	Switch over font weights
			
			switch weight {
					
				//  Return a custom font configuration
					
				case .ultraLight: return .custom ( "Karla-ExtraLight", size: size, relativeTo: relativeStyle )
				case .light: return .custom ( "Karla-Light", size: size, relativeTo: relativeStyle )
				case .regular: return .custom ( "Karla-Regular", size: size, relativeTo: relativeStyle )
				case .medium: return .custom ( "Karla-Medium", size: size, relativeTo: relativeStyle )
				case .semibold: return .custom ( "Karla-SemiBold", size: size, relativeTo: relativeStyle )
				case .bold: return .custom ( "Karla-Bold", size: size, relativeTo: relativeStyle )
				case .heavy: return .custom ( "Karla-Heavy", size: size, relativeTo: relativeStyle )
					
				default: return .custom ( "Karla-Regular", size: size, relativeTo: relativeStyle )
					
			}
			
		}
				
		/// A custom monospaced font.
		///
		/// - Parameters:
		///   - weight: The weight of the font.
		///   - size: The size of the font.
		///   - relativeStyle: The relative text style for dynamic type scaling.
		///
		public func monospaced ( _ weight: Font.Weight = .regular, size: CGFloat = 16.0, relativeStyle: Font.TextStyle = .body ) -> Font {
			
			//	Switch over font weights
			
			switch weight {
					
				//  Return a custom font configuration
					
				case .thin: return .custom ( "IBMPlexMono-Thin", size: size, relativeTo: relativeStyle )
				case .ultraLight: return .custom ( "IBMPlexMono-ExtraLight", size: size, relativeTo: relativeStyle )
				case .light: return .custom ( "IBMPlexMono-Light", size: size, relativeTo: relativeStyle )
				case .regular: return .custom ( "IBMPlexMono-Regular", size: size, relativeTo: relativeStyle )
				case .medium: return .custom ( "IBMPlexMono-Medium", size: size, relativeTo: relativeStyle )
				case .semibold: return .custom ( "IBMPlexMono-SemiBold", size: size, relativeTo: relativeStyle )
				case .bold: return .custom ( "IBMPlexMono-Bold", size: size, relativeTo: relativeStyle )
					
				default: return .custom ( "IBMPlexMono-Regular", size: size, relativeTo: relativeStyle )
					
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
		
		/// A value that determines the contrast of the filter.
		///
		public var contrast: CGFloat = 1.0
		
		/// A value that determines the filter's grayscale amount.
		///
		public var grayscale: CGFloat = 0.0
		
		/// A value that determines whether or not to invert the filter.
		///
		public var invert: Bool = false
		
		/// A value that determines the opacity of the filter.
		///
		public var opacity: CGFloat = 1.0
		
		/// A value that determines whether the filter blur should be opaque.
		///
		public var opaque: Bool = true
		
		/// A value that determines the blur radius of the filter.
		///
		public var radius: CGFloat = 0.0
		
		/// A value that determines the saturation of the filter.
		///
		public var saturation: CGFloat = 1.0
		
		/// A value that determines the tint of the filter.
		///
		public var tint: Color = .clear
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults { }

//
//
