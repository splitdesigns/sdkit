//
//
////
////  SDKit: Tappable
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
///// A button containing some text.
/////
//@available ( iOS 16.0, * )
//public struct SDFillable: View {
//	
//	/// Access to the `SDDefaults` configuration.
//	///
//	@Environment ( \ .defaults ) private var defaults: SDDefaults
//	
//	private let placeholder: String
//	
//	@Binding private var text: String
//	
//	/// A press interaction containing some styled text.
//	///
//	public var body: some View {
//		
//		TextField ( self.placeholder, text: self.$text )
//			.font ( defaults.fonts.monospaced ( ) )
//			.padding ( 12.0 )
//			.padding ( .horizontal, 6.0 )
//			.relativeCornerStyle ( subject: 0.0, relative: 64.0 )
//		//				.animation ( defaults.animations.expoOut ( duration: 0.5 ), value: response.isPressed )
//		//				.animation ( defaults.animations.expoOut ( duration: 0.5 ), value: response.isContained )
//		
//		//  DEV
//			.padding ( )
//		
//	}
//	
//	/// Creates a
//	///
//	/// - Parameters:
//	///   - placeholder:
//	///   - action:
//	///
//	public init ( placeholder: String, text: Binding < String > ) {
//		
//		self.placeholder = placeholder
//		self._text = text
//		
//	}
//	
//}
//
////
////
