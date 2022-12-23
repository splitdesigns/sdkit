
//
//  SDKit: Bound To Container
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Frames the content of a view to the bounds of it's container.
///
///	Useful for instances where the child does not respect the bounds of it's parent.
///
///	If you want to use an image to fill a container and none of the superviews have a fixed size, the image will not just overflow the container, but extend the bounds of the container beyond the edges of the screen.
///
///	To fix this behaviour, add the ``SDBoundToContainer`` modifier after scaling the image to fill. ``SDBoundToContainer`` uses a geometry reader to calculate the bounds of the container, and explicitly frames the content to those bounds.
///
/// 	Image ( "test" )
/// 		.resizable ( )
/// 		.scaledToFill ( )
/// 		.boundToContainer ( )
/// 		.clipped ( )
///
@available ( iOS 16.0, * )
public struct SDBoundToContainer: ViewModifier {
	
	///	The bounds of the container.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// Uses a geometry reader to calculate the bounds of the container, and explicitly frames the content to those bounds.
	///
	public func body ( content: Content ) -> some View {
		
		SDNothing ( expand: true )
			.exportBounds ( to: self.$bounds )
			.overlay { content.frame ( width: self.bounds.size.width, height: self.bounds.size.height ) }
		
	}
	
	/// Creates an ``SDBoundToContainer`` instance.
	///
	public init (  ) { }
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Frames the content of a view to the bounds of it's container. See ``SDBoundToContainer`` for more info.
	///
	func boundToContainer ( ) -> some View { self.modifier ( SDBoundToContainer ( ) ) }
	
}

//
//
