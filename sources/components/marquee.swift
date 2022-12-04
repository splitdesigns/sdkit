
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
	
	/// The direction of the marquee movement.
	///
	private let progression: UnitPoint
	
	/// The animation for the marquee movement.
	///
	private let animation: Animation?
	
	/// The content to tile.
	///
	private let content: ( ) -> Content
	
	/// The position of the marquee movement.
	///
	@State private var phase: CGFloat = .init ( )
	
	/// Offsets for each of the marquee tile segments.
	///
	private var segments: [ [ CGFloat ] ] { return Array < UnitPoint > ( arrayLiteral: .trailing, .leading ) .contains ( self.progression ) ? [ [ -1.0, 0.0 ], [ 0.0, 0.0 ] ] : Array < UnitPoint > ( arrayLiteral: .top, .bottom ) .contains ( self.progression ) ? [ [ 0.0, -1.0 ], [ 0.0, 0.0 ] ] : exponentiate ( [ -1.0, 0.0 ], items: 2 ) ?? .init ( ) }
	
	/// The view content of the marquee.
	///
	public var body: some View {
		
		ZStack {
			
			GeometryReader { proxy in
				
				ForEach ( 0 ..< self.segments.count, id: \ .self ) { index in
					
					self.content ( )
						.offset (
							
							x: ( self.phase + self.segments [ index ] [ 0 ] ) * proxy.size.width * progression.x.lerp ( in: -1.0 ... 1.0 ),
							y: ( self.phase + self.segments [ index ] [ 1 ] ) * proxy.size.height * progression.y.lerp ( in: -1.0 ... 1.0 )
							
						)
					
				}
				.clipped ( )
				
			}
			
		}
		.onAppear { withAnimation ( self.animation ?? .linear ( duration: 4.0 ) .repeatForever ( autoreverses: false ) ) { self.phase = 1.0 } }
		
	}
	
	/// Creates a ``SDMarquee`` from a movement direction, animation, and some content.
	///
	/// - Parameters:
	///   - progression: The direction of the marquee movement.
	///   - animation: The animation for the marquee movement.
	///   - content: The content to tile.
	///
	public init ( progression: UnitPoint = .trailing, animation: Animation? = nil, @ViewBuilder content: @escaping () -> Content ) {
		
		self.progression = progression
		self.animation = animation
		self.content = content
		
	}
	
}

//
//
