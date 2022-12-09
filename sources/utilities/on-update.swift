//
//
//  SDKit: Alternate App Icon
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A equatable container for a value.
///
@available ( iOS 16.0, * )
public struct SDAnyEquatable: Equatable, Hashable, Identifiable {
	
	/// An identifier for the view.
	///
	public let id: UUID = .init ( )
	
	/// The containerized value.
	///
	public let value: Any?
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	public static func == ( lhs: SDAnyEquatable, rhs: SDAnyEquatable ) -> Bool { return lhs.id == rhs.id }
	
	/// A hasher for hashable conformance.
	///
	/// - Parameter into: The hasher used to hash the value.
	///
	public func hash ( into hasher: inout Hasher ) { hasher.combine ( self.id ) }
	
	/// Creates an ``SDAnyEquatable``.
	///
	/// - Parameter value: The value to containerize.
	///
	public init ( _ value: Any? ) { self.value = value }
	
}

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Performs an action when some values are created or changed.
	///
	/// - Parameters:
	///   - values: The values to observe.
	///   - perform: The action to run when a mutation is observed.
	///
	func onUpdate ( of values: Any?..., perform action: @escaping ( ) -> Void ) -> some View {
		
		//	Make an array of equatable values
		
		let values: [ SDAnyEquatable ] = Array < SDAnyEquatable > .init ( repeating: .init ( nil ), count: values.count ) .enumerated ( ) .map { SDAnyEquatable ( values [ $0.offset ] ) }
		
		//	Run the action on change and initialization
		
		return self
			.onAppear { action ( ) }
			.onChange ( of: values ) { _ in action ( ) }
		
	}
	
}

//
//
