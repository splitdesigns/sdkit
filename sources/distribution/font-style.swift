
//
//  SDKit: Font Style
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A collection of predefined styles for custom fonts.
///
/// ``SDFontStyle`` makes it easier to work with custom fonts implemented with ``SDDefaults``.
///
/// To override a default font, provide a closure that initializes and returns a font using the provided style:
///
/// 	self.defaults.fonts.primary = { return .custom ( "Karla", size: $0.size ) }
///
/// To use a default font, simply call the closure with the style that you would like to use:
///
/// 	Text ( "Hello, world!" )
/// 		.scaledFont ( self.defaults.fonts.primary, style: .body )
///
/// You can also initialize a custom style:
///
/// 	Text ( "Hello, world!" )
/// 		.scaledFont ( self.defaults.fonts.primary, style: .init ( size: 32.0 ) )
///
/// Or, extend ``SDFontStyle`` to include your own predefined style:
///
/// 	@available ( iOS 16.0, * )
/// 	public extension SDFontStyle {
///
/// 		/// A style suitable for tertiary headings.
/// 		///
/// 		public static let headingThree: Self = .init ( size: 24.0 )
///
/// 	}
///
/// - Note: For now, a font style only consists of a size. This is due to the fact that the font size for custom fonts can only be set inside the initializer, while other attributes like weight, italics, and width can be manipulated with modifiers. This may change closer to the development of a Markdown implementation.
///
@available ( iOS 16.0, * )
public struct SDFontStyle {
	
	/// The size of the font.
	///
	public let size: CGFloat
	
	/// A style suitable for primary headings ( 48.0 px ).
	///
	public static let headingOne: Self = .init ( size: 48.0 )
	
	/// A style suitable for secondary headings ( 40.0 px ).
	///
	public static let headingTwo: Self = .init ( size: 40.0 )
	
	/// A style suitable for tertiary headings ( 32.0 px ).
	///
	public static let headingThree: Self = .init ( size: 32.0 )
	
	/// A style suitable for quaternary headings ( 24.0 px ).
	///
	public static let headingFour: Self = .init ( size: 24.0 )
	
	/// A style suitable for body text ( 16.0 px ).
	///
	public static let body: Self = .init ( size: 16.0 )
	
	/// Creates an ``SDFontStyle`` instance from a size.
	///
	/// - Parameter size: The size of the font.
	///
	public init ( size: CGFloat ) { self.size = size }
		
}

//
//
