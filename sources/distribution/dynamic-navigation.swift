
//
//  SDKit: Dynamic Navigation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Represents a location within an application.
///
/// ``SDFlow`` wraps a `URL` for use inside of an application as a representation of the current view hierarchy.
///
/// To navigate with a ``SDFlow``, use the ``SDFlow/move(_:)`` method to move in to, out of, and to completely different view hierarchies.
///
/// Use the ``SDFlow/set(_:location:parameters:)`` method to set parameters of the flow, such as the base URL, raw location, or query items.
///
@available ( iOS 16.0, * )
public struct SDFlow {
	
	/// The URL representing the view hierarchy.
	///
	private var location: URL
	
	/// The location URL as a string.
	///
	public var raw: String { return self.location.absoluteString }
	
	/// The path components of the location URL.
	///
	public var identifiers: [ String ] { return self.location.pathComponents.compactMap { return $0 != "/" ? $0 : nil } }
	
	/// The query items of the location URL.
	///
	public var parameters: [ String: String ] { return .init ( URLComponents ( url: self.location, resolvingAgainstBaseURL: false )? .queryItems? .map { return ( $0.name, $0.value ?? "" ) } ?? [ ] ) { _, duplicate in duplicate } }
	
	/// Ways to navigate a ``SDFlow``.
	///
	public enum MoveDirection {
		
		/// Move in to a specific location.
		///
		case `in` ( to: String )
		
		/// Move out to a previous location.
		///
		/// - Parameter steps: The number of times to move out.
		///
		case out ( steps: Int = 1 )
		
		/// Move to a specific hierarchy.
		///
		/// - Parameter hierarchy: The path to append to the base URL.
		///
		case to ( hierarchy: String? )
		
	}
	
	/// Moves to a specific location within the view hierarchy.
	///
	/// - Parameter direction: The direction to move within the hierarchy.
	///
	public mutating func move ( _ direction: MoveDirection ) -> Void {
		
		switch direction {
				
				//  Move in to a specific location
				
			case .in ( to: let hierarchy ): self.location.append ( path: hierarchy )
				
				//  Move out to a previous location
				
			case .out ( steps: let steps ): for _ in 0 ... steps { self.location.deleteLastPathComponent ( ) }
				
				//	Move to a specific hierarchy
				
			case .to ( hierarchy: let hierarchy ):
				
				//	Split the location into components, set the path, and return the URL
				
				var components: URLComponents? = URLComponents ( url: self.location, resolvingAgainstBaseURL: false )
				components?.path = !( hierarchy?.isEmpty ?? false ) && hierarchy != nil ? hierarchy! : ""
				self.location = components?.url ?? self.location
				
		}
		
	}
	
	/// Sets the root location and query items of the SDFlow.
	///
	/// - Parameters:
	///   - raw: The location URL as a string.
	///   - location: The URL representing the view hierarchy.
	///   - parameters: A closure that transforms a dictionary of query items.
	///
	public mutating func set ( _ raw: String? = nil, location: URL? = nil, parameters parameterTransform: ( ( inout [ String: String ] ) -> Void )? = nil ) -> Void {
		
		//  Check if a raw location was passed in
		
		if let raw = raw {
			
			//	Try to initialize a URL from the string, then set the URL
			
			guard let location = URL ( string: raw ) else { preconditionFailure ( "Failed to initialize a URL from \"\( raw )\"." ) }
			self.location = location
			
		}
		
		//	Check if a location was passed in, then set it
		
		if let location = location { self.location = location }
		
		//	Check if a parameter transform was passed in
		
		if let parameterTransform = parameterTransform {
			
			//	Create a copy of the query item dictionary, and apply the transform
			
			var parameters = self.parameters
			parameterTransform ( &parameters )
			
			//	Split the location into components, set the query items, and return the URL
			
			var components: URLComponents? = URLComponents ( url: self.location, resolvingAgainstBaseURL: false )
			components?.queryItems = parameters.map { return URLQueryItem ( name: $0.key, value: $0.value ) }
			self.location = components?.url ?? self.location
			
		}
		
	}
	
	///	Creates an ``SDFlow`` instance from a typed URL representation of the view hierarchy.
	///
	///	- Parameter raw: The location URL as a string.
	///
	public init ( _ raw: String ) {
		
		//	Safely initialize the URL
		
		guard let location = URL ( string: raw ) else { preconditionFailure ( "Failed to initialize a URL from \"\( raw )\"." ) }
		self.location = location
		
	}
	
	///	Creates an ``SDFlow`` instance from a URL representation of the view hierarchy.
	///
	///	- Parameter location: The URL representing the view hierarchy.
	///
	public init ( location: URL ) { self.location = location }
	
}

/// Performs an action when a universal link is received.
///
@available ( iOS 16.0, * )
private struct SDOnUniversalLink: ViewModifier {
	
	/// The action to perform.
	///
	private let action: ( URL ) -> Void
	
	/// Performs the action.
	///
	public func body ( content: Content ) -> some View { return content.onOpenURL { self.action ( $0 ) } }
	
	/// Creates an ``SDOnUniversalLink`` instance from an action.
	///
	/// - Parameter perform: The action to perform.
	///
	public init ( perform action: @escaping ( URL ) -> Void ) { self.action = action }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Performs an action when a universal link is received.
	///
	/// - Parameter perform: The action to perform.
	///
	func onUniversalLink ( perform action: @escaping ( URL ) -> Void ) -> some View { return self.modifier ( SDOnUniversalLink ( perform: action ) ) }
	
}

//
//
