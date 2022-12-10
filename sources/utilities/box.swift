
//
//  SDKit: Box
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A multipurpose box for any value. Uses a description of the value's reflected hierarchy for equatability, or the UUID if initialized as unique.
///
@available ( iOS 16.0, * )
public struct SDBox: Equatable, Hashable, Identifiable {
	
	/// The containerized value.
	///
	public let value: Any?
	
	///   - unique: Whether or not to use the UUID for equatability.
	///
	private let unique: Bool
	
	/// An identifier for the view.
	///
	public var id: String { return self.unique ? UUID ( ) .uuidString : ( [ "destructuredValue": destructure ( value ) ] as! [ String: Any ] ) .description }
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	public static func == ( lhs: SDBox, rhs: SDBox ) -> Bool { return lhs.id == rhs.id }
	
	/// A hasher for hashable conformance.
	///
	/// - Parameter into: The hasher used to hash the value.
	///
	public func hash ( into hasher: inout Hasher ) { hasher.combine ( self.id ) }
	
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
