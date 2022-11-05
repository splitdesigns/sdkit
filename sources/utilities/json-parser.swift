
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
/// To parse a JSON string, pass it into a ``SDJSON`` initializer:
///
///     let combinations: String = "[ { \"luggage\": \"1234\" } ]"
///     let json: SDJSON = .init ( combinations )
///
/// Once initialized, you can dynamically chain dictionary keys as you would with JavaScript. When you're ready to retrieve the value, call ``SDJSON/parse()`` on the ``SDJSON`` object. The return value will be an optional of type `Any`. To use it, perform an optional typecast before unwrapping the result.
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
    public var startIndex: Int { return ( array ?? [ ] ) .startIndex }
    
    /// An end index for `RandomAccessCollection` conformance.
    ///
    public var endIndex: Int { return ( array ?? [ ] ) .endIndex }
            
    /// The JSON or `SDJSON` object to parse.
    ///
    private let value: Any?
    
    /// An array of `SDJSON` objects.
    ///
    private var array: [ SDJSON ]? { return ( value as? [ Any ] )? .map { return SDJSON ( value: $0 ) } }
    
    /// A Dictionary of `SDJSON` objects.
    ///
    private var dictionary: [ String: SDJSON ]? { return ( value as? [ String: Any ] )? .mapValues { return SDJSON ( value: $0 ) } }
        
    /// Creates a `SDJSON` object from a string.
    ///
    public init ( _ input: String ) { value = try? JSONSerialization.jsonObject ( with: Data ( input.utf8 ) ) }
    
    /// Creates a `SDJSON` object from a `SDJSON` object value.
    ///
    private init ( value: Any? ) { self.value = value }
        
    /// Subscript support for `SDJSON` arrays.
    ///
    public subscript ( index: Int ) -> SDJSON { return array? [ index ] ?? SDJSON ( value: nil ) }
    
    /// Subscript support for `SDJSON` dictionaries.
    ///
    public subscript ( key: String ) -> SDJSON { return dictionary? [ key ] ?? SDJSON ( value: nil ) }
    
    /// Dynamic member lookup support for `SDJSON` dictionaries.
    ///
    public subscript ( dynamicMember key: String ) -> SDJSON { return dictionary? [ key ] ?? SDJSON ( value: nil ) }
    
    /// Returns the value of the `SDJSON` object.
    ///
    public func parse ( ) -> Any? { return value }

}

//
//
