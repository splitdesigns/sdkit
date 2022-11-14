
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
public extension Array where Element == String {
	
	/// Determines whether the identifier matches the collection's element at the specified depth.
	///
	/// - Parameter identifier: The identifier to compare against.
	/// - Parameter at: The index to match.
	///
	func matches ( _ identifier: String?, at depth: Int ) -> Bool { return self.indices.contains ( depth ) ? self [ depth ] == identifier : identifier == nil ? true : false }
	
	/// Uses the provided closure to determine whether the element at the specified depth is a match.
	///
	/// - Parameter condition: The closure to compare with.
	/// - Parameter at: The index to match.
	///
	func matches ( _ condition: ( String ) -> Bool, at depth: Int ) -> Bool { return condition ( self [ depth ] ) }
	
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
