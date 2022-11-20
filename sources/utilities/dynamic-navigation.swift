
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
@available ( iOS 16.0, * )
public struct SDFlow {
	
	/// The link to parse into a view hierarchy.
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
		
		/// Move in to the specified location.
		///
		case `in` ( to: String )
		
		/// Move out to the previous location.
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
				
			case .in ( to: let hierarchy ) : self.location.append ( path: hierarchy )
			case .out ( steps: let steps ) : for _ in 0 ... steps { self.location.deleteLastPathComponent ( ) }
				
			case .to ( hierarchy: let hierarchy ) :
				
				//	Split the location into components, set the path, and return the URL
				
				var components: URLComponents? = URLComponents ( url: self.location, resolvingAgainstBaseURL: false )
				components?.path = !( hierarchy?.isEmpty ?? false ) && hierarchy != nil ? hierarchy! : ""
				self.location = components?.url ?? self.location
				
		}
		
		return
		
	}
	
	/// Sets the root location and the query items of the SDFlow.
	///
	/// - Parameter location: The URL representing the app's view hierarchy.
	/// - Parameter parameters: A closure modifying the query item object passed in.
	///
	public mutating func set ( _ raw: String? = nil, location: URL? = nil, parameters: ( ( [ String: String ] ) -> [ String: String ] )? = nil ) -> Void {
		
		//  Run each of the closures if they exist
		
		if let raw = raw {
			
			//	Try to initialize a location, then return the URL
			
			guard let location = URL ( string: raw ) else { preconditionFailure ( "Failed to initialize a URL from \"\( raw )\"." ) }
			self.location = location
			
		}
		
		if let location = location { self.location = location }
		
		if let parameters = parameters {
			
			//	Split the location into components, set the query items, and return the URL
			
			var components: URLComponents? = URLComponents ( url: self.location, resolvingAgainstBaseURL: false )
			components?.queryItems = parameters ( self.parameters ) .map { return URLQueryItem ( name: $0.key, value: $0.value ) }
			self.location = components?.url ?? self.location
			
			return
			
		}
		
		return
		
	}
	
	///	Creates a ``SDFlow`` from a string representation of the view hierarchy.
	///
	///	- Parameter raw: A stringified URL to set as the location.
	///
	public init ( _ raw: String ) {
		
		//	Safely initialize the URL
		
		guard let location = URL ( string: raw ) else { preconditionFailure ( "Failed to initialize a URL from \"\( raw )\"." ) }
		self.location = location
		
	}
	
	///	Creates a ``SDFlow`` from a URL representing the view hierarchy.
	///
	///	- Parameter location: A URL to set as the location.
	///
	public init ( location: URL ) { self.location = location }
	
}

/// Runs a closure when the app is launched via a Universal Link.
///
@available ( iOS 16.0, * )
private struct SDUniversalLink: ViewModifier {
	
	/// The closure to run when a link is received.
	///
	private let closure: ( URL ) -> Void
	
	/// Runs the closure when a link is received.
	///
	/// - Parameter content: The content being modified.
	///
	public func body ( content: Content ) -> some View { return content.onOpenURL { self.closure ( $0 ) } }
	
	/// Creates a ``SDUniversalLink`` from a closure.
	///
	/// - Parameter run: The closure to run when a link is received.
	///
	public init ( run closure: @escaping ( URL ) -> Void ) { self.closure = closure }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Runs the provided closure upon receipt of an incoming URL.
	///
	/// - Parameter run: The closure to run when a link is received.
	///
	func onUniversalLink ( run closure: @escaping ( URL ) -> Void ) -> some View { return modifier ( SDUniversalLink ( run: closure ) ) }
	
}

//
//
