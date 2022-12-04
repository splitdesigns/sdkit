
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
	private let direction: UnitPoint
	
	/// The position of the marquee.
	///
	private var phase: CGFloat?
	
	/// The animation curve for the marquee.
	///
	private var timingCurve: Animation?
	
	/// The content to tile.
	///
	private let content: ( ) -> Content
	
	/// The animation for the marquee.
	///
	@State private var animation: CGFloat = .init ( )
	
	/// Offsets for each of the marquee tile segments.
	///
	private var segments: [ [ CGFloat ] ] { return Array < UnitPoint > ( arrayLiteral: .trailing, .leading ) .contains ( self.direction ) ? [ [ -1.0, 0.0 ], [ 0.0, 0.0 ] ] : Array < UnitPoint > ( arrayLiteral: .top, .bottom ) .contains ( self.direction ) ? [ [ 0.0, -1.0 ], [ 0.0, 0.0 ] ] : exponentiate ( [ -1.0, 0.0 ], items: 2 ) ?? .init ( ) }
	
	/// The view content of the marquee.
	///
	public var body: some View {
		
		ZStack {
			
			GeometryReader { proxy in
				
				ForEach ( 0 ..< self.segments.count, id: \ .self ) { index in
					
					self.content ( )
						.offset (
							
							x: ( ( self.phase ?? self.animation ) + self.segments [ index ] [ 0 ] ) * proxy.size.width * self.direction.x.lerp ( in: -1.0 ... 1.0 ),
							y: ( ( self.phase ?? self.animation ) + self.segments [ index ] [ 1 ] ) * proxy.size.height * self.direction.y.lerp ( in: -1.0 ... 1.0 )
							
						)
					
				}
				.clipped ( )
				
			}
			
		}
		.onAppear { withAnimation ( self.timingCurve ?? .linear ( duration: 16.0 ) .repeatForever ( autoreverses: false ) ) { self.animation = 1.0 } }
		
	}
	
	/// Creates a ``SDMarquee`` from a movement direction, animation, and some content.
	///
	/// - Parameters:
	///   - direction: The direction of the marquee movement.
	///   - phase: The position of the marquee.
	///   - animation: The animation curve for the marquee.
	///   - content: The content to tile.
	///
	public init ( direction: UnitPoint = .trailing, phase: CGFloat? = nil, animation timingCurve: Animation? = nil, @ViewBuilder content: @escaping () -> Content ) {
		
		self.direction = direction
		self.phase = phase
		self.timingCurve = timingCurve
		self.content = content
		
	}
	
}

//
//
