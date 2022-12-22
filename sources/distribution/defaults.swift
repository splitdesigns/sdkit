
//
//  SDKit: Defaults
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A collection of preferences powering ``SDKit``.
///
/// Properties of ``SDDefaults`` are propagated as a whole, regardless of their underlying type. Any changes made to a nested object will trigger an update for the entire object. For more concise view updates, create an additional nested object, or use an external `ObservableObject`.
///
/// To set up defaults for your app, start by creating a `StateObject` in your app structure. Use the `setDefaults(with:)` modifier to configure and inject the defaults into the environment.
///
/// 	/// Manages the application state for ``SDKitDemo``.
/// 	///
/// 	@StateObject private var defaults: SDDefaults = .init ( )
///
/// 	...
///
/// 	SDKDAdapter ( )
/// 		.setDefaults {
///
/// 			//	Configure colors
///
/// 			self.defaults.colors.primary = SDLibrary.Colors.main
/// 			self.defaults.colors.secondary = SDLibrary.Colors.lower
/// 			self.defaults.colors.accent = SDLibrary.Colors.neutral
/// 			self.defaults.colors.background = SDLibrary.Colors.alternate
///
/// 			//	Return the defaults object
///
/// 			return self.defaults
///
/// 		}
///
/// Inside your views, use the `EnvironmentObject` property wrapper to read and write to defaults.
///
/// 	@EnvironmentObject private var defaults: SDDefaults
///
/// You can create additional properties and structures inside ``SDDefaults`` with extensions:
///
/// 	@available ( iOS 16.0, * )
/// 	internal extension SDDefaults {
///
/// 	    /// A collection of colors for typography.
/// 	    ///
/// 	    struct TextColors {
///
/// 	        /// The color to use for bold text.
/// 	        ///
/// 	        internal var bold: SDSchemeColor = SDLibrary.Colors.minimum
///
/// 			/// Creates an ``SDDefaults/TextColors`` instance.
/// 			///
/// 			fileprivate init ( ) { }
///
/// 	    }
///
/// 	    /// A collection of colors for typography.
/// 	    ///
/// 		@Published var textColors: SDDefaults.TextColors = .init ( )
/// 	
/// 	}
///
@available ( iOS 16.0, * )
public final class SDDefaults: ObservableObject {
	
	/// The application's metadata.
	///
	@Published public var metadata: SDDefaults.Metadata = .init ( )
	
	/// A collection of color preferences.
	///
	@Published public var colors: SDDefaults.Colors = .init ( )
	
	/// A collection of font preferences.
	///
	@Published public var fonts: SDDefaults.Fonts = .init ( )
	
	/// A collection of animation preferences.
	///
	@Published public var animations: SDDefaults.Animations = .init ( )
	
	/// A collection of filter preferences.
	///
	@Published public var filters: SDDefaults.Filters = .init ( )
	
	/// Creates an ``SDDefaults`` instance.
	///
	public init ( ) { }
	
}

//
//

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Configure and inject the defaults for ``SDKit``.
	///
	/// - Parameter with: Returns the defaults object to inject.
	///
	func setDefaults ( with configuration: @escaping ( _ configuration: SDDefaults ) -> SDDefaults ) -> some View { return self.environmentObject ( configuration ( .init ( ) ) ) }
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {

	/// The application's metadata.
	///
	struct Metadata {

		/// The identifier for the app.
		///
		public var identifier: String = Bundle.main.displayName ?? Bundle.main.name ?? "Unknown"

		/// The developer name.
		///
		public var developer: String = "Unknown"

		/// Creates an ``SDDefaults/Metadata`` instance.
		///
		fileprivate init ( ) { }

	}

}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of color preferences.
	///
	struct Colors {
		
		/// The color to use for primary content.
		///
		public var primary: SDSchemeColor = .init ( light: .primary, dark: .primary )
		
		/// The color to use for secondary content.
		///
		public var secondary: SDSchemeColor = .init ( light: .secondary, dark: .secondary )
		
		/// The color to use for tinting and accentuated content.
		///
		public var accent: SDSchemeColor = .init ( light: .accentColor, dark: .accentColor )
		
		/// The color to use for the background.
		///
		public var background: SDSchemeColor = .init ( light: .white, dark: .black )
		
		/// Creates an ``SDDefaults/Colors`` instance.
		///
		fileprivate init ( ) { }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of font preferences.
	///
	struct Fonts {
		
		/// Accepts a font style, and returns a font to use for primary text. See ``SDFontStyle`` for more info.
		///
		/// - Parameter style: The font style to use.
		///
		public var primary: ( _ style: SDFontStyle ) -> Font = { return .custom ( .init ( ), size: $0.size ) }
		
		/// Accepts a font style, and returns a font to use for secondary text. See ``SDFontStyle`` for more info.
		///
		/// - Parameter style: The font style to use.
		///
		public var secondary: ( _ style: SDFontStyle ) -> Font = { return .custom ( .init ( ), size: $0.size ) .monospaced ( ) }
		
		/// Creates an ``SDDefaults/Fonts`` instance.
		///
		fileprivate init ( ) { }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of animation preferences.
	///
	struct Animations {
		
		/// The timing curve to use for primary animations.
		///
		/// - Parameter duration: The duration of the animation.
		///
		public var primary: ( _ duration: CGFloat ) -> Animation = { return .easeOut ( duration: $0 ) }
		
		/// The timing curve to use for secondary animations.
		///
		/// - Parameter duration: The duration of the animation.
		///
		public var secondary: ( _ duration: CGFloat ) -> Animation = { return .easeInOut ( duration: $0 ) }
		
		/// Creates an ``SDDefaults/Animations`` instance.
		///
		fileprivate init ( ) { }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {

	/// A collection of filter preferences.
	///
	struct Filters {

		/// The brightness of the content.
		///
		public var brightness: CGFloat = 0.0

		/// The contrast of the content.
		///
		public var contrast: CGFloat = 1.0

		/// The grayscale value of the content.
		///
		public var grayscale: CGFloat = 0.0

		/// Invert the content.
		///
		public var invert: Bool = false

		/// The opacity of the content.
		///
		public var opacity: CGFloat = 1.0

		/// Make the content blur opaque.
		///
		public var opaque: Bool = true

		/// The radius of the content blur.
		///
		public var radius: CGFloat = 0.0

		/// The saturation of the content.
		///
		public var saturation: CGFloat = 1.0

		/// The color to tint the content.
		///
		public var tint: SDSchemeColor = .init ( light: .clear, dark: .clear )
		
		/// Clip the filter.
		///
		public var clip: Bool = true

		/// Creates an ``SDDefaults/Filters`` instance.
		///
		fileprivate init ( ) { }

	}

}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// Desc.
	///
	struct SDNewEntry {
		
		/// Creates an ``SDNewEntry`` instance.
		///
		fileprivate init ( ) { }
		
	}
	
}

//
//
