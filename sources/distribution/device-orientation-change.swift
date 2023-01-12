
//
//  SDKit: Device Orientation Change
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Performs an action when the device's orientation changes.
///
@available ( iOS 16.0, * )
public struct SDOnDeviceOrientationChange: ViewModifier {
	
	/// The action to perform when the orientation changes.
	///
	private let action: ( _ deviceOrientation: UIDeviceOrientation, _ interfaceOrientation: UIInterfaceOrientation ) -> Void
	
	/// Performs an action when the device's orientation changes.
	///
	public func body ( content: Content ) -> some View { content.onReceive ( NotificationCenter.default.publisher ( for: UIDevice.orientationDidChangeNotification ) ) { _ in action ( UIDevice.current.orientation, UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown ) } }
	
	/// Creates an ``SDOnDeviceOrientationChange`` instance from an action to perform.
	///
	/// - Parameter perform: The action to perform.
	///
	public init ( perform action: @escaping ( _ deviceOrientation: UIDeviceOrientation, _ interfaceOrientation: UIInterfaceOrientation ) -> Void ) { self.action = action }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Performs an action when the device's orientation changes.
	///
	/// - Parameter perform: The action to perform.
	///
	func onDeviceOrientationChange ( perform action: @escaping ( _ deviceOrientation: UIDeviceOrientation, _ interfaceOrientation: UIInterfaceOrientation ) -> Void ) -> some View { self.modifier ( SDOnDeviceOrientationChange ( perform: action ) ) }
	
}

//
//
