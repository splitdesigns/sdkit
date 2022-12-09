
//
//  SDKit: Box
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A multipurpose box for any value. Uses the value's debug description for equatability, or the UUID if initialized as unique.
///
@available ( iOS 16.0, * )
public struct SDBox: Equatable, Hashable, Identifiable {
	
	/// An identifier for the view.
	///
	public let id: UUID = .init ( )
	
	/// The containerized value.
	///
	public let value: Any?
	
	/// Whether or not to use the UUID for equatability.
	///
	private let unique: Bool
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	public static func == ( lhs: SDBox, rhs: SDBox ) -> Bool { return lhs.unique || rhs.unique ? lhs.id == rhs.id : lhs.value.debugDescription == rhs.value.debugDescription }
	
	/// A hasher for hashable conformance.
	///
	/// - Parameter into: The hasher used to hash the value.
	///
	public func hash ( into hasher: inout Hasher ) { self.unique ? hasher.combine ( self.id ) : hasher.combine ( self.value.debugDescription ) }
	
	/// Creates an ``SDAny``.
	///
	/// - Parameters:
	///   - value: The value to containerize.
	///   - unique: Whether or not to use the UUID for equatability.
	///
	public init ( _ value: Any?, unique: Bool = false ) {
		
		self.value = value
		self.unique = unique
		
	}
	
}

//
//
