//
////
////  SDKit: Box
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
////  MARK: - Structures
//
///// A type-erased container that uses a description of the value's reflected hierarchy for equatability, or the identifier if the container is initialized as unique.
/////
//@available ( iOS 16.0, * )
//public struct SDBox: Equatable, Hashable, Identifiable {
//	
//	/// The containerized value.
//	///
//	public let value: Any?
//	
//	/// An identifier for the view.
//	///
//	public let id: UUID = .init ( )
//	
//	/// A description of the value's reflected hierarchy, or the identifier of the box.
//	///
//	public let valueSignature: String
//	
//	/// A comparator for equatable conformance.
//	///
//	/// - Parameters:
//	///   - lhs: The first value to compare.
//	///   - rhs: The second value to compare.
//	///
//	public static func == ( lhs: SDBox, rhs: SDBox ) -> Bool { return lhs.valueSignature == rhs.valueSignature }
//	
//	/// A hasher for hashable conformance.
//	///
//	/// - Parameter into: The hasher used to hash the value.
//	///
//	public func hash ( into hasher: inout Hasher ) { hasher.combine ( self.id ) }
//	
//	/// Creates an ``SDAny``.
//	///
//	/// - Parameters:
//	///   - value: The value to containerize.
//	///   - unique: Whether or not to use the view's identifier for equatability.
//	///
//	public init ( _ value: Any?, unique: Bool = false ) {
//		
//		self.value = value
//		self.valueSignature = unique ? self.id.uuidString : ( [ "signature": destructure ( value ) ] as! [ String: Any ] ) .description
//		
//	}
//	
//}
//
////
////
