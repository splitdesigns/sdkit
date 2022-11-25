
//
//  SDKit: Foreground
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Sets the foreground of a view.
///
@available ( iOS 16.0, * )
public struct SDForeground < OverlayContent: View > : ViewModifier {
	
	/// The content to overlay.
	///
	private let overlayContent: ( ) -> OverlayContent
	
	/// Applies an overlay and a mask to the modified view.
	///
	public func body ( content: Content ) -> some View { content.foregroundColor ( .clear ) .overlay { self.overlayContent ( ) .mask ( content ) .allowsHitTesting ( false ) } }
	
	/// Creates a ``SDForeground`` from some overlay content.
	///
	/// - Parameter content: The content to set as the foreground.
	///
	public init ( content: @escaping @autoclosure ( ) -> OverlayContent ) { self.overlayContent = content }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Sets the foreground of a view.
	///
	/// - Parameter content: The content to set as the foreground.
	///
	func foreground < OverlayContent: View > ( _ content: @escaping @autoclosure ( ) -> OverlayContent ) -> some View { self.modifier ( SDForeground < OverlayContent > ( content: content ( ) ) ) }
	
}

//
//
