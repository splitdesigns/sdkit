
//
//  SDKit: Variable Filter
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A filter with progressively-increasing intensity.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDVariableFilter: View {
	
	/// The available directions for filter progression.
	///
	public enum Direction: String, CaseIterable { case top, trailing, bottom, leading }
	
	/// Access to the ``SDDefaults`` struct.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// Access to the device's pixel length.
	///
	@Environment ( \ .pixelLength ) private var pixelLength
	
	/// The direction to progress the filter.
	///
	private let progression: Direction
	
	/// A percentage representing the number of times to sample the content.
	///
	private let resolution: CGFloat?
	
	/// The filter configuration to use.
	///
	private let filter: SDBackdropFilter
	
	/// Alignments representing the progression direction.
	///
	private let alignments: [ Alignment ] = [ .top, .trailing, .bottom, .leading ]
	
	/// The orientation of the filter.
	///
	private var orientation: Axis { return progression == .leading || progression == .trailing ? .horizontal : .vertical }
	
	/// The bounds of the filter.
	///
	@State private var bounds: CGRect = .init ( )
	
	/// The length of the filter.
	///
	private var length: CGFloat { return orientation == .horizontal ? bounds.width : bounds.height }
	
	/// The number of times to sample the content.
	///
	private var layers: Int { return .init ( ( resolution ?? pixelLength ) * length ) }
	
	/// Unit points representing the progression direction.
	///
	private let unitPoints: [ UnitPoint ] = [ .top, .trailing, .bottom, .leading ]
	
	/// Aligns the content, and creates a stack of variable-sized, overlapping filters to produce the effect of increasing intensity.
	///
	public var body: some View {
		
		ZStack ( alignment: self.alignments [ Direction.allCases.firstIndex ( of: progression )! ] ) {
			
			ForEach ( 0 ..< self.layers, id: \ .self ) { layer in
				
				SDBackdropFilter (
					
					//  TODO: Fix layer intensity compounding calculations ( most are guesswork )
					
					brightness: 1.0 / CGFloat ( self.layers ) * ( self.filter.brightness ?? self.defaults.filters.brightness ),
					contrast: 1.0 - intensity ( at: layer, for: 1.0 - ( self.filter.contrast ?? self.defaults.filters.contrast ), multiplier: 3.0 ),
					grayscale: intensity ( at: layer, for: self.filter.grayscale ?? self.defaults.filters.grayscale, multiplier: 3.0 ),
					invert: false,
					opacity: 1.0 - intensity ( at: layer, for: 1.0 - ( self.filter.opacity ?? self.defaults.filters.opacity ), multiplier: 1.0 ),
					opaque: false,
					radius: radius ( at: layer ),
					saturation: 1.0 - intensity ( at: layer, for: 1.0 - ( self.filter.saturation ?? self.defaults.filters.saturation ), multiplier: 3.0 ),
					tint: .clear
					
				)
				.frame ( width: self.orientation == .horizontal ? self.size ( at: layer ) : .none )
				.frame ( height: self.orientation == .vertical ? self.size ( at: layer ) : .none )
				
			}
			
		}
		.frame ( maxWidth: .infinity, maxHeight: .infinity )
		.if ( ( self.filter.tint ?? self.defaults.filters.tint ) != .clear ) { $0.overlay ( LinearGradient (
			
			colors: [ ( self.filter.tint ?? self.defaults.filters.tint ), .clear ],
			startPoint: self.unitPoints [ Self.Direction.allCases.firstIndex ( of: self.progression )! ],
			endPoint: self.unitPoints [ ( Self.Direction.allCases.firstIndex ( of: self.progression )! + self.unitPoints.count / 2 ) % self.unitPoints.count ]
			
		) ) }
		.exportBounds ( to: $bounds )
		
	}
	
	/// Calculates the blur radius of a layer based on it's position.
	///
	/// - Parameter at: The position of the layer.
	///
	private func radius ( at position: Int ) -> CGFloat { return ( 1.0 - .init ( position + 1 ) / .init ( self.layers ) ) * sqrt ( self.filter.radius ?? self.defaults.filters.radius ) }
	
	/// Calculates the filter intensity of a layer based on it's position.
	///
	/// - Parameters:
	///   - at: The position of the layer.
	///   - for: The value to calculate the intensity for.
	///   - multiplier: The intensity multiplier.
	///
	private func intensity ( at position: Int, for value: CGFloat, multiplier: CGFloat = 1.0 ) -> CGFloat { return multiplier / .init ( self.layers ) * value }
	
	/// Calculates the size of a layer based on it's position.
	///
	/// - Parameter at: The position of the layer.
	///
	private func size ( at position: Int ) -> CGFloat { return .init ( position + 1 ) / .init ( self.layers ) * self.length }
	
	/// Creates a ``SDVariableFilter`` from a progression direction, resolution, and a filter configuration.
	///
	/// - Parameters:
	///   - progression: The direction to progress the filter.
	///   - resolution: A percentage representing the number of times to sample the content.
	///   - filter: The filter configuration to use.
	///
	public init ( progression: Self.Direction = .bottom, resolution: CGFloat? = nil, filter: SDBackdropFilter = .init ( ) ) {
		
		self.progression = progression
		self.resolution = resolution
		self.filter = filter
		
	}
	
}

//
//
