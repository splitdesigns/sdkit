
//
//  SDKit: Value Cycling
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension Array {

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to, where one represents a full cycle.
	///
	func cycle ( to position: CGFloat ) -> Self {

		//	Map over a copy of self, with indices

		return self.enumerated ( ) .map { element in

			//	Determine the index offset

			let offset: Int = .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) )

			//	Offset the current index and return the element

			return self [ ( element.offset + offset ) % self.count ]

		}

	}

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to, where one represents a full cycle.
	///
	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }

}

@available ( iOS 16.0, * )
public extension Array where Element == Double {

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to, where one represents a full cycle.
	///
	func cycle ( to position: CGFloat ) -> Self {

		//	Map over a copy of self, with indices

		return self.enumerated ( ) .map {

			//	Determine the progress to the next element

			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )

			//	Define the indices of the elements to merge

			let current, next: Int

			current = ( $0.offset + .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) ) % self.count
			next = ( current + 1 ) % self.count

			//	Merge the difference with the current element

			return self [ current ] + ( self [ next ] - self [ current ] ) * progression

		}

	}

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to, where one represents a full cycle.
	///
	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }

}

@available ( iOS 16.0, * )
public extension Array where Element == Color {

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to.
	///
	func cycle ( to position: CGFloat ) -> Self {

		//	Split each of the colors into components, and get the component count

		let componentSet: [ [ CGFloat ] ], componentCount: Int

		componentSet = self.enumerated ( ) .map { return UIColor ( self [ $0.offset ] ) .cgColor.components! }
		componentCount = self.indices.contains ( 0 ) ? UIColor ( self [ 0 ] ) .cgColor.numberOfComponents : 0

		//	Map over a copy of self, with indices

		return self.enumerated ( ) .map {

			//	Initialize an array for the blended components

			var components: [ CGFloat ] = .init ( repeating: .init ( ), count: componentCount )

			//	Determine the progress to the next color

			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )

			//	Define the indices of the colors to merge

			let current, next: Int

			current = ( $0.offset + .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) ) % self.count
			next = ( current + 1 ) % self.count

			//	Loop over each color component

			for component in 0 ..< components.count {

				//	Merge the difference with the current component

				components [ component ] = componentSet [ current ] [ component ] + ( componentSet [ next ] [ component ] - componentSet [ current ] [ component ] ) * progression

			}

			//	Return a color from the blended components

			return .init ( red: components [ 0 ], green: components [ 1 ], blue: components [ 2 ], opacity: components [ 3 ] )

		}

	}

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to, where one represents a full cycle.
	///
	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }

}

@available ( iOS 16.0, * )
public extension Array where Element == [ Color ] {

	/// Cycles the elements of the sequence to the specified position.
	///
	/// - Parameter to: The position to cycle to.
	///
	func cycle ( to position: CGFloat ) -> [ Color ] {

		//	Split each of the colors sets into components, and get the maximum number of colors

		var colorSets: [ [ [ CGFloat ] ] ], colorCount: Int = .init ( )

		colorSets = self.map { colorSet in
			
			//  Update the color count and return a color set

			colorCount = Swift.max ( colorCount, colorSet.count )
			return colorSet.enumerated ( ) .map { return UIColor ( colorSet [ $0.offset ] ) .cgColor.components! }

		}

		//	Get the component count

		let componentCount: Int = self.indices.contains ( 0 ) && self [ 0 ] .indices.contains ( 0 ) ? UIColor ( self [ 0 ] [ 0 ] ) .cgColor.numberOfComponents : 0

		//	Iterate over the maximum number of colors

		return .init ( repeating: .clear, count: colorCount ) .enumerated ( ) .map { color in

			//	Initialize an array for the blended components

			var components: [ CGFloat ] = .init ( repeating: .init ( ), count: componentCount )

			//	Determine the progress to the next color set

			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )

			//	Define the indices of the color sets to merge

			let current, next: Int

			current = .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) % self.count
			next = ( current + 1 ) % self.count

			//	Crash if the color sets are a different length

			precondition ( colorSets [ current ] .indices.contains ( color.offset ) && colorSets [ next ] .indices.contains ( color.offset ), "Color sets must be the same length." )

			//	Loop over each color component

			for component in 0 ..< components.count {

				//	Merge the difference with the current component

				components [ component ] = colorSets [ current ] [ color.offset ] [ component ] + ( colorSets [ next ] [ color.offset ] [ component ] - colorSets [ current ] [ color.offset ] [ component ] ) * progression

			}

			//	Return a color from the blended components

			return .init ( red: components [ 0 ], green: components [ 1 ], blue: components [ 2 ], opacity: components [ 3 ] )

		}

	}

}

//
//
