
//
//  SDKit: Export Bounds
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Calculates the bounds of a view.
///
///	To use, export the bounds to a `CGRect`.
///
/// 	@State private var bounds: CGRect = .init ( )
///
/// 	...
///
/// 	Text ( "Hello, world!" )
/// 		.exportBounds ( to: self.$bounds )
/// 		.onUpdate ( of: self.bounds ) { print ( $0.size ) }
///
@available ( iOS 16.0, * )
public struct SDExportBounds: ViewModifier {
	
	/// The coordinate space to calculate the bounds in.
	///
	private let coordinateSpace: CoordinateSpace
	
	/// The bounds to export.
	///
	@Binding public private ( set ) var bounds: CGRect
	
	/// Applies an overlay with a geometry reader that calculates the dimensions of the view.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.overlay ( GeometryReader { proxy in
				
				SDNothing ( )
					.frame ( maxWidth: .infinity, maxHeight: .infinity )
					.onUpdate ( of: proxy.frame ( in: self.coordinateSpace ) ) { self.bounds = $0 }

			} )
		
	}
	
	/// Creates an ``SDExportBounds`` instance from a coordinate space and a binding.
	///
	/// - Parameters:
	///   - from: The coordinate space to calculate the bounds in.
	///   - to: The bounds to export.
	///
	public init ( from coordinateSpace: CoordinateSpace = .local, to bounds: Binding < CGRect > ) {
		
		self.coordinateSpace = coordinateSpace
		self._bounds = bounds
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Calculates the bounds of a view. See ``SDExportBounds`` for more info.
	///
	/// - Parameters:
	///   - from: The coordinate space to calculate the bounds in.
	///   - to: The bounds to export.
	///
	func exportBounds ( from coordinateSpace: CoordinateSpace = .global, to bounds: Binding < CGRect > ) -> some View { self.modifier ( SDExportBounds ( from: coordinateSpace, to: bounds ) ) }
	
}

//
//
