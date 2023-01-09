
//
//  SDKit: Dynamic Type Size
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Extensions

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
