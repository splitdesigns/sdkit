
//
//  SDKit: Linear Interpolation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension FloatingPoint {
	
	/// Interpolates a value between a lower bound and an upper bound.
	///
	/// - Parameter in: The range to interpolate in.
	///
	func lerp ( in range: ClosedRange < Self > ) -> Self { return range.lowerBound + self * ( range.upperBound - range.lowerBound ) }
	
}

//
//
