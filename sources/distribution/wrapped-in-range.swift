
//
//  SDKit: Wrapped In Range
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension CGFloat {
	
	/// Wraps the value in the specified range.
	///
	/// - Parameters:
	///   - lowerBound: The lower bound of the range.
	///   - upperBound: The upper bound of the range.
	///
	private func wrapped ( lowerBound: Self, upperBound: Self ) -> Self {

		//	Get the spread of the range

		let difference: Self = upperBound - lowerBound

		//	Normalize the value to zero and apply a modulo

		let base: Self = ( self - lowerBound ) .truncatingRemainder ( dividingBy: difference )

		//	Calculate an offset for the output

		let offset: Self = base < 0 ? difference : 0

		//	Denormalize the base value and apply the offset

		return base + lowerBound + offset

	}

	/// Wraps the value in the specified range.
	///
	/// - Parameter in: The range to wrap the value in.
	///
	func wrapped ( in range: Range < Self > ) -> Self { return self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }

	/// Wraps the value in the specified range.
	///
	/// - Parameter in: The range to wrap the value in.
	///
	mutating func wrap ( in range: Range < Self > ) -> Void { return self = self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }

	/// Wraps the value in the specified range.
	///
	/// - Parameter in: The range to wrap the value in.
	///
	func wrapped ( in range: ClosedRange < Self > ) -> Self { return self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }

	/// Wraps the value in the specified range.
	///
	/// - Parameter in: The range to wrap the value in.
	///
	mutating func wrap ( in range: ClosedRange < Self > ) -> Void { return self = self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }

}

//
//
