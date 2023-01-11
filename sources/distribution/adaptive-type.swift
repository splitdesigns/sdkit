
//
//  SDKit: Adaptive Type
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Sets a font while also enabling any embedded Dynamic Type functionality and accessibility modifiers.
///
@available ( iOS 16.0, * )
public struct SDAdaptiveFont: ViewModifier {
	
	///	Access to the Dynamic Type size.
	///
	@Environment ( \ .dynamicTypeSize ) private var dynamicTypeSize
	
	///	Access to the accessibility legibility weight.
	///
	@Environment ( \ .legibilityWeight ) private var legibilityWeight
	
	/// The font to set.
	///
	private let font: ( ( _ style: SDFontStyle ) -> Font )?
	
	/// The font style to set.
	///
	private let fontStyle: SDFontStyle?
	
	/// Sets the font for the content.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.font ( self.font? ( self.fontStyle ?? .body ) )
			.bold ( self.legibilityWeight == .bold )
		
	}
	
	/// Creates an ``SDAdaptiveFont`` instance from a font and a font style.
	///
	/// - Parameters:
	///   - font: The font to set.
	///   - style: The font style to set.
	///
	public init ( _ font: ( ( _ style: SDFontStyle ) -> Font )?, style fontStyle: SDFontStyle? = .body ) {
		
		self.font = font
		self.fontStyle = fontStyle
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Sets a font while also enabling any embedded Dynamic Type functionality and accessibility modifiers.
	///
	/// - Parameters:
	///   - font: The font to set.
	///   - style: The font style to set.
	///
	func adaptiveFont ( _ font: ( ( _ style: SDFontStyle ) -> Font )?, style fontStyle: SDFontStyle? = .body ) -> some View { self.modifier ( SDAdaptiveFont ( font, style: fontStyle ) ) }
	
}

@available ( iOS 16.0, * )
public extension DynamicTypeSize {
	
	/// The value used to scale the `.body` font style relative to the Dynamic Type Size.
	///
	var scale: CGFloat { return self.raw / Self.large.raw }
	
	///	The size of the `.body` font style relative to the current Dynamic Type Size in points.
	///
	var raw: CGFloat {
		
		//	Switch over the Dynamic Type Size options
		
		switch self {
				
				//  An extra small size
				
			case .xSmall: return 14.0
				
				//  A small size
				
			case .small: return 15.0
				
				//  A medium size
				
			case .medium: return 16.0
				
				//  A large size
				
			case .large: return 17.0
				
				//  An extra large size
				
			case .xLarge: return 19.0
				
				//  An extra extra large size
				
			case .xxLarge: return 21.0
				
				//  An extra extra extra large size
				
			case .xxxLarge: return 23.0
				
				//  The first accessibility size
				
			case .accessibility1: return 28.0
				
				//  The second accessibility size
				
			case .accessibility2: return 33.0
				
				//  The third accessibility size
				
			case .accessibility3: return 40.0
				
				//  The fourth accessibility size
				
			case .accessibility4: return 47.0
				
				//  The fifth accessibility size
				
			case .accessibility5: return 53.0
				
				//	A default size
				
			@unknown default: return 16.0
				
		}
		
	}
	
}

//
//
