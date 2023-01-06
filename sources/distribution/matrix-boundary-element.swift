
//
//  SDKit: Matrix Boundary Element
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension Int {

	/// Determines if the subject integer is a boundary element index of the specified matrix.
	///
	/// - Parameters:
	///   - width: The width of the matrix.
	///   - height: The height of the matrix.
	///
	func isMatrixBoundaryElement ( width: Int, height: Int ) -> Bool { return !( 1 ..< width - 1 ) .contains ( self % width ) || !( width + 1 ..< width * height - width - 1 ) .contains ( self ) }

}

//
//
