//
////
////  SDKit: Safe Area Insets
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
////  MARK: - Structures
//
///// An environment key for the safe area inset values.
/////
//@available ( iOS 16.0, * )
//private struct SDSafeAreaInsetsKey: EnvironmentKey {
//	
//	/// A default value for the `safeAreaInsets` environment key.
//	///
//	fileprivate static var defaultValue: EdgeInsets { return UIWindow ( windowScene: UIApplication.shared.connectedScenes.first as! UIWindowScene ) .safeAreaInsets.insets }
//	
//}
//
////
////
//
////  MARK: - Extensions
//
//@available ( iOS 16.0, * )
//private extension UIEdgeInsets {
//	
//	/// The safe area inset values.
//	///
//	var insets: EdgeInsets { return .init ( top: top, leading: left, bottom: bottom, trailing: right ) }
//}
//
//@available ( iOS 16.0, * )
//public extension EnvironmentValues {
//	
//	///	An environment value for the safe area inset values.
//	///
//	var safeAreaInsets: EdgeInsets {
//		
//		get { return self [ SDSafeAreaInsetsKey.self ] }
//		set { return self [ SDSafeAreaInsetsKey.self ] = newValue }
//		
//	}
//	
//}
//
////
////
