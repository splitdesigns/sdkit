
//
//  SDKit: Relative Corner Style
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Styles the corners of some content relative to some other content.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDRelativeCornerStyle: ViewModifier {
	
	/// A method to use for comparing the bounds of the content when calculating relative values.
	///
	public enum ComparisonMethod {
		
		/// Calculates the corner radius based on the inset amount of the relative content's bound's edges from the source content's bound's edges.
		///
		/// - Parameters:
		///   - relative: The bounds of the relative content. Uses the bounds of the content if nil.
		///   - source: The bounds of the source content. Uses the bounds of the screen if nil.
		///   - Edges: The edges of the bounds to compare. If multiple edges are specified, the smallest inset amount will be used.
		///   - operation: The operation to calculate relative values with.
		///   - sourceCornerRadius: The corner radius of the source content. Defaults to the corner radius of the display.
		///   - cornerRadiusTransform: Accepts the relative corner radius and the relative content size, and returning a transformed corner radius. Clamps the corner radius in a range of zero to infinity by default.
		///
		case position ( relative: CGRect? = nil, source: CGRect? = nil, edges: [ Edge ] = Edge.allCases, operation: SDRelativeCornerStyle.Operation = .subtract, sourceCornerRadius: CGFloat? = nil, cornerRadiusTransform: ( ( _ cornerRadius: CGFloat, _ relativeContentSize: CGSize ) -> CGFloat )? = nil )
		
		/// Calculates the corner radius by comparing the relative content's bound's size to the size of the source content's bounds.
		///
		/// - Parameters:
		///   - relative: The bounds of the relative content. Uses the bounds of the content if nil.
		///   - source: The bounds of the source content. Uses the bounds of the screen if nil.
		///   - dimensions: The dimensions of the bounds to compare. If both axes are specified, the smallest size difference will be used.
		///   - operation: The operation to calculate relative values with.
		///   - sourceCornerRadius: The corner radius of the source content. Defaults to the corner radius of the display.
		///   - cornerRadiusTransform: Accepts the relative corner radius and the relative content size, and returning a transformed corner radius. Clamps the corner radius in a range of zero to infinity by default.
		///
		case size ( relative: CGRect? = nil, source: CGRect? = nil, dimensions: [ Axis.Set ] = [ .horizontal ], operation: SDRelativeCornerStyle.Operation = .subtract, sourceCornerRadius: CGFloat? = nil, cornerRadiusTransform: ( ( _ cornerRadius: CGFloat, _ relativeContentSize: CGSize ) -> CGFloat )? = nil )
		
		/// Insets the corner radius by the provided value, subtracting the inset amount from the source corner radius.
		///
		/// - Parameters:
		///   - amount: The amount to inset the corner radius.
		///   - sourceCornerRadius: The corner radius of the source content. Defaults to the corner radius of the display.
		///   - cornerRadiusTransform: Accepts the relative corner radius and the relative content size, and returning a transformed corner radius. Clamps the corner radius in a range of zero to infinity by default.
		///
		case inset ( amount: CGFloat, sourceCornerRadius: CGFloat? = nil, cornerRadiusTransform: ( ( _ cornerRadius: CGFloat, _ relativeContentSize: CGSize ) -> CGFloat )? = nil )
		
		///	Sets the corner radius to a fixed value.
		///
		///	- Parameter radius: The corner radius to set.
		///
		case fixed ( radius: CGFloat )
		
		///	Provides case matching capabilities for types with associated values.
		///
		///	- Parameter type: The case type.
		///
		fileprivate func matchesCaseOf ( _ type: Self ) -> Bool {
			
			//	Switch over the enum case
			
			switch self {
					
				//	Return true if the type matches the case
					
				case .position: if case .position = type { return true }
				case .size: if case .size = type { return true }
				case .inset: if case .inset = type { return true }
				case .fixed: if case .fixed = type { return true }
			}
			
			//	Return false if there is no match
			
			return false
			
		}

	}
	
	/// An operation to calculate relative values with.
	///
	public enum Operation {
		
		///	The subtract operation produces a visually-pleasing effect with less scalability, calculating the corner radius by subtracting the inset amount or size difference from the source corner radius. Content with a inset amount or size difference greater than the source corner radius value will be given square corners.
		///
		case subtract
		
		/// The divide operation calculates the corner radius based on the scale of the relative content in proportion to the source content.
		///
		case divide
		
	}
	
	/// An alignment for a shadow.
	///
	public enum ShadowAlignment {
		
		/// Overlays a shadow inside the content, creating the illusion of negative depth.
		///
		case inner
		
		/// Casts a shadow outside the content, creating the illusion of positive depth.
		///
		case drop
		
	}
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The method to use for comparing the bounds of the content when calculating relative values.
	///
	private let method: Self.ComparisonMethod
	
	/// The style of the corners.
	///
	private let cornerStyle: RoundedCornerStyle?
	
	/// The color of the border.
	///
	private let borderColor: Color?
	
	/// The stroke style of the border.
	///
	private let borderStyle: StrokeStyle?
	
	/// The alignment of the shadow.
	///
	private let shadowAlignment: Self.ShadowAlignment
	
	/// The color of the shadow.
	///
	private let shadowColor: Color?
	
	/// The radius of the shadow.
	///
	private let shadowRadius: CGFloat?
	
	/// The offset of the shadow.
	///
	private let shadowOffset: CGSize?
	
	/// The bounds of the relative content.
	///
	@State private var relativeBounds: CGRect = .init ( )
	
	/// Access to the screen information.
	///
	private var screen: UIScreen { return UIWindow ( windowScene: UIApplication.shared.connectedScenes.first as! UIWindowScene ) .screen }
	
	/// The bounds of the screen.
	///
	private var screenBounds: CGRect { return self.screen.bounds }
	
	/// The corner radius of the display.
	///
	private var displayCornerRadius: CGFloat { return self.screen.displayCornerRadius }
	
	/// The corner radius of the relative content.
	///
	private var relativeCornerRadius: CGFloat {
		
		switch self.method {
				
			case let .position ( relative: relative, source: source, edges: edges, operation: operation, sourceCornerRadius: sourceCornerRadius, cornerRadiusTransform: cornerRadiusTransform ):
				
				//	If either the relative bounds or the source bounds are nil, use the bounds of the content and the bounds of the display respectively
				
				let relative: CGRect = relative ?? self.relativeBounds
				let source: CGRect = source ?? self.screenBounds
				
				//	Switch over the operation types
				
				switch operation {
						
						//	Subtract the minimum inset amount from the source corner radius
						
					case .subtract:
						
						//	Create an array of the inset amounts of the relative content's bound's edges from the source content's bound's edges, then get the minimum value
						
						let insetAmount: CGFloat = [
							
							edges.contains ( .top ) ? relative.minY - source.minY : .infinity,
							edges.contains ( .trailing ) ? source.maxX - relative.maxX : .infinity,
							edges.contains ( .bottom ) ? source.maxY - relative.maxY : .infinity,
							edges.contains ( .leading ) ? relative.minX - source.minX : .infinity,
							
						] .min ( )!
						
						//	Return the source corner radius minus the inset amount, transformed
						
						return ( cornerRadiusTransform ?? self.defaults.corners.radiusTransform ) ( ( sourceCornerRadius ?? self.displayCornerRadius ) - insetAmount, self.relativeBounds.size )
												
					case .divide:
						
						//	Create an array of the scales of the relative content in proportion to the source content for each dimension, then get the maximum value
						
						let scale: CGFloat = [

							edges.contains ( .top ) ? ( relative.minY - source.midY ) / ( source.minY - source.midY ) : .zero,
							edges.contains ( .trailing ) ? ( relative.maxX - source.midX ) / ( source.maxX - source.midX ) : .zero,
							edges.contains ( .bottom ) ? ( relative.maxY - source.midY ) / ( source.maxY - source.midY ) : .zero,
							edges.contains ( .leading ) ? ( relative.minX - source.midX ) / ( source.minX - source.midX ) : .zero

						] .max ( )!
						
						//	Return the source corner radius multiplied by the scale, transformed
						
						return ( cornerRadiusTransform ?? self.defaults.corners.radiusTransform ) ( ( sourceCornerRadius ?? self.displayCornerRadius ) * scale, self.relativeBounds.size )
						
				}
				
			case let .size ( relative: relative, source: source, dimensions: dimensions, operation: operation, sourceCornerRadius: sourceCornerRadius, cornerRadiusTransform: cornerRadiusTransform ):
								
				//	Retrieve the relative size and the source size, using the bounds of the content and the bounds of the display respectively if either are nil
				
				let relative: CGSize = relative?.size ?? self.relativeBounds.size
				let source: CGSize = source?.size ?? self.screenBounds.size
				
				//	Switch over the operation types
				
				switch operation {
						
						//	Subtract the difference between the relative size and the source size from the source corner radius
						
					case .subtract:
						
						//	Create an array of the differences for each dimension, then get the minimum value
						
						let difference: CGFloat = [
							
							dimensions.contains ( .horizontal ) ? source.width - relative.width : .infinity,
							dimensions.contains ( .vertical ) ? source.height - relative.height : .infinity
							
						] .min ( )!

						//	Return the source corner radius minus half of the difference, transformed
						
						return ( cornerRadiusTransform ?? self.defaults.corners.radiusTransform ) ( ( sourceCornerRadius ?? self.displayCornerRadius ) - ( difference != .zero ? difference / 2.0 : difference ), self.relativeBounds.size )
						
						//	Divide the relative size by the source size, then multiply by the source corner radius
												
					case .divide:
						
						//	Create an array of the scales of the relative content in proportion to the source content for each dimension, then get the maximum value
						
						let scale: CGFloat = [
							
							dimensions.contains ( .horizontal ) ? relative.width / source.width : .zero,
							dimensions.contains ( .vertical ) ? relative.height / source.height : .zero
							
						] .max ( )!
						
						//	Return the source corner radius multiplied by the scale, transformed
						
						return ( cornerRadiusTransform ?? self.defaults.corners.radiusTransform ) ( ( sourceCornerRadius ?? self.displayCornerRadius ) * scale, self.relativeBounds.size )
						
				}
				
				//	Subtract the inset amount from the source corner radius, then return the transformed radius
				
			case let .inset ( amount: amount, sourceCornerRadius: sourceCornerRadius, cornerRadiusTransform: cornerRadiusTransform ): return ( cornerRadiusTransform ?? self.defaults.corners.radiusTransform ) ( ( sourceCornerRadius ?? self.displayCornerRadius ) - amount, self.relativeBounds.size )
				
				//	Return the fixed corner radius
				
			case let .fixed ( radius: radius ): return radius
				
		}
		
	}
	
	/// Retrieve the content's bounds, then apply a corner radius, border, and shadow.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.background ( SDBackdrop ( ) )
			.compositingGroup ( )
			.if ( self.method.matchesCaseOf ( .position ( ) ) || self.method.matchesCaseOf ( .size ( ) ) || self.method.matchesCaseOf ( .inset ( amount: .zero ) ) || ( self.shadowAlignment == .inner && self.shadowRadius ?? self.defaults.shadows.radius != .zero ) ) {
				
				//	Export the bounds if needed for the inner shadow or relative corner radius calculations
				
				$0.exportBounds ( from: .global, to: self.$relativeBounds )
				
			}
			.clipShape ( RoundedRectangle ( cornerRadius: self.relativeCornerRadius, style: self.cornerStyle ?? self.defaults.corners.style ), style: FillStyle ( eoFill: false, antialiased: self.defaults.optimizations.antialiasing ) )
			.if ( self.shadowAlignment == .drop && self.shadowRadius ?? self.defaults.shadows.radius != .zero ) {
				
				//	Apply a drop shadow if the shadow alignment specifies, and the shadow radius is not zero
				
				$0.shadow ( color: self.shadowColor ?? self.defaults.shadows.color.auto, radius: self.shadowRadius ?? self.defaults.shadows.radius, x: self.shadowOffset?.width ?? self.defaults.shadows.offset.width, y: self.shadowOffset?.height ?? self.defaults.shadows.offset.height )
				
			}
			.overlay {
				
				//	Stack the border on top of the inner shadow
				
				ZStack {
					
					//	Check if an inner shadow needs to be drawn
					
					if self.shadowAlignment == .inner && self.shadowRadius ?? self.defaults.shadows.radius != .zero {
						
						//	Draw a negatively-inset rectangle filled with the shadow color
												
						RoundedRectangle ( cornerRadius: self.relativeCornerRadius + ( self.shadowRadius ?? self.defaults.shadows.radius ) / 2.0, style: self.cornerStyle ?? self.defaults.corners.style )
							.frame ( width: self.relativeBounds.size.width + pow ( self.shadowRadius ?? self.defaults.shadows.radius, 2.0 ), height: self.relativeBounds.size.height + pow ( self.shadowRadius ?? self.defaults.shadows.radius, 2.0 ) )
							.foregroundStyle ( self.shadowColor ?? self.defaults.shadows.color.auto )
							.overlay {
								
								//	Draw an inset rectangle to use as a mask

								RoundedRectangle ( cornerRadius: self.relativeCornerRadius - ( self.shadowRadius ?? self.defaults.shadows.radius ) / 2.0, style: self.cornerStyle ?? self.defaults.corners.style )
									.frame ( width: self.relativeBounds.size.width, height: self.relativeBounds.size.height )
									.offset ( x: self.shadowOffset?.width ?? self.defaults.shadows.offset.width, y: self.shadowOffset?.height ?? self.defaults.shadows.offset.height )
									.blendMode ( .destinationOut )

							}
							.compositingGroup ( )
							.blur ( radius: ( self.shadowRadius ?? self.defaults.shadows.radius ), opaque: false )
							.mask {
								
								//	Clip the blurred stroke back to it's original shape

								RoundedRectangle ( cornerRadius: self.relativeCornerRadius, style: self.cornerStyle ?? self.defaults.corners.style )
									.frame ( width: self.relativeBounds.size.width, height: self.relativeBounds.size.height )

							}
							.allowsHitTesting ( false )
						
					}
					
					//	Check if a border needs to be drawn
					
					if self.borderStyle?.lineWidth ?? self.defaults.borders.style.lineWidth != .zero {
						
						//	Draw a border
						
						RoundedRectangle ( cornerRadius: self.relativeCornerRadius, style: self.cornerStyle ?? self.defaults.corners.style )
							.strokeBorder ( self.borderColor ?? self.defaults.borders.color.auto, style: self.borderStyle ?? self.defaults.borders.style, antialiased: self.defaults.optimizations.antialiasing )
							.foregroundStyle ( .clear )
						
					}
											
				}
				
			}
		
	}
	
	/// Creates an ``SDRelativeCornerStyle`` instance from a corner configuration.
	///
	/// - Parameters:
	///   - method: The method to use for comparing the bounds of the content when calculating relative values.
	///   - cornerStyle: The style of the corners.
	///   - borderColor: The color of the border.
	///   - borderStyle: The stroke style of the border.
	///   - shadowAlignment: The alignment of the shadow.
	///   - shadowColor: The color of the shadow.
	///   - shadowRadius: The radius of the shadow.
	///   - shadowOffset: The offset of the shadow.
	///
	public init (
		
		method: Self.ComparisonMethod = .position ( ),
		cornerStyle: RoundedCornerStyle? = nil,
		borderColor: Color? = nil,
		borderStyle: StrokeStyle? = nil,
		shadowAlignment: Self.ShadowAlignment = .drop,
		shadowColor: Color? = nil,
		shadowRadius: CGFloat? = nil,
		shadowOffset: CGSize? = nil
		
	) {
		
		self.method = method
		self.cornerStyle = cornerStyle
		self.borderColor = borderColor
		self.borderStyle = borderStyle
		self.shadowAlignment = shadowAlignment
		self.shadowColor = shadowColor
		self.shadowRadius = shadowRadius
		self.shadowOffset = shadowOffset
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension UIScreen {
	
	/// The display corner radius key.
	///
	private static let displayCornerRadiusKey: String = { [ "Radius", "Corner", "display", "_" ] .reversed ( ) .joined ( ) } ( )
	
	/// The corner radius of the device's display.
	///
	/// - Warning: Uses a private API.
	///
	var displayCornerRadius: CGFloat { ( self.value ( forKey: Self.displayCornerRadiusKey ) as? CGFloat ) ?? 0.0 }
	
}

@available ( iOS 16.0, * )
public extension View {
	
	/// Styles the corners of some content relative to some other content. See ``SDRelativeCornerStyle`` for more info.
	///
	/// - Parameters:
	///   - method: The method to use for comparing the bounds of the content when calculating relative values.
	///   - cornerStyle: The style of the corners.
	///   - borderColor: The color of the border.
	///   - borderStyle: The stroke style of the border.
	///   - shadowAlignment: The alignment of the shadow.
	///   - shadowColor: The color of the shadow.
	///   - shadowRadius: The radius of the shadow.
	///   - shadowOffset: The offset of the shadow.
	///
	/// - Warning: Uses a private API.
	///
	func relativeCornerStyle (
		
		method: SDRelativeCornerStyle.ComparisonMethod = .position ( ),
		cornerStyle: RoundedCornerStyle? = nil,
		borderColor: Color? = nil,
		borderStyle: StrokeStyle? = nil,
		shadowAlignment: SDRelativeCornerStyle.ShadowAlignment = .drop,
		shadowColor: Color? = nil,
		shadowRadius: CGFloat? = nil,
		shadowOffset: CGSize? = nil
		
	) -> some View {
		
		return self.modifier ( SDRelativeCornerStyle (
			
			method: method,
			cornerStyle: cornerStyle,
			borderColor: borderColor,
			borderStyle: borderStyle,
			shadowAlignment: shadowAlignment,
			shadowColor: shadowColor,
			shadowRadius: shadowRadius,
			shadowOffset: shadowOffset
			
		) )
		
	}
	
}

//
//
