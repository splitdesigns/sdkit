//
////
////  SDKit: Defaults
////  Developed by SPLIT Designs
////
//
////  MARK: - Imports
//
//import SwiftUI
//
////
////
//
////  MARK: - Structures
//
///// An `EnvironmentKey` containing a default value for the `defaults` key.
/////
//@available ( iOS 16.0, * )
//private struct SDDefaultsKey: EnvironmentKey {
//    
//    /// A default value for the ``SDDefaults`` environment key.
//    ///
//	fileprivate static let defaultValue: SDDefaults = .init ( )
//    
//}
//
///// A collection of overridable preferences powering `SDKit`.
/////
///// To use the defaults outside of `SDKit` components, grab the ``SDDefaults`` object from the environment with the `defaults` key.
/////
/////     @Environment ( \ .defaults ) private var defaults
/////
///// To override the default configuration, create a closure with the modified properties. You can create a trailing closure directly on the view modifier if you prefer.
/////
/////     let configuration: ( inout SDDefaults ) -> Void = {
/////
/////         defaults.colors.primary = .blue
/////
/////     }
/////
///// Inject the changes into the environment with the `setDefaults` modifier. This should be set on ``SDInterface`` or another top-level view.
/////
/////     .setDefaults { configuration ( $0 ) }
/////
///// You can append computed properties directly to a struct with extensions:
/////
/////     extension SDDefaults.Colors {
/////
/////         /// A monochromatic color with a luminance value of half of one.
/////         ///
/////         public var neutral: SDSchemeColor { .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) ) }
/////
/////     }
/////
/////
///// Alternatively, you can create new structs inside of ``SDDefaults``, and initialize them with computed properties:
/////
/////     extension SDDefaults.Colors {
/////
/////         /// A collection of custom colors, instantiated from the Custom struct.
/////         ///
/////         public var custom: Custom { .init ( ) }
/////
/////         /// A collection of custom colors.
/////         ///
/////         struct Custom {
/////
/////             /// A monochromatic color with a luminance value of half of one.
/////             ///
/////             public var neutral: SDSchemeColor = .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) )
/////
/////         }
/////
/////     }
/////     
//@available ( iOS 16.0, * )
//public struct SDDefaultsOld {
//	
//	/// Responsible for setting up coordination for our app.
//	///
//	public var coordination: Self.Coordination = .init ( )
//        
//    /// A collection of app metadata items.
//    ///
//	public var metadata: Self.Metadata = .init ( )
//    
//    /// A collection of colors.
//    ///
//	public var colors: Self.Colors = .init ( )
//	
//	/// A collection of animation curves.
//	///
//	public var animations: Self.Animations = .init ( )
//    
//    /// A collection of fonts.
//    ///
//	public var fonts: Self.Fonts = .init ( )
//	
//	/// A collection of values for configuring backdrop filters.
//	///
//	public var filters: Self.Filters = .init ( )
//	
//	/// A collection of border properties.
//	///
//	public var borders: Self.Borders = .init ( )
//	
//	/// A collection of shadow properties.
//	///
//	public var shadows: Self.Shadows = .init ( )
//	
//	/// Creates a ``SDDefaults``.
//	///
//	public init ( ) { }
//    
//}
//
////
////
//
////  MARK: - Extensions
//
//@available ( iOS 16.0, * )
//public extension EnvironmentValues {
//	
//	/// The default configuration set by ``SDDefaults``.
//	///
//	var defaults: SDDefaults {
//		
//		get { return self [ SDDefaultsKey.self ] }
//		set { return self [ SDDefaultsKey.self ] = newValue }
//		
//	}
//	
//}
//
//@available ( iOS 16.0, * )
//public extension View {
//	
//	/// Override the defaults set by ``SDDefaults`` with your own configuration.
//	///
//	/// - Parameter configuration: The configuration to overwrite the defaults with.
//	///
//	func setDefaults ( _ configuration: SDDefaults ) -> some View {
//		
//		//	Set static defaults and environment value to updated object
//		
////		SDSystem.defaults = configuration
//		return self.environment ( \ .defaults, configuration )
//		
//	}
//	
//}
//
//@available ( iOS 16.0, * )
//public extension SDDefaultsOld {
//	
//	/// Responsible for setting up coordination for our app.
//	///
//	struct Coordination {
//		
//		/// The flow used to initialize the application's state.
//		///
//		public var flow: SDFlow = .init ( "https://splitdesigns.com/launch" )
//		
//		/// Creates a ``Coordination`` instance.
//		///
//		fileprivate init ( ) { }
//		
//	}
//	
//}
//

//
//@available ( iOS 16.0, * )
//public extension SDDefaultsOld {
//	
//	/// A collection of border properties.
//	///
//	struct Borders {
//		
//		/// A color to use for borders.
//		///
//		public var color: Color = SDDefaultsOld.Colors ( ) .accent.auto.opacity ( 0.25 )
//		
//		/// A stroke style to use for borders.
//		///
//		public var style: StrokeStyle = .init ( lineWidth: 0.0 )
//		
//		/// Creates a ``Borders`` instance.
//		///
//		fileprivate init ( ) { }
//		
//	}
//	
//}
//
//@available ( iOS 16.0, * )
//public extension SDDefaultsOld {
//	
//	/// A collection of shadow properties.
//	///
//	struct Shadows {
//		
//		/// A color to use for shadows.
//		///
//		public var color: Color = SDDefaultsOld.Colors ( ) .accent.auto
//		
//		/// A radius to use for borders.
//		///
//		public var radius: CGFloat = 64.0
//		
//		/// Creates a ``Shadows`` instance.
//		///
//		fileprivate init ( ) { }
//		
//	}
//	
//}
//
//@available ( iOS 16.0, * )
//public extension SDDefaultsOld { }
//
////
////
