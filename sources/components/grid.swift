
//
//  SDKit: Grid
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Creates a two-dimensional grid of views.
///
@available ( iOS 16.0, * )
public struct SDGrid < Content: View > : View {
	
	/// The number of rows in the grid.
	///
	private let rows: Int
	
	/// The number of columns in the grid.
	///
	private let columns: Int
	
	/// The vertical and horizontal grid spacing to apply.
	///
	private let spacing: ( horizontal: CGFloat, vertical: CGFloat )
	
	/// The content to create a grid from.
	///
	private let content: ( Int, Int ) -> Content
	
	/// The view content of the grid.
	///
	public var body: some View {
		
		SDYStack ( spacing: spacing.vertical ) { ForEach ( 0 ..< rows, id: \ .self ) { row in
			
			SDXStack ( spacing: spacing.horizontal ) { ForEach ( 0 ..< columns, id: \ .self ) { column in
				
				content ( row, column )
				
			} }
			
		} }
		
	}
	
	/// Creates a ``SDGrid`` from a rows, columns, and a spacing value and some content.
	///
	/// - Parameter rows: The number of rows in the grid.
	/// - Parameter columns: The number of columns in the grid.
	/// - Parameter spacing: The vertical and horizontal grid spacing to apply.
	/// - Parameter content: The content to create a grid from.
	///
	public init ( rows: Int = 3, columns: Int = 3, spacing: ( horizontal: CGFloat, vertical: CGFloat ) = ( 0, 0 ), @ViewBuilder content: @escaping ( Int, Int ) -> Content ) {
		
		self.rows = rows
		self.columns = columns
		self.spacing = spacing
		self.content = content
		
	}
	
}

//
//

