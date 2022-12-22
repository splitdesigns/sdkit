
//
//  SDKit: Defaults
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A collection of preferences powering ``SDKit``. Defaults are meant to be configured during development, and not to be used as state.
///
/// To override a value, modify it within the initializer of your app structure.
///
///		/// Creates an ``SDKitDemo`` app.
///		///
///		fileprivate init ( ) { SDDefaults.Colors.background = SDLibrary.Colors.alternate }
///
/// You can create additional properties and structures inside ``SDDefaults`` with extensions:
///
///		@available ( iOS 16.0, * )
///     internal extension SDDefaults.Colors {
///
///         /// A collection of colors for typography.
///         ///
///         struct Text {
///
///             /// The color to use for bold text.
///             ///
///             internal static var bold: SDSchemeColor = SDLibrary.Colors.minimum
///
///         }
///
///         /// The color to use for tertiary content.
///         ///
///         static let tertiary: SDSchemeColor = .init ( light: Color ( UIColor.tertiarySystemFill ), dark: Color ( UIColor.tertiarySystemBackground ) )
///
///     }
///
@available ( iOS 16.0, * )
public struct SDDefaults {
	
	/// Prevents the structure from being initialized.
	///
	private init ( ) { }

}

//
//

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// A collection of color preferences.
	/// 
	struct Colors {
		
		/// The color to use for primary content.
		///
		public static var primary: SDSchemeColor = .init ( light: .primary, dark: .primary )
		
		/// The color to use for secondary content.
		///
		public static var secondary: SDSchemeColor = .init ( light: .secondary, dark: .secondary )
		
		/// The color to use for tinting and accentuated content.
		///
		public static var accent: SDSchemeColor = .init ( light: .accentColor, dark: .accentColor )
		
		/// The color to use for the background.
		///
		public static var background: SDSchemeColor = .init ( light: .white, dark: .black )
		
		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
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
		public static var primary: ( _ style: SDFontStyle ) -> Font = { return .custom ( .init ( ), size: $0.size ) }

		/// Accepts a font style, and returns a font to use for secondary text. See ``SDFontStyle`` for more info.
		///
		/// - Parameter style: The font style to use.
		///
		public static var secondary: ( _ style: SDFontStyle ) -> Font = { return .custom ( .init ( ), size: $0.size ) .monospaced ( ) }
		
		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
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
		public static var primary: ( _ duration: CGFloat ) -> Animation = { return .easeOut ( duration: $0 ) }
		
		/// The timing curve to use for secondary animations.
		///
		/// - Parameter duration: The duration of the animation.
		///
		public static var secondary: ( _ duration: CGFloat ) -> Animation = { return .easeInOut ( duration: $0 ) }
		
		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDDefaults {
	
	/// Desc.
	///
	struct NewEntry {
		
		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
	}
	
}

//
//
