
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
	public enum PhaseReference: String { case width, height }
	
	/// The angle of the marquee movement.
	///
	private let angle: CGFloat
	
	/// The position of the marquee.
	///
	private let phase: CGFloat
	
	/// The dimension to reference as a complete phase cycle.
	///
	private let reference: Self.PhaseReference
	
	/// The content to tile.
	///
	private let content: ( ) -> Content
	
	/// The bounds of the content.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// The amount to displace the content horizontally.
	///
	private var displacementX: CGFloat { return ( self.phase * cos ( self.angle * .pi / 180.0 ) * ( self.reference == .width ? self.bounds.width : self.bounds.height ) ) .truncatingRemainder ( dividingBy: self.bounds.width ) }
	
	/// The amount to displace the content vertically.
	///
	private var displacementY: CGFloat { return ( self.phase * sin ( self.angle * .pi / 180.0 ) * ( self.reference == .width ? self.bounds.width : self.bounds.height ) ) .truncatingRemainder ( dividingBy: self.bounds.height ) }
	
	/// Offsets for each of the marquee segments.
	///
	private let segments: [ [ CGFloat ] ] = exponentiate ( [ -1, 0 ], items: 2 ) ?? .init ( )
	
	/// The view content of the marquee.
	///
	public var body: some View {
		
		ZStack {
			
			//	Optimized by relocating the geometry reader
			
			self.content ( )
				.exportBounds ( to: $bounds )
				.hidden ( )
			
			ForEach ( 0 ..< self.segments.count, id: \ .self ) { index in
				
				//	View optimization through hiding non-visible views
				
				if self.displacementX + self.segments [ index ] [ 0 ] * self.bounds.width <= self.bounds.width || self.displacementX + self.segments [ index ] [ 0 ] * self.bounds.width >= -self.bounds.width && self.displacementY + self.segments [ index ] [ 1 ] * self.bounds.height <= self.bounds.height || self.displacementY + self.segments [ index ] [ 1 ] * self.bounds.height >= -self.bounds.height {
					
					self.content ( )
						.offset ( x: self.displacementX.wrapped ( in: 0.0 ..< bounds.width ) + self.segments [ index ] [ 0 ] * self.bounds.width, y: self.displacementY.wrapped ( in: 0.0 ..< self.bounds.height ) + self.segments [ index ] [ 1 ] * self.bounds.height )
					
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
	public init ( angle: CGFloat = 0.0, phase: CGFloat = 0.0, reference: Self.PhaseReference = .width, @ViewBuilder content: @escaping () -> Content ) {
		
		self.angle = angle
		self.phase = phase
		self.reference = reference
		self.content = content
		
	}
	
}

//
//
