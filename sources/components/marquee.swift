
//
//  SDKit: Marquee
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Seamlessly tiles content in the direction you specify.
///
@available ( iOS 16.0, * )
public struct SDMarquee < Content: View > : View {
	
	/// The view dimension to reference as a complete phase cycle.
	///
	public enum SDPhaseReference: String { case width, height }
	
	/// The angle of the marquee movement.
	///
	private let angle: CGFloat
	
	/// The position of the marquee.
	///
	private let phase: CGFloat
	
	/// The dimension to reference as a complete phase cycle.
	///
	private let reference: SDPhaseReference
	
	/// The content to tile.
	///
	private let content: ( ) -> Content
	
	/// The bounds of the content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// The amount to displace the content horizontally.
	///
	private var displacementX: CGFloat { return ( phase * cos ( angle * .pi / 180.0 ) * ( reference == .width ? bounds.width : bounds.height ) ) .truncatingRemainder ( dividingBy: bounds.width ) }
	
	/// The amount to displace the content vertically.
	///
	private var displacementY: CGFloat { return ( phase * sin ( angle * .pi / 180.0 ) * ( reference == .width ? bounds.width : bounds.height ) ) .truncatingRemainder ( dividingBy: bounds.height ) }
	
	/// Offsets for each of the marquee segments.
	///
	private let segments: [ [ CGFloat ] ] = exponentiate ( [ -1, 0 ], items: 2 ) ?? .init ( )
	
	/// The view content of the marquee.
	///
	public var body: some View {
		
		ZStack {
			
			//	View optimization through relocating geometry reader
			
			content ( )
				.exportBounds ( to: $bounds )
				.hidden ( )
			
			ForEach ( 0 ..< segments.count, id: \ .self ) { index in
				
				//	View optimization through hiding non-visible views
				
				if displacementX + segments [ index ] [ 0 ] * bounds.width <= bounds.width || displacementX + segments [ index ] [ 0 ] * bounds.width >= -bounds.width && displacementY + segments [ index ] [ 1 ] * bounds.height <= bounds.height || displacementY + segments [ index ] [ 1 ] * bounds.height >= -bounds.height {
					
					content ( )
						.offset ( x: displacementX.wrapped ( in: 0.0 ..< bounds.width ) + segments [ index ] [ 0 ] * bounds.width, y: displacementY.wrapped ( in: 0.0 ..< bounds.height ) + segments [ index ] [ 1 ] * bounds.height )
					
				}
				
			}
			.clipped ( )
			
		}
		
	}
	
	/// Creates a ``SDMarquee`` from an angle, phase, phase reference, and some content.
	///
	/// - Parameter angle: The angle of the marquee movement.
	/// - Parameter phase: The position of the marquee.
	/// - Parameter reference: The view dimension to reference as a complete phase cycle.
	/// - Parameter content: The content to tile.
	///
	public init ( angle: CGFloat = 0.0, phase: CGFloat = 0.0, reference: SDPhaseReference = .width, @ViewBuilder content: @escaping () -> Content ) {
		
		self.angle = angle
		self.phase = phase
		self.reference = reference
		self.content = content
		
	}
	
}

//
//
