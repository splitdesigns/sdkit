
//
//  SDKit: Foreground
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Sets the foreground of a view to some content.
///
@available ( iOS 16.0, * )
public struct SDForeground < OverlayContent: View > : ViewModifier {
	
	/// The content to set as the foreground.
	///
	private let content: ( ) -> OverlayContent
	
	/// Applies a masked overlay to the modified view.
	///
	public func body ( content: Content ) -> some View { content.foregroundColor ( .clear ) .overlay { self.content ( ) .mask ( content ) .allowsHitTesting ( false ) } }
	
	/// Creates an ``SDForeground`` instance from some content.
	///
	/// - Parameter content: The content to set as the foreground.
	///
	public init ( _ content: @escaping ( ) -> OverlayContent ) { self.content = content }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Sets the foreground of a view to some content.
	///
	/// - Parameter content: The content to set as the foreground.
	///
	func foreground < OverlayContent: View > ( _ content: @escaping @autoclosure ( ) -> OverlayContent ) -> some View { return self.modifier ( SDForeground < OverlayContent > ( content ) ) }
	
}

//
//
