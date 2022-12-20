
//
//  SDKit: Library
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A collection of values used by ``SDDefaults``.
///
/// You can create additional properties and structures inside ``SDLibrary`` with extensions:
///
///		@available ( iOS 16.0, * )
///     internal extension SDLibrary.Colors {
///
///         /// A collection of natural colors.
///         ///
///         struct Natural {
///
///             /// The color of desert stone.
///             ///
///             internal static var khaki: SDSchemeColor = .init ( light: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 170.0 / 255.0 ), dark: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 170.0 / 255.0 ) )
///
///         }
///
///         /// It just feels good, doesn't it?
///         ///
///         static var funky: SDSchemeColor = .init ( light: .purple, dark: .green )
///
///     }
///
@available ( iOS 16.0, * )
public struct SDLibrary {
	
	/// Prevents the structure from being initialized.
	///
	private init ( ) { }
	
}

//
//

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension SDLibrary {
	
	/// A collection of colors.
	///
	struct Colors {
		
		/// A monochromatic color with a luminance value of zero.
		///
		public static let minimum: SDSchemeColor = .init ( light: Color ( red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0 ), dark: Color ( red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly above zero.
		///
		public static let main: SDSchemeColor = .init ( light: Color ( red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0 ), dark: Color ( red: 221.0 / 255.0, green: 221.0 / 255.0, blue: 221.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly below half of one.
		///
		public static let lower: SDSchemeColor = .init ( light: Color ( red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0 ), dark: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value of half of one.
		///
		public static let neutral: SDSchemeColor = .init ( light: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ), dark: Color ( red: 128.0 / 255.0, green: 128.0 / 255.0, blue: 128.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly above half of one.
		///
		public static let upper: SDSchemeColor = .init ( light: Color ( red: 187.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0 ), dark: Color ( red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value slightly below one.
		///
		public static let alternate: SDSchemeColor = .init ( light: Color ( red: 221.0 / 255.0, green: 221.0 / 255.0, blue: 221.0 / 255.0 ), dark: Color ( red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0 ) )
		
		/// A monochromatic color with a luminance value of one.
		///
		public static let maximum: SDSchemeColor = .init ( light: Color ( red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0 ), dark: Color ( red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0 ) )

		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
	}
	
}

@available ( iOS 16.0, * )
public extension SDLibrary {
	
	struct NewEntry {
		
		/// Prevents the structure from being initialized.
		///
		private init ( ) { }
		
	}
	
}

//
//


