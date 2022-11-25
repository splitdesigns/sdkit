
//
//  SDKit: Export Bounds
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Exports the width and height of the view to a `CGSize` binding.
///
@available ( iOS 16.0, * )
public struct SDExportBounds: ViewModifier {
	
	/// The coordinate space to fetch bounds from.
	///
	private let coordinateSpace: CoordinateSpace
	
	/// The bounds to export.
	///
	@Binding public private ( set ) var bounds: CGRect
	
	/// Applies an overlay with a geometry reader to get the dimensions of the view.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.overlay ( GeometryReader { proxy in
				
				SDNothing ( )
					.frame ( maxWidth: .infinity, maxHeight: .infinity )
					.task ( id: proxy.frame ( in: self.coordinateSpace ) ) { self.bounds = proxy.frame ( in: self.coordinateSpace ) }
				
			} )
		
	}
	
	/// Creates a ``SDExportBounds`` from a binding.
	///
	/// - Parameters:
	///   - from: The coordinate space to fetch bounds from.
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
	
	/// Exports the width and height of the view to a `CGSize` binding.
	///
	/// - Parameters:
	///   - from: The coordinate space to fetch bounds from.
	///   - to: The bounds to export.
	///
	func exportBounds ( from coordinateSpace: CoordinateSpace = .global, to bounds: Binding < CGRect > ) -> some View { self.modifier ( SDExportBounds ( from: coordinateSpace, to: bounds ) ) }
	
}

//
//
