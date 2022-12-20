//
////
////  SDKit: Relative Corner Style
////  Developed by SPLIT Designs
////
//
////  MARK: - Imports
//
//import SwiftUI
//
////
////
//
////  MARK: - Structures
//
///// Applies styling relative to the view's size and environment.
/////
///// - Warning: Uses a private API.
/////
//@available ( iOS 16.0, * )
//public struct SDRelativeCornerStyle: ViewModifier {
//	
//	/// Access to the ``SDDefaults`` struct.
//	///
//	@Environment ( \ .defaults ) private var defaults
//	
//	/// The operation to use when calculating relative values.
//	///
//	public enum Operation: String { case subtract, divide }
//	
//	/// The width or height value of the subject view.
//	///
//	private let subject: CGFloat?
//	
//	/// The width or height value of the relative view.
//	///
//	private let relative: CGFloat?
//	
//	/// The axis used for calculating relative values.
//	///
//	private let axis: Axis
//	
//	/// The operation to use when calculating relative values.
//	///
//	private let operation: Operation
//	
//	/// Precedes calculated corner radius values that are smaller in size.
//	///
//	private let minRadius: CGFloat
//	
//	/// Precedes calculated corner radius values that are larger in size.
//	///
//	private let maxRadius: CGFloat
//	
//	/// The radius to compute relative values from.
//	///
//	private let relativeRadius: CGFloat?
//	
//	/// Determines the shape of the view's corners.
//	///
//	private let cornerStyle: RoundedCornerStyle
//	
//	/// The style to apply to the border.
//	///
//	private let border: Color?
//	
//	/// The stroke style of the border.
//	///
//	private let borderStyle: StrokeStyle?
//	
//	/// A container for the bounds of the view.
//	///
//	@State private var subjectBounds: CGRect = .init ( )
//	
//	/// A container for the size of the view. Used to calculate values when `subject` is `nil`.
//	///
//	private var subjectSize: CGSize { return subjectBounds.size }
//	
//	/// Access to screen information.
//	///
//	private var system: UIScreen { return UIWindow ( windowScene: UIApplication.shared.connectedScenes.first as! UIWindowScene ) .screen }
//	
//	/// A container for the size of the screen. Used to calculate values when `relative` is `nil`.
//	///
//	private var systemSize: CGSize { return system.bounds.size }
//	
//	/// The corner radius of the device's screen. Used to calculate values when `relativeRadius` is `nil`.
//	///
//	private var systemRadius: CGFloat { return system.displayCornerRadius }
//	
//	/// Calculates the corner radius for the view.
//	///
//	private var radius: CGFloat {
//		
//		let computedSubject, computedRelative: CGFloat
//		
//		computedSubject = self.subject ?? ( self.axis == .horizontal ? self.subjectSize.width : self.subjectSize.height )
//		computedRelative = self.relative ?? ( self.axis == .horizontal ? self.systemSize.width : self.systemSize.height )
//		
//		switch operation {
//				
//			case .subtract: return min ( self.maxRadius, max ( self.minRadius, ( self.relativeRadius ?? self.systemRadius ) - ( computedRelative - computedSubject ) / 2.0 ) )
//			case .divide: return min ( self.maxRadius, max ( self.minRadius, ( computedSubject / computedRelative ) * ( self.relativeRadius ?? self.systemRadius ) ) )
//				
//		}
//		
//	}
//	
//	/// Gets the bounds of the screen and container, and adds a corner radius and border.
//	///
//	public func body ( content: Content ) -> some View {
//		
//		content
//			.exportBounds ( to: self.$subjectBounds )
//			.clipShape ( RoundedRectangle ( cornerRadius: self.radius, style: self.cornerStyle ) )
//			.overlay {
//				
//				RoundedRectangle ( cornerRadius: self.radius, style: self.cornerStyle )
//					.strokeBorder ( self.border ?? self.defaults.borders.color, style: self.borderStyle ?? self.defaults.borders.style, antialiased: true )
//					.foregroundColor ( .clear )
//				
//			}
//		
//	}
//	
//	/// Creates a ``SDRelativeCornerStyle`` from a configuration.
//	///
//	/// - Parameters:
//	///   - subject: The width or height value of the subject view.
//	///   - relative: The width or height value of the relative view.
//	///   - axis: The axis used for calculating relative values.
//	///   - operation: The operation to use when calculating relative values.
//	///   - minRadius: Precedes calculated corner radius values that are smaller in size.
//	///   - maxRadius: Precedes calculated corner radius values that are larger in size.
//	///   - relativeRadius: The radius to compute relative values from.
//	///   - cornerStyle: Determines the shape of the view's corners.
//	///   - border: The style to apply to the border.
//	///   - borderStyle: The stroke style of the border.
//	///
//	public init (
//		
//		subject: CGFloat? = nil,
//		relative: CGFloat? = nil,
//		axis: Axis = .horizontal,
//		operation: Operation = .subtract,
//		minRadius: CGFloat = 0.0,
//		maxRadius: CGFloat = .infinity,
//		relativeRadius: CGFloat? = nil,
//		cornerStyle: RoundedCornerStyle = .continuous,
//		border: Color? = nil,
//		borderStyle: StrokeStyle? = nil
//		
//	) {
//		
//		self.subject = subject
//		self.relative = relative
//		self.axis = axis
//		self.operation = operation
//		self.minRadius = minRadius
//		self.maxRadius = maxRadius
//		self.relativeRadius = relativeRadius
//		self.cornerStyle = cornerStyle
//		self.border = border
//		self.borderStyle = borderStyle
//		
//	}
//	
//}
//
////
////
//
////  MARK: - Extensions
//
//@available ( iOS 16.0, * )
//public extension UIScreen {
//	
//	/// The selector to call.
//	///
//	private static let cornerRadiusKey: String = { [ "Radius", "Corner", "display", "_" ] .reversed ( ) .joined ( ) } ( )
//	
//	/// The corner radius of the device's screen.
//	///
//	var displayCornerRadius: CGFloat { ( self.value ( forKey: Self.cornerRadiusKey ) as? CGFloat ) ?? 0.0 }
//	
//}
//
//@available ( iOS 16.0, * )
//public extension View {
//	
//	/// Applies styling relative to the view's size and environment.
//	///
//	/// - Parameters:
//	///   - subject: The width or height value of the subject view.
//	///   - relative: The width or height value of the relative view.
//	///   - axis: The axis used for calculating relative values.
//	///   - operation: The operation to use when calculating relative values.
//	///   - minRadius: Precedes calculated corner radius values that are smaller in size.
//	///   - maxRadius: Precedes calculated corner radius values that are larger in size.
//	///   - relativeRadius: The radius to compute relative values from.
//	///   - cornerStyle: Determines the shape of the view's corners.
//	///   - border: The style to apply to the border.
//	///   - borderStyle: The stroke style of the border.
//	///
//	/// - Warning: Uses a private API.
//	///
//	func relativeCornerStyle (
//		
//		subject: CGFloat? = nil,
//		relative: CGFloat? = nil,
//		axis: Axis = .horizontal,
//		operation: SDRelativeCornerStyle.Operation = .subtract,
//		minRadius: CGFloat = 0.0,
//		maxRadius: CGFloat = .infinity,
//		relativeRadius: CGFloat? = nil,
//		cornerStyle: RoundedCornerStyle = .continuous,
//		border: Color? = nil,
//		borderStyle: StrokeStyle? = nil
//		
//	) -> some View {
//		
//		return self.modifier ( SDRelativeCornerStyle (
//			
//			subject: subject,
//			relative: relative,
//			axis: axis,
//			operation: operation,
//			minRadius: minRadius,
//			maxRadius: maxRadius,
//			relativeRadius: relativeRadius,
//			cornerStyle: cornerStyle,
//			border: border,
//			borderStyle: borderStyle
//			
//		) )
//		
//	}
//	
//}
//
////
////