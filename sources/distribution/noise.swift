
//
//  SDKit: Noise
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Generates a noise field.
///
@available ( iOS 16.0, * )
public struct SDNoise: View {
	
	///	Access to the pixel length.
	///
	@Environment ( \ .pixelLength ) private var pixelLength
	
	///	The size of each particle.
	///
	private let scale: CGFloat
	
	///	Animate the noise.
	///
	private let animate: Bool
	
	/// Accepts the size of the noise, the particle column and row and the time, and returns a color.
	///
	private let generator: ( _ size: CGSize, _ column: Int, _ row: Int, _ time: Date ) -> Color
	
	/// Animates a canvas that draws pixels using a color generator.
	///
	public var body: some View {
		
		//	Timeline for animating the noise
		
		TimelineView ( .animation ( minimumInterval: nil, paused: !self.animate ) ) { timelineContext in
			
			//	A canvas for drawing the noise
			
			Canvas { context, size in
				
				//	Make sure that the particle size isn't smaller than the pixel size
				
				let scale: CGFloat = self.scale.clamped ( in: self.pixelLength ... .infinity )
				
				//	Draw at the specified scale, compensating for rounding
				
				context.scaleBy ( x: scale * ( 1.0 / ( floor ( size.width / scale ) / ( size.width / scale ) ) ), y: scale * ( 1.0 / ( floor ( size.height / scale ) / ( size.height / scale ) ) ) )
				
				//	Loop over rows
				
				for row in .zero ..< Int ( size.height / scale ) {
					
					//	Loop over columns
					
					for column in .zero ..< Int ( size.width / scale ) {
						
						//  Fill a rectangle with the generated color
						
						context.fill ( Path ( .init ( x: column, y: row, width: 1, height: 1 ) ), with: .color ( self.generator ( .init ( width: floor ( size.width / scale ), height: floor ( size.height / scale ) ), column, row, timelineContext.date ) ) )
						
					}
					
				}
				
			}
			
		}
		
	}
	
	/// Creates an ``SDNoise`` instance from a particle size and a color generator.
	///
	/// - Parameters:
	///   - scale: The size of each particle.
	///   - animate: Animate the noise.
	///   - generator: Accepts the size of the noise, the particle column and row and the time, and returns a color.
	///
	public init ( scale: CGFloat = 1.0, animate: Bool = false, generator: @escaping ( _ size: CGSize, _ column: Int, _ row: Int, _ time: Date ) -> Color = { size, column, row, time in
		
		return .init (
			
			hue: .random ( in: .zero ... 1.0 ),
			saturation: .random ( in: .zero ... 1.0 ),
			brightness: .random ( in: .zero ... 1.0 ),
			opacity: .random ( in: .zero ... 1.0 )
			
	) } ) {
		
		self.scale = scale
		self.animate = animate
		self.generator = generator
		
	}
	
}

//
//
