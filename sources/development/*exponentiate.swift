//
////
////  SDKit: Exponentiate
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
////  MARK: - Functions
//
///// Generates every possible combination for a sequence of values.
/////
///// - Parameters:
/////   - source: A sequence of values to exponentiate.
/////   - items: The number of items in each set.
/////
//@available ( iOS 16.0, * )
//public func exponentiate < Item: Any > ( _ source: [ Item ], items: Int ) -> [ [ Item ] ]? {
//	
//	//	Determine the number of sets from the number of items in source exponentiated by `items`
//	
//	let sets: Int = .init ( pow ( CGFloat ( source.count ), CGFloat ( items ) ) )
//	
//	//	Map over the number of sets
//	
//	let result: [ [ Any ] ] = Array ( 0 ..< sets ) .map { `set` in
//		
//		//	Map over the number of items
//		
//		return Array ( 0 ..< items ) .map { item in
//			
//			//  Divide and floor the row index ( set ) by the number of items in source exponentiated by the column index ( item ), then limit by the number of items in source, and return the remainder
//			
//			return source [ `set` / Int ( pow ( CGFloat ( source.count ), CGFloat ( item ) ) ) % source.count ]
//			
//		}
//		
//	}
//	
//	//	Check for indices and return `nil` if a level is inaccessible
//	
//	return result.indices.contains ( 0 ) && result [ 0 ] .indices.contains ( 0 ) ? ( result as! [ [ Item ] ] ) : nil
//	
//}
//
////
////
