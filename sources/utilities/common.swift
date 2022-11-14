
//
//  SDKit: Common
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension String {
	
	/// Determines if the string represents an `Int`.
	/// 
    var representsInt: Bool { return CharacterSet ( charactersIn: self ) .isSubset ( of: CharacterSet ( charactersIn: "0123456789" ) ) }
	
}

@available ( iOS 16.0, * )
public extension CGFloat {
	
	/// Replaces the current value if a condition is met.
	///
	/// - Parameter with: The replacement value.
	/// - Parameter if: The condition to evaluate.
	///
	func replace ( with replacement: CGFloat, if condition: @autoclosure ( ) -> Bool ) -> CGFloat { return condition ( ) ? replacement : self }
	
	/// Replaces the current value if a condition is met.
	///
	/// - Parameter with: The replacement value.
	/// - Parameter if: The condition to evaluate.
	///
	func replace ( with replacement: CGFloat?, if condition: @autoclosure ( ) -> Bool ) -> CGFloat? { return condition ( ) ? replacement : self }
	
}

//
//
