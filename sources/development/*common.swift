//
////
////  SDKit: Common
////  Developed by SPLIT Designs
////
//
////  MARK: - Imports
//
//import SwiftUI
//
////
////
//
////  MARK: - Extensions
//
//@available ( iOS 16.0, * )
//public extension String {
//	
//	/// Determines if the string represents an `Int`.
//	/// 
//    var representsInt: Bool { return CharacterSet ( charactersIn: self ) .isSubset ( of: CharacterSet ( charactersIn: "0123456789" ) ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Array where Element == String {
//	
//	/// Determines whether the identifier matches the collection's element at the specified depth.
//	///
//	/// - Parameters:
//	///   - identifier: The identifier to compare against.
//	///   - at: The index to match.
//	///
//	func matches ( _ identifier: String?, at depth: Int ) -> Bool { return self.indices.contains ( depth ) ? self [ depth ] == identifier : identifier == nil ? true : false }
//	
//	/// Uses the provided closure to determine whether the element at the specified depth is a match.
//	///
//	/// - Parameters:
//	///   - condition: The closure to compare with.
//	///   - at: The index to match.
//	///
//	func matches ( _ condition: ( String ) -> Bool, at depth: Int ) -> Bool { return condition ( self [ depth ] ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension CGFloat {
//	
//	/// Replaces the current value if a condition is met.
//	///
//	/// - Parameters:
//	///   - with: The replacement value.
//	///   - if: The condition to evaluate.
//	///
//	func replace ( with replacement: CGFloat, if condition: @autoclosure ( ) -> Bool ) -> CGFloat { return condition ( ) ? replacement : self }
//	
//	/// Replaces the current value if a condition is met.
//	///
//	/// - Parameters:
//	///   - with: The replacement value.
//	///   - if: The condition to evaluate.
//	///
//	func replace ( with replacement: CGFloat?, if condition: @autoclosure ( ) -> Bool ) -> CGFloat? { return condition ( ) ? replacement : self }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension FloatingPoint {
//	
//	/// Wraps the value within the specified range.
//	///
//	/// - Parameters:
//	///   - lowerBound: The lower bound of the range.
//	///   - upperBound: The upper bound of the range.
//	///
//	private func wrapped ( lowerBound: Self, upperBound: Self ) -> Self {
//		
//		//	Get the spread of the range
//		
//		let difference: Self = upperBound - lowerBound
//		
//		//	Normalize the value to zero and apply a modulo
//		
//		let base: Self = ( self - lowerBound ) .truncatingRemainder ( dividingBy: difference )
//		
//		//	Calculate an offset for the output
//		
//		let offset: Self = base < 0 ? difference : 0
//		
//		//	Denormalize the base value and apply the offset
//		
//		return base + lowerBound + offset
//		
//	}
//	
//	/// Wraps the value within the specified range.
//	///
//	/// - Parameter in: The range to wrap the value in.
//	///
//	func wrapped ( in range: Range < Self > ) -> Self { return self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }
//	
//	/// Wraps the value within the specified range.
//	///
//	/// - Parameter in: The range to wrap the value in.
//	///
//	mutating func wrap ( in range: Range < Self > ) -> Void { return self = self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }
//	
//	/// Wraps the value within the specified range.
//	///
//	/// - Parameter in: The range to wrap the value in.
//	///
//	func wrapped ( in range: ClosedRange < Self > ) -> Self { return self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }
//	
//	/// Wraps the value within the specified range.
//	///
//	/// - Parameter in: The range to wrap the value in.
//	///
//	mutating func wrap ( in range: ClosedRange < Self > ) -> Void { return self = self.wrapped ( lowerBound: range.lowerBound, upperBound: range.upperBound ) }
//	
//	/// Interpolates a value between a lower bound and an upper bound.
//	///
//	/// - Parameter in: The range to interpolate within.
//	///
//	func lerp ( in range: ClosedRange < Self > ) -> Self { return range.lowerBound + self * ( range.upperBound - range.lowerBound ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Int {
//	
//	/// Determines if the subject integer is a boundary element index of the specified matrix.
//	///
//	/// - Parameters:
//	///   - width: The width of the matrix.
//	///   - height: The height of the matrix.
//	///
//	func isMatrixBoundaryElement ( width: Int, height: Int ) -> Bool { return !( 1 ..< width - 1 ) .contains ( self % width ) || !( width + 1 ..< width * height - width - 1 ) .contains ( self ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Comparable {
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	private func _clamped ( in range: ClosedRange < Self > ) -> Self { return min ( max ( self, range.lowerBound ), range.upperBound ) }
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	func clamped ( in range: ClosedRange < Self > ) -> Self { return self._clamped ( in: range ) }
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	mutating func clamp ( in range: ClosedRange < Self > ) -> Void { return self = self._clamped ( in: range ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Strideable where Stride: SignedInteger {
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	private func _clamped ( in range: CountableClosedRange < Self > ) -> Self { return min ( max ( self, range.lowerBound ), range.upperBound ) }
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	func clamped ( in range: CountableClosedRange < Self > ) -> Self { return self._clamped ( in: range ) }
//	
//	/// Adjusts a value to fall within a specified range.
//	///
//	/// - Parameter in: The range to clamp within.
//	///
//	mutating func clamp ( in range: CountableClosedRange < Self > ) -> Void { return self = self._clamped ( in: range ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Array {
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to, where one represents a full cycle.
//	///
//	func cycle ( to position: CGFloat) -> Self {
//		
//		//	Map over a copy of self, with indices
//		
//		return self.enumerated ( ) .map { element in
//			
//			//	Determine the index offset
//			
//			let offset: Int = .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) )
//			
//			//	Offset the current index and return the element
//			
//			return self [ ( element.offset + offset ) % self.count ]
//			
//		}
//		
//	}
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to, where one represents a full cycle.
//	///
//	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Array where Element == Double {
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to, where one represents a full cycle.
//	///
//	func cycle ( to position: CGFloat ) -> Self {
//		
//		//	Map over a copy of self, with indices
//		
//		return self.enumerated ( ) .map {
//			
//			//	Determine the progress to the next element
//			
//			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )
//			
//			//	Define the indices of the elements to merge
//			
//			let current, next: Int
//			
//			current = ( $0.offset + .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) ) % self.count
//			next = ( current + 1 ) % self.count
//			
//			//	Merge the difference with the current element
//			
//			return self [ current ] + ( self [ next ] - self [ current ] ) * progression
//			
//		}
//		
//	}
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to, where one represents a full cycle.
//	///
//	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Array where Element == Color {
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to.
//	///
//	func cycle ( to position: CGFloat ) -> Self {
//		
//		//	Split each of the colors into components, and get the component count
//		
//		let componentSet: [ [ CGFloat ] ], componentCount: Int
//		
//		componentSet = self.enumerated ( ) .map { return UIColor ( self [ $0.offset ] ) .cgColor.components! }
//		componentCount = self.indices.contains ( 0 ) ? UIColor ( self [ 0 ] ) .cgColor.numberOfComponents : 0
//		
//		//	Map over a copy of self, with indices
//		
//		return self.enumerated ( ) .map {
//			
//			//	Initialize an array for the blended components
//			
//			var components: [ CGFloat ] = .init ( repeating: .init ( ), count: componentCount )
//			
//			//	Determine the progress to the next color
//			
//			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )
//			
//			//	Define the indices of the colors to merge
//			
//			let current, next: Int
//			
//			current = ( $0.offset + .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) ) % self.count
//			next = ( current + 1 ) % self.count
//			
//			//	Loop over each color component
//			
//			for component in 0 ..< components.count {
//				
//				//	Merge the difference with the current component
//				
//				components [ component ] = componentSet [ current ] [ component ] + ( componentSet [ next ] [ component ] - componentSet [ current ] [ component ] ) * progression
//				
//			}
//			
//			//	Return a color from the blended components
//			
//			return .init ( red: components [ 0 ], green: components [ 1 ], blue: components [ 2 ], opacity: components [ 3 ] )
//			
//		}
//		
//	}
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to, where one represents a full cycle.
//	///
//	mutating func cycled ( to position: CGFloat ) -> Void { return self = self.cycle ( to: position ) }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension Array where Element == [ Color ] {
//	
//	/// Cycles the elements of the sequence to the specified position.
//	///
//	/// - Parameter to: The position to cycle to.
//	///
//	func cycle ( to position: CGFloat ) -> [ Color ] {
//		
//		//	Split each of the colors sets into components, and get the maximum number of colors
//		
//		var colorSets: [ [ [ CGFloat ] ] ], colorCount: Int = .init ( )
//		
//		colorSets = self.map { colorSet in
//			
//			colorCount = Swift.max ( colorCount, colorSet.count )
//			return colorSet.enumerated ( ) .map { return UIColor ( colorSet [ $0.offset ] ) .cgColor.components! }
//			
//		}
//		
//		//	Get the component count
//		
//		let componentCount: Int = self.indices.contains ( 0 ) && self [ 0 ] .indices.contains ( 0 ) ? UIColor ( self [ 0 ] [ 0 ] ) .cgColor.numberOfComponents : 0
//		
//		//	Iterate over the maximum number of colors
//		
//		return .init ( repeating: .clear, count: colorCount ) .enumerated ( ) .map { color in
//			
//			//	Initialize an array for the blended components
//			
//			var components: [ CGFloat ] = .init ( repeating: .init ( ), count: componentCount )
//			
//			//	Determine the progress to the next color set
//			
//			let progression: CGFloat = ( position * CGFloat ( self.count ) ) .wrapped ( in: 0.0 ..< 1.0 )
//			
//			//	Define the indices of the color sets to merge
//			
//			let current, next: Int
//			
//			current = .init ( position.wrapped ( in: 0.0 ..< 1.0 ) * CGFloat ( self.count ) ) % self.count
//			next = ( current + 1 ) % self.count
//			
//			//	Crash if the color sets are a different length
//			
//			precondition ( colorSets [ current ] .indices.contains ( color.offset ) && colorSets [ next ] .indices.contains ( color.offset ), "Color sets must be the same length." )
//			
//			//	Loop over each color component
//			
//			for component in 0 ..< components.count {
//				
//				//	Merge the difference with the current component
//				
//				components [ component ] = colorSets [ current ] [ color.offset ] [ component ] + ( colorSets [ next ] [ color.offset ] [ component ] - colorSets [ current ] [ color.offset ] [ component ] ) * progression
//				
//			}
//			
//			//	Return a color from the blended components
//			
//			return .init ( red: components [ 0 ], green: components [ 1 ], blue: components [ 2 ], opacity: components [ 3 ] )
//			
//		}
//		
//	}
//	
//}
//
////
////
