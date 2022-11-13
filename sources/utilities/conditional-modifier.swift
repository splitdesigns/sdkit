
//
//  SDKit: Conditional Modifier
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Applies a transformation based on a condition.
	///
	/// - Parameter condition: The condition to evaluate.
	/// - Parameter transform: The transformation to perform when the condition is met.
	///
	@ViewBuilder func `if` < Content: View > ( _ condition: @autoclosure ( ) -> Bool, transform: ( Self ) -> Content ) -> some View { if condition ( ) { transform ( self ) } else { self } }
	
}

//
//
