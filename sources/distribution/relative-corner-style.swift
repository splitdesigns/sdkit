
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
///	If the `relative` or `source` sizes are omitted, the relative values will be calculated using the bounds of the content and the bounds of the display, respectively. The `axis` parameter determines which values to fetch and compare, producing different results based on the proportions of the content's bounds.
///
///	The `.divide` operation linearly interpolates a corner radius value between the source corner radius and zero, based on the scale of the relative content in proportion to the source content.
///
///	The `.subtract` operation will produce a more pleasing visual effect with less scalability, calculating the corner radius by subtracting the difference between the size of the relative content and the source content from the source corner radius. Content inset a distance greater than the source corner radius value will be given square corners.
///
/// - Warning: Uses a private API.
///
@available ( iOS 16.0, * )
public struct SDRelativeCornerStyle: ViewModifier {
	
	/// An operation to calculate relative values with.
	///
	public enum Operation: String, CaseIterable { case subtract, divide }
	
	/// The alignment of a shadow.
	///
	public enum ShadowAlignment: String, CaseIterable { case inner, drop }
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The size of the relative content.
	///
	private let relative: CGFloat?
	
	/// The size of the source content.
	///
	private let source: CGFloat?
	
	/// The axis to calculate relative values from.
	///
	private let axis: Axis.Set
	
	/// The operation to calculate relative values with.
	///
	private let operation: Operation
	
	/// The corner style of the relative corners.
	///
	private let cornerStyle: RoundedCornerStyle?
	
	/// The range to clamp the relative corner radius in.
	///
	private let cornerRadiusRange: ClosedRange < CGFloat >?
	
	/// The corner radius of the source content.
	///
	private let sourceCornerRadius: CGFloat?
	
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
	
	/// The bounds of the display.
	///
	private var displayBounds: CGRect { return self.screen.bounds }
	
	/// The corner radius of the display.
	///
	private var displayCornerRadius: CGFloat { return self.screen.displayCornerRadius }
	
	/// The corner radius of the relative content.
	///
	private var relativeCornerRadius: CGFloat {
		
		//	Get the relative size and the source size, using the bounds of the content and the bounds of the display respectively if either are nil
		
		let relative: CGFloat = self.relative ?? ( self.axis == .horizontal ? self.relativeBounds.size.width : self.relativeBounds.size.height )
		let source: CGFloat = self.source ?? ( self.axis == .horizontal ? self.displayBounds.size.width : self.displayBounds.size.height )
		
		//	Switch over operation types
		
		switch operation {
				
				//	Calculate the relative corner radius by subtracting the difference between the relative size and the source size from the source corner radius
				
			case .subtract: return ( self.sourceCornerRadius ?? self.displayCornerRadius - ( source - relative ) / 2.0 ) .clamped ( in: self.cornerRadiusRange ?? self.defaults.corners.radiusRange )
				
				//	Calculate the relative corner radius by dividing the relative size by the source source size, then multiplying by the source corner radius
				
			case .divide: return ( relative / source * ( self.sourceCornerRadius ?? self.displayCornerRadius ) ) .clamped ( in: self.cornerRadiusRange ?? self.defaults.corners.radiusRange )
				
		}
		
	}
	
