
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
	
	/// The number of rows for the grid.
	///
	private let rows: Int
	
	/// The number of columns for the grid.
	///
	private let columns: Int
	
	/// The vertical and horizontal grid spacing to apply.
	///
	private let spacing: ( horizontal: CGFloat, vertical: CGFloat )
	
	/// The content to create a grid from.
	///
	private let content: ( Int, Int ) -> Content
	
	/// Repeats the content on the horizontal and vertical axis.
	///
	public var body: some View {
		
		SDYStack ( spacing: self.spacing.vertical ) { ForEach ( 0 ..< self.rows, id: \ .self ) { row in
			
			SDXStack ( spacing: self.spacing.horizontal ) { ForEach ( 0 ..< self.columns, id: \ .self ) { column in
				
				self.content ( row, column )
				
			} }
			
		} }
		
	}
	
	/// Creates a ``SDGrid`` from a row count, column count, horizontal and vertical spacing values, and some content.
	///
	/// - Parameters:
	///   - rows: The number of rows for the grid.
	///   - columns: The number of columns for the grid.
	///   - spacing: The vertical and horizontal grid spacing to apply.
	///   - content: The content to create a grid from.
	///
	public init ( rows: Int = 3, columns: Int = 3, spacing: ( horizontal: CGFloat, vertical: CGFloat ) = ( .zero, .zero ), @ViewBuilder content: @escaping ( Int, Int ) -> Content ) {
		
		self.rows = rows
		self.columns = columns
		self.spacing = spacing
		self.content = content
		
	}
	
}

//
//

