//
////
////  SDKit: Reflection
////  Developed by SPLIT Designs
////
//
////  MARK: - Imports
//
//import Foundation
//
////
////
//
////  MARK: - Functions
//
///// Traverses all properties of a specified type, performing an action closure for each that accepts the label, value, and the depth of the recursion.
/////
///// - Parameters:
/////   - object: The object to traverse.
/////   - recursively: Whether or not to traverse nested objects.
/////   - performing: The action to perform for each property. The target property type is inferred from the value parameter type.
/////
//@available ( iOS 16.0, * )
//public func traverse < Object, Property, Nothing > ( _ object: Object, recursively recurse: Bool = true, performing action: @escaping ( _ label: String?, _ value: Property, _ depth: Int ) -> Nothing = { ( label, value: Any, depth ) in print ( "\( String ( [ String ] .init ( repeating: "  ", count: depth ) .reduce ( " -", + ) .reversed ( ) ) )\( ( label ?? "" ) + ( label != nil ? " : " : "" ) )\( value )" ) } ) -> Void {
//	
//	///	A nested copy of the ``traverse(_:recursively:performing:)`` function, with a parameter for tracking depth.
//	///
//	///	- Parameter at: The depth of the recursion.
//	///
//	func recursivelyTraverse < Object, Property, Nothing > ( _ object: Object, recursively recursive: Bool, performing action: @escaping ( _ label: String?, _ value: Property, _ depth: Int ) -> Nothing, at depth: Int = .init ( ) ) -> Void {
//		
//		//	Create a reflection and map over the children, filtering out values that don't conform
//		
//		Mirror ( reflecting: object ) .children.filter { $0.value is Property } .forEach { child in
//			
//			//	Destructure and typecast the element based on the object's type
//			
//			let ( key, value ) = ( object.self is [ String?: Any ] ? child.value : child ) as! ( String?, Property )
//			
//			//	Pass the child's label and value into the closure, traversing nested objects if specified
//			
//			_ = action ( key, value, depth )
//			if recurse { recursivelyTraverse ( child.value, recursively: recursive, performing: action, at: depth + 1 ) }
//			
//		}
//		
//	}
//	
//	//	Start the recursion
//	
//	return recursivelyTraverse ( object, recursively: recurse, performing: action )
//	
//}
//
///// Traverses all properties of a specified type, transforming each with a closure that accepts the label, value, and the depth of the recursion, and returns a dictionary representing the hierarchy.
/////
///// - Parameters:
/////   - object: The object to destructure.
/////   - recursively: Whether or not to destructure nested objects.
/////   - using: The closure used to transform each property. The target property type is inferred from the value parameter type.
/////
//@available ( iOS 16.0, * )
//public func destructure < Object, Property, Key: Hashable, Value > ( _ object: Object, recursively recurse: Bool = true, using transform: @escaping ( _ label: String?, _ value: Property, _ depth: Int ) -> ( key: Key?, value: Value ) = { ( label, value: Any, depth ) in return ( label, value ) } ) -> Any {
//	
//	///	A nested copy of the ``destructure(_:recursively:using:)`` function, with a parameter for tracking depth.
//	///
//	///	- Parameter at: The depth of the recursion.
//	///
//	func recursivelyDestructure < Object, Property, Key: Hashable, Value > ( _ object: Object, recursively recurse: Bool, using transform: @escaping ( _ label: String?, _ value: Property, _ depth: Int ) -> ( key: Key?, value: Value ), at depth: Int = .init ( ) ) -> Any {
//		
//		//	Reflect and filter the value's properties
//		
//		let filtered: [ Mirror.Child ] = Mirror ( reflecting: object ) .children.filter { $0.value is Property }
//		
//		//	Define a function to transform and recursively reflect nested values
//		
//		let mutate: ( _ element: Mirror.Child, _ transform: ( _ label: String?, _ value: Property, _ depth: Int ) -> ( key: Key?, value: Value ) ) -> ( key: Key?, value: Any ) = {
//			
//			//	Destructure and typecast the element based on the object's type
//			
//			var ( key, value ) = ( object.self is [ Key: Any ] ? $0.value : $0 ) as! ( Key?, Any )
//			
//			//	Apply a transform and recursively reflect the value if specified
//			
//			( key, value ) = $1 ( key as! String?, value as! Property, depth )
//			if recurse { value = recursivelyDestructure ( value, recursively: recurse, using: transform, at: depth + 1 ) }
//			
//			//	Return the key value pair
//			
//			return ( key, value )
//			
//		}
//		
//		//	Switch over the type of the object
//		
//		switch object.self {
//				
//				//	Check if the object is an array
//				
//			case is [ Any ]:
//				
//				//	Map over the filtered properties
//				
//				let result: [ Any ] = filtered.map {
//					
//					//	Mutate the element and discard the key
//					
//					let ( _, value ) = mutate ( $0, transform )
//					
//					//	Return the value
//					
//					return ( value )
//					
//				}
//				
//				//	If the result contains any elements, return the array, otherwise return the object
//				
//				if !result.isEmpty { return result } else { return object }
//				
//				//	Will be run if the object is a dictionary or any other type
//				
//			default:
//				
//				//	Map over the filtered properties
//				
//				let result: [ Key: Any ] = filtered.map {
//					
//					//	Mutate the element
//					
//					let ( key, value ) = mutate ( $0, transform )
//					
//					//	Return the force-unwrapped key and value
//					
//					return ( key ?? $0.label as! Key, value )
//					
//					//	Reduce the array of tuples into a dictionary
//					
//				} .reduce ( into: [ Key: Any ] .init ( ) ) { ( dictionary, element: ( key: Key, value: Any ) ) in dictionary [ element.key ] = element.value }
//				
//				//	If the result contains any elements, return the dictionary, otherwise return the object
//				
//				if !result.isEmpty { return result } else { return object }
//				
//		}
//		
//	}
//	
//	//	Start the recursion
//	
//	return recursivelyDestructure ( object, recursively: recurse, using: transform )
//	
//}
//
////
////
