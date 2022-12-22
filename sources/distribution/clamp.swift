
//
//  SDKit: Clamp
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension Comparable {

	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	private func _clamped ( in range: ClosedRange < Self > ) -> Self { return min ( max ( self, range.lowerBound ), range.upperBound ) }
	
	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	mutating func clamp ( in range: ClosedRange < Self > ) -> Void { return self = self._clamped ( in: range ) }

	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	func clamped ( in range: ClosedRange < Self > ) -> Self { return self._clamped ( in: range ) }

}

@available ( iOS 16.0, * )
public extension Strideable where Stride: SignedInteger {

	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	private func _clamped ( in range: CountableClosedRange < Self > ) -> Self { return min ( max ( self, range.lowerBound ), range.upperBound ) }
	
	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	mutating func clamp ( in range: CountableClosedRange < Self > ) -> Void { return self = self._clamped ( in: range ) }

	/// Adjusts a value to fall within a specified range.
	///
	/// - Parameter in: The range to clamp with.
	///
	func clamped ( in range: CountableClosedRange < Self > ) -> Self { return self._clamped ( in: range ) }

}

//
//
