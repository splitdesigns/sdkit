
//
//  SDKit: Marquee
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Seamlessly moves content in the specified direction.
///
@available ( iOS 16.0, * )
public struct SDMarquee < Content: View > : View {
	
	/// The direction of the marquee movement.
	///
	private let direction: UnitPoint
	
	/// The position of the marquee movement.
	///
	private var phase: CGFloat
	
	/// The content to move.
	///
	private let content: ( ) -> Content
	
	/// The bounds of the content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// Offsets for the marquee segments.
	///
	private var segments: [ [ CGFloat ] ] { return self.direction.x == 0.5 ? [ [ 0.0, -1.0 ], [ 0.0, 0.0 ] ] : self.direction.y == 0.5 ? [ [ -1.0, 0.0 ], [ 0.0, 0.0 ] ] : exponentiate ( [ -1.0, 0.0 ], count: 2 ) ?? .init ( ) }
	
	/// Offsets multiple content instances to create a tiled arrangement, then offsets the tiled content in the specified direction a distance relative to the phase, clipping the result to the original frame.
	///
	public var body: some View {
		
		ZStack {
				
			ForEach ( 0 ..< self.segments.count, id: \ .self ) { index in
				
				self.content ( )
					.offset (
						
						x: ( self.phase.truncatingRemainder ( dividingBy: 1.0 ) + self.segments [ index ] [ 0 ] ) * bounds.width * self.direction.x.lerp ( in: -1.0 ... 1.0 ),
						y: ( self.phase.truncatingRemainder ( dividingBy: 1.0 ) + self.segments [ index ] [ 1 ] ) * bounds.height * self.direction.y.lerp ( in: -1.0 ... 1.0 )
						
					)
				
			}
			.clipped ( )
			.exportBounds ( to: $bounds )
			
		}
		
	}
	
	/// Creates an ``SDMarquee`` instance from a movement direction, movement position, and some content.
	///
	/// - Parameters:
	///   - direction: The direction of the marquee movement.
	///   - phase: The position of the marquee movement.
	///   - content: The content to move.
	///
	public init ( direction: UnitPoint = .trailing, phase: CGFloat = .zero, @ViewBuilder content: @escaping ( ) -> Content ) {
		
		self.direction = direction
		self.phase = phase
		self.content = content
		
	}
	
}

//
//