	/// Retrieve the bounds, then applies a corner radius, border, and shadow to the content.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.background ( SDBackdrop ( ) )
			.compositingGroup ( )
			.if ( self.relative == nil || ( self.shadowAlignment == .inner && self.shadowRadius ?? self.defaults.shadows.radius != .zero ) ) { $0.exportBounds ( to: self.$relativeBounds ) }
			.clipShape ( RoundedRectangle ( cornerRadius: self.relativeCornerRadius, style: self.cornerStyle ?? self.defaults.corners.style ), style: FillStyle ( eoFill: false, antialiased: self.defaults.optimizations.antialiasing ) )
			.if ( self.shadowAlignment == .drop && self.shadowRadius ?? self.defaults.shadows.radius != .zero ) { $0.shadow ( color: self.shadowColor ?? self.defaults.shadows.color.auto, radius: self.shadowRadius ?? self.defaults.shadows.radius, x: self.shadowOffset?.width ?? self.defaults.shadows.offset.width, y: self.shadowOffset?.height ?? self.defaults.shadows.offset.height ) }
			.overlay {
				
				//	Stack the border on top of the inner shadow
				
				ZStack {
					
					//	Check if an inner shadow needs to be drawn
					
					if self.shadowAlignment == .inner && self.shadowRadius ?? self.defaults.shadows.radius != .zero {
						
						//	Draw an expanded rectangle filled with the shadow color
												
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
	///   - relative: The size of the relative content.
	///   - source: The size of the source content.
	///   - axis: The axis to calculate relative values from.
	///   - operation: The operation to calculate relative values with.
	///   - cornerStyle: The corner style of the relative corners.
	///   - cornerRadiusRange: The range to clamp the relative corner radius in.
	///   - sourceCornerRadius: The corner radius of the source content.
	///   - borderColor: The color of the border.
	///   - borderStyle: The stroke style of the border.
	///   - shadowAlignment: The alignment of the shadow.
	///   - shadowColor: The color of the shadow.
	///   - shadowRadius: The radius of the shadow.
	///   - shadowOffset: The offset of the shadow.
	///
	public init (
		
		relative: CGFloat? = nil,
		source: CGFloat? = nil,
		axis: Axis.Set = .horizontal,
		operation: SDRelativeCornerStyle.Operation = .subtract,
		cornerStyle: RoundedCornerStyle? = nil,
		cornerRadiusRange: ClosedRange < CGFloat >? = nil,
		sourceCornerRadius: CGFloat? = nil,
		borderColor: Color? = nil,
		borderStyle: StrokeStyle? = nil,
		shadowAlignment: Self.ShadowAlignment = .drop,
		shadowColor: Color? = nil,
		shadowRadius: CGFloat? = nil,
		shadowOffset: CGSize? = nil
		
	) {
		
		self.relative = relative
		self.source = source
		self.axis = axis
		self.operation = operation
		self.cornerStyle = cornerStyle
		self.cornerRadiusRange = cornerRadiusRange
		self.sourceCornerRadius = sourceCornerRadius
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
	///   - relative: The size of the relative content.
	///   - source: The size of the source content.
	///   - axis: The axis to calculate relative values from.
	///   - operation: The operation to calculate relative values with.
	///   - cornerStyle: The corner style of the relative corners.
	///   - cornerRadiusRange: The range to clamp the relative corner radius in.
	///   - sourceCornerRadius: The corner radius of the source content.
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
		
		relative: CGFloat? = nil,
		source: CGFloat? = nil,
		axis: Axis.Set = .horizontal,
		operation: SDRelativeCornerStyle.Operation = .subtract,
		cornerStyle: RoundedCornerStyle? = nil,
		cornerRadiusRange: ClosedRange < CGFloat >? = nil,
		sourceCornerRadius: CGFloat? = nil,
		borderColor: Color? = nil,
		borderStyle: StrokeStyle? = nil,
		shadowAlignment: SDRelativeCornerStyle.ShadowAlignment = .drop,
		shadowColor: Color? = nil,
		shadowRadius: CGFloat? = nil,
		shadowOffset: CGSize? = nil
		
	) -> some View {
		
		return self.modifier ( SDRelativeCornerStyle (
			
			relative: relative,
			source: source,
			axis: axis,
			operation: operation,
			cornerStyle: cornerStyle,
			cornerRadiusRange: cornerRadiusRange,
			sourceCornerRadius: sourceCornerRadius,
			borderColor: borderColor,
			borderStyle: borderStyle,
			shadowAlignment: shadowAlignment,
			shadowColor: shadowColor,
			shadowRadius: shadowRadius,
			shadowOffset: shadowOffset
			
		) )
		
	}
	
	/// Styles the corners of some content relative to some other content using a subtract operation and an inset amount. See ``SDRelativeCornerStyle`` for more info.
	///
	/// - Parameters:
	///   - insetAmount: The amount the relative content is inset from the source content.
	///   - axis: The axis to calculate relative values from.
	///   - cornerStyle: The corner style of the relative corners.
	///   - cornerRadiusRange: The range to clamp the relative corner radius in.
	///   - sourceCornerRadius: The corner radius of the source content.
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
		
		insetAmount: CGFloat? = nil,
		axis: Axis.Set = .horizontal,
		cornerStyle: RoundedCornerStyle? = nil,
		cornerRadiusRange: ClosedRange < CGFloat >? = nil,
		sourceCornerRadius: CGFloat? = nil,
		borderColor: Color? = nil,
		borderStyle: StrokeStyle? = nil,
		shadowAlignment: SDRelativeCornerStyle.ShadowAlignment = .drop,
		shadowColor: Color? = nil,
		shadowRadius: CGFloat? = nil,
		shadowOffset: CGSize? = nil
		
	) -> some View {
		
		return self.modifier ( SDRelativeCornerStyle (
			
			relative: insetAmount != nil ? 0.0 : nil,
			source: insetAmount != nil ? insetAmount! * 2.0 : nil,
			axis: axis,
			operation: .subtract,
			cornerStyle: cornerStyle,
			cornerRadiusRange: cornerRadiusRange,
			sourceCornerRadius: sourceCornerRadius,
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
