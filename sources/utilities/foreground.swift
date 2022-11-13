
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
	/// - Parameter content: The content to modify.
	///
	public func body ( content: Content ) -> some View { content.foregroundColor ( .clear ) .overlay { overlayContent ( ) .mask ( content ) .allowsHitTesting ( false ) } }
	
	/// Creates a ``SDForeground`` from some overlay content.
	///
	/// - Parameter content: The content to set as the foreground.
	///
	public init ( content: @escaping () -> OverlayContent ) { self.overlayContent = content }
	
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
	func foreground < OverlayContent: View > ( @ViewBuilder _ content: @escaping ( ) -> OverlayContent ) -> some View { modifier ( SDForeground < OverlayContent > ( content: content ) ) }
	
}

//
//
