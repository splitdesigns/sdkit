
//
//  SDKit: Backdrop
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Classes

/// Creates a `UIView` from a `CABackdropLayer`.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
final public class SDUIBackdrop: UIView {

	/// The selector to call from Objective-C.
	///
	private static let selector: String = { [ "Layer", "Backdrop", "CA" ] .reversed ( ) .joined ( ) } ( )

	/// Gets the `CABackdropLayer` class.
	///
	override public class var layerClass: AnyClass { NSClassFromString ( self.selector ) ?? CALayer.self }
	
}

//
//

//  MARK: - Structures

/// A `CABackdropLayer` wrapper that captures the content behind it.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDBackdrop: UIViewRepresentable {

	/// Creates the UI view.
	///
	public func makeUIView ( context: Context ) -> SDUIBackdrop { SDUIBackdrop ( ) }

	/// Updates the UI view.
	///
	public func updateUIView ( _ uiView: SDUIBackdrop, context: Context ) { }
	
	/// Creates an ``SDBackdrop`` instance.
	///
	public init ( ) { }

}

//
//
