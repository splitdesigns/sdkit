
//
//  SDKit: JSON Parser
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Foundation

//
//

//  MARK: - Structures

/// A JSON parser with dynamic lookup support.
///
/// ``SDJSON`` is a lightweight `JSONSerialization` wrapper for digging through JSON objects. It uses dynamic member lookup and subscripts to replicate dot notation syntax used in other languages. Access, typecast, unwrap, and use. Returns `nil` if there is an error.
///
/// To parse a JSON string, pass it into a ``SDJSON`` initializer:
///
///     let combinations: String = "[ { \"luggage\": \"1234\" } ]"
///     let json: SDJSON = .init ( combinations )
///
/// Once initialized, you can dynamically chain dictionary keys as you would in JavaScript. When you're ready to retrieve the value, call ``SDJSON/parse()`` on the ``SDJSON`` object. The return value will be an optional of type `Any`. To use it, perform an optional typecast before unwrapping the result.
///
///     let value: Any? = json [ 0 ] .luggage.parse ( )
///     let result: String = value as? String ?? "unknown"
///
/// - Warning: ``SDJSON`` will return `nil` if you initialize it with an invalid JSON string, as will ``SDJSON/parse()`` if you try to call a nonexistent subscript or lookup path.
///
@available ( iOS 16.0, * )
@dynamicMemberLookup public struct SDJSON: RandomAccessCollection {
        
    /// A start index for `RandomAccessCollection` conformance.
    ///
	public var startIndex: Int { return ( self.array ?? [ ] ) .startIndex }
    
    /// An end index for `RandomAccessCollection` conformance.
    ///
	public var endIndex: Int { return ( self.array ?? [ ] ) .endIndex }
            
    /// The JSON or ``SDJSON`` object to parse.
    ///
    private let value: Any?
    
    /// An array of ``SDJSON`` objects.
    ///
	private var array: [ SDJSON ]? { return ( self.value as? [ Any ] )? .map { return SDJSON ( value: $0 ) } }
    
    /// A Dictionary of ``SDJSON`` objects.
    ///
	private var dictionary: [ String: SDJSON ]? { return ( self.value as? [ String: Any ] )? .mapValues { return SDJSON ( value: $0 ) } }
        
    /// Creates an ``SDJSON`` instance from a string.
    ///
	/// - Parameter source: The string to derive a JSON object from.
	///
	public init ( _ source: String ) { self.value = try? JSONSerialization.jsonObject ( with: Data ( source.utf8 ) ) }
    
    /// Creates an ``SDJSON`` instance from a ``SDJSON`` value.
	///
	/// - Parameter value: The internal value to initialize with.
    ///
    private init ( value: Any? ) { self.value = value }
        
    /// Subscript support for ``SDJSON`` arrays.
	///
	/// - Parameter index: The index of the array.
    ///
	public subscript ( index: Int ) -> SDJSON { return self.array? [ index ] ?? SDJSON ( value: nil ) }
    
    /// Subscript support for ``SDJSON`` dictionaries.
	///
	/// - Parameter key: The key for accessing the dictionary.
    ///
	public subscript ( key: String ) -> SDJSON { return self.dictionary? [ key ] ?? SDJSON ( value: nil ) }
    
    /// Dynamic member lookup support for ``SDJSON`` dictionaries.
	///
	/// - Parameter dynamicMember: Accesses a dictionary with DynamicMember support.
    ///
	public subscript ( dynamicMember key: String ) -> SDJSON { return self.dictionary? [ key ] ?? SDJSON ( value: nil ) }
    
    /// Returns the value of the ``SDJSON`` object.
    ///
	public func parse ( ) -> Any? { return self.value }

}

//
//
