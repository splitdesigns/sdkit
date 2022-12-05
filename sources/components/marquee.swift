
//
//  SDKit: Marquee
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Seamlessly tiles content in the specified direction.
///
@available ( iOS 16.0, * )
public struct SDMarquee < Content: View > : View {
	
	/// The point to move towards.
	///
	private let position: UnitPoint
	
	/// The position of the marquee.
	///
	private var phase: CGFloat
	
	/// The content to tile.
	///
	private let content: ( ) -> Content
	
	/// The bounds of the content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// Offsets for each of the marquee tile segments.
	///
	private var segments: [ [ CGFloat ] ] { return Array < UnitPoint > ( arrayLiteral: .trailing, .leading ) .contains ( self.position ) ? [ [ -1.0, 0.0 ], [ 0.0, 0.0 ] ] : Array < UnitPoint > ( arrayLiteral: .top, .bottom ) .contains ( self.position ) ? [ [ 0.0, -1.0 ], [ 0.0, 0.0 ] ] : exponentiate ( [ -1.0, 0.0 ], items: 2 ) ?? .init ( ) }
	
	/// The view content of the marquee.
	///
	public var body: some View {
		
		ZStack {
				
			ForEach ( 0 ..< self.segments.count, id: \ .self ) { index in
				
				self.content ( )
					.offset (
						
						x: ( self.phase.truncatingRemainder ( dividingBy: 1.0 ) + self.segments [ index ] [ 0 ] ) * bounds.width * self.position.x.lerp ( in: -1.0 ... 1.0 ),
						y: ( self.phase.truncatingRemainder ( dividingBy: 1.0 ) + self.segments [ index ] [ 1 ] ) * bounds.height * self.position.y.lerp ( in: -1.0 ... 1.0 )
						
					)
				
			}
			.clipped ( )
			.exportBounds ( to: $bounds )
			
		}
		
	}
	
	/// Creates a ``SDMarquee`` from a movement direction, animation, and some content.
	///
	/// - Parameters:
	///   - position: The point to move towards.
	///   - phase: The position of the marquee.
	///   - content: The content to tile.
	///
	public init ( position: UnitPoint = .trailing, phase: CGFloat = 0.0, @ViewBuilder content: @escaping () -> Content ) {
		
		self.position = position
		self.phase = phase
		self.content = content
		
	}
	
}

//
//
