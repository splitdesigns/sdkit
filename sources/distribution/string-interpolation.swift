
//
//  SDKit: String Interpolation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension String {
	
	/// Determines if a string represents an `Int`.
	///
	var representsInt: Bool { return CharacterSet ( charactersIn: self ) .isSubset ( of: CharacterSet ( charactersIn: "0123456789" ) ) }
	
}

//
//
