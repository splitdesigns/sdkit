
//
//  SDKit: Collection Depth Matching
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension Array where Element == String {
	
	/// Determines whether the identifier matches the collection's element at the specified depth.
	///
	/// - Parameters:
	///   - identifier: The identifier to compare against.
	///   - at: The index to match.
	///
	func matches ( _ identifier: String?, at depth: Int ) -> Bool { return self.indices.contains ( depth ) ? self [ depth ] == identifier : identifier == nil ? true : false }
	
	/// Uses the provided closure to determine whether the element at the specified depth is a match.
	///
	/// - Parameters:
	///   - condition: The closure to compare with.
	///   - at: The index to match.
	///
	func matches ( _ condition: ( String ) -> Bool, at depth: Int ) -> Bool { return condition ( self [ depth ] ) }
	
}
