
//
//  SDKit: JSON Parser Tests
//  Developed by SPLIT Designs
//

//  MARK: - Imports

@testable import SDKit
import XCTest

//
//

//  MARK: - Classes

/// A class for testing the `SDJSON` struct.
///
@available ( iOS 16.0, * )
final private class SDJSONTests: XCTestCase {
    
    /// A test for the `SDJSON` documentation code example.
    ///
    private func testDocumentationExample ( ) throws -> Void {
        
        //  Initialize SDJSON from JSON string
        
        let combinations: String = "[ { \"luggage\": \"1234\" } ]"
        let json: SDJSON = .init ( combinations )
        
        //  Access, typecast, and unwrap
        
        let value: Any? = json [ 0 ] .luggage.parse ( )
        let result: String = value as? String ?? "unknown"
        
        //  Test for match
        
        XCTAssertEqual ( result, "1234" )
                
    }
    
    /// A test for initializing a corrupted JSON string.
    ///
    private func testCorruptedInput ( ) throws -> Void {
        
        //  Create JSON string
        
        let corrupted: String = """
        
        [ { "corrupted": true "commas": matter } ]
        
        """
        
        //  Initialize SDJSON
        
        let json: SDJSON = .init ( corrupted )
        
        //  Assert nil
        
        XCTAssertNil ( json.parse ( ) )
        
        //  Access, typecast, and unwrap
        
        let verify: Bool = json [ 0 ] .corrupted.parse ( ) as? Bool ?? false
        
        //  Test for match
        
        XCTAssertEqual ( verify, false )
                
    }
    
    /// A test for querying collections.
    ///
    private func testCollectionQuery ( ) throws -> Void {
        
        //  Create JSON string
        
        let users: String = """
        
        [
        
            { "name": "bob", "friends": [ "bill", "tim" ] },
            { "name": "bill", "friends": [ "tim", "bob" ] },
            { "name": "tim", "friends": [ "bob", "bill" ] }
        
        ]
        
        """
        
        //  Initialize, access, typecast correctly, and unwrap
        
        let accessCorrectly: String = SDJSON ( users ) [ 2 ] .friends [ 1 ] .parse ( ) as? String ?? "unknown"
        let accessArrayAsDict: String = SDJSON ( users ) [ 2 ] .friends.bill.parse ( ) as? String ?? "unknown"
        let accessDictAsArray: String = SDJSON ( users ) [ 2 ] [ 1 ] [ 1 ] .parse ( ) as? String ?? "unknown"
        
        //  Test for match
        
        XCTAssertEqual ( accessCorrectly, "bill" )
        XCTAssertEqual ( accessArrayAsDict, "unknown" )
        XCTAssertEqual ( accessDictAsArray, "unknown" )
        
    }
    
    /// A test for typecasting parsed common data types.
    ///
    private func testPrimitiveTypecasts ( ) throws -> Void {
        
        //  Create JSON string
        
        let primitives: String = """
        
        [ { "bool": true, "double": 64.0, "int": 32, "string": "Hello, world!" } ]
        
        """
        
        //  Initialize, access, typecast correctly, and unwrap
        
        var bool: Bool = SDJSON ( primitives ) [ 0 ] .bool.parse ( ) as? Bool ?? false
        var double: Double = SDJSON ( primitives ) [ 0 ] .double.parse ( ) as? Double ?? 0.0
        var int: Int = SDJSON ( primitives ) [ 0 ] .int.parse ( ) as? Int ?? 0
        var string: String = SDJSON ( primitives ) [ 0 ] .string.parse ( ) as? String ?? "Goodbye, world!"
        
        //  Test for match
        
        XCTAssertEqual ( bool, true )
        XCTAssertEqual ( double, 64.0 )
        XCTAssertEqual ( int, 32 )
        XCTAssertEqual ( string, "Hello, world!" )
        
        //  Initialize, access, typecast incorrectly, and unwrap
        
        bool = SDJSON ( primitives ) [ 0 ] .int.parse ( ) as? Bool ?? false
        double = SDJSON ( primitives ) [ 0 ] .string.parse ( ) as? Double ?? 0.0
        int = SDJSON ( primitives ) [ 0 ] .string.parse ( ) as? Int ?? 0
        string = SDJSON ( primitives ) [ 0 ] .bool.parse ( ) as? String ?? "Goodbye, world!"
        
        //  Test for match
        
        XCTAssertEqual ( bool, false )
        XCTAssertEqual ( double, 0.0 )
        XCTAssertEqual ( int, 0 )
        XCTAssertEqual ( string, "Goodbye, world!" )
                
    }
    
}

//
//
