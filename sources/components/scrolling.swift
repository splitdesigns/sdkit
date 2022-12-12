
//
//  SDKit: Scrolling
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI
//
//

//	MARK: - Structures

/// A container that enables bidirectional programmatic scrolling and snapping capabilities.
///
@available ( iOS 16.0, * )
public struct SDSStack < Content: View > : Identifiable, View {
	
	/// An identifiable set of offsets representing the preferred position of it's associated view anchor.
	///
	private struct ScrollGuide: Equatable, Hashable, Identifiable {
		
		/// An identifier for the guide.
		///
		fileprivate let id: String
		
		/// The guide's position.
		///
		fileprivate let position: ( x: CGFloat?, y: CGFloat? )
		
		/// A comparator for equatable conformance.
		///
		/// - Parameters:
		///   - lhs: The first value to compare.
		///   - rhs: The second value to compare.
		///
		public static func == ( lhs: ScrollGuide, rhs: ScrollGuide ) -> Bool { return lhs.position.x == rhs.position.x && lhs.position.y == rhs.position.y && lhs.id == rhs.id }
		
		/// A hasher for hashable conformance.
		///
		/// - Parameter into: The hasher used to hash the value.
		///
		public func hash ( into hasher: inout Hasher ) {
			
			hasher.combine ( self.id )
			hasher.combine ( self.position.x )
			hasher.combine ( self.position.y )
			
		}
		
		/// Creates bounding scroll guides around the edges of the content.
		///
		/// - Parameters:
		///   - content: The bounds of the content.
		///   - container: The bounds of the stack.
		///
		static fileprivate func frame ( content: CGRect, container: CGRect ) -> Set < Self > { return [ .init ( position: ( x: nil, y: .zero ), id: "Top" ), .init ( position: ( x: .zero - content.width + container.width, y: nil ), id: "Trailing" ), .init ( position: ( x: nil, y: .zero - content.height + container.height ), id: "Bottom" ), .init (position: ( x: .zero, y: nil ), id: "Leading" ) ] }
		
		/// Creates a ``ScrollGuide``.
		///
		/// - Parameters:
		///   - position: The guide's position.
		///   - id: An identifier for the guide.
		///
		fileprivate init ( position: ( x: CGFloat?, y: CGFloat? ), id: String ) {
			
			self.id = id
			self.position = position
			
		}
		
	}
	
	/// Access to the defaults object.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// An identifier for the stack.
	///
	public let id: String
	
	/// The scrollable axes of the stack.
	///
	private let axes: [ Axis.Set ]
	
	/// Enables scroll snapping.
	///
	private let snaps: Bool
	
	/// The threshold between the scroll position and a guide before snap engagement.
	///
	private let tolerance: CGFloat
	
	/// Snap exclusively in the direction of the scroll movement.
	///
	private let directional: Bool
	
	/// The speed to decelerate scrolling content at.
	///
	private let deceleration: CGFloat
	
	/// The maximum duration to decelerate for.
	///
	private let maxDuration: CGFloat
	
	/// A number representing the stretch factor when dragging outside the bounds of the scroll content.
	///
	private let elasticity: CGFloat
	
	/// A closure that accepts a duration relative to the scroll translation, and returns an animation to use when decelerating content.
	///
	private let animation: ( ( _ duration: CGFloat ) -> Animation )?
	
	/// The content of the stack.
	///
	private let content: ( Self ) -> Content
	
	/// The bounds of the stack.
	///
	@State public private ( set ) var bounds: CGRect = .init ( )
	
	/// The bounds of the stack's content.
	///
	@State public private ( set ) var contentBounds: CGRect = .init ( )
	
	/// The scroll guides.
	///
	@State private var guides: Set < ScrollGuide > = .init ( )
	
	/// The current scroll position, not including active gesture translations.
	///
	@State public private ( set ) var position: ( x: SDTranspose, y: SDTranspose ) = ( .init ( ), .init ( ) )
	
	/// The translation from the current scroll position created by a gesture.
	///
	@State public private ( set ) var translation: ( x: CGFloat, y: CGFloat ) = ( .zero, .zero )
	
	/// The absolute offset of the content.
	///
	public var offset: ( x: CGFloat, y: CGFloat ) { return ( self.position.x.target + self.translation.x, self.position.y.target + self.translation.y ) }
	
	/// Uses a gesture capture and anchor preferences to create a customizable scrolling experience.
	///
	public var body: some View {
		
		//	Captures interactions
		
		SDTouchInteraction { response in
			
			//	Provides support for overflowing layouts and resolving anchor preferences
			
			GeometryReader { proxy in
				
				//  The content of the stack
				
				self.content ( self )
					.exportBounds ( from: .named ( self.id ), to: self.$contentBounds )
					.backgroundPreferenceValue ( SDScrollAnchors.self ) { anchors in
						
						//	Check if scroll snapping is enabled
						
						if self.snaps {
							
							//	Map over the anchors
							
							let anchors: [ SDScrollAnchor ] = anchors.compactMap {
								
								//	Discard the anchor if it belongs to a different view
								
								if let stackID = $0.stackID, stackID != self.id { return nil }
								
								//	Create a copy of the anchor, and use the geometry proxy to resolve it
								
								var anchor: SDScrollAnchor = $0
								return anchor.resolved ( with: proxy )
								
							}
							
							//  Updates the scroll guides on preference key changes
							
							SDNothing ( )
								.onUpdate ( of: anchors ) { self.align ( with: $0 ) }
								.hidden ( )
							
						}
						
					}
				
			}
			.offset ( x: offset.x, y: offset.y )
			.clipped ( )
			.onUpdate ( of: response ) { self.react ( active: $0.isPressed, translation: $0.data?.translation, predictedTranslation: $0.data?.predictedEndTranslation ) }
			.interpolateAnimation ( for: self.position.x.target ) { literal in if self.position.x.target != self.position.x.literal { self.position.x.literal = literal } }
			.interpolateAnimation ( for: self.position.y.target ) { literal in if self.position.y.target != self.position.y.literal { self.position.y.literal = literal } }
			.coordinateSpace ( name: self.id )
			.exportBounds ( from: .named ( self.id ), to: self.$bounds )
			
		}
		
	}
	
	/// Creates guides from a collection of scroll anchors.
	///
	/// - Parameter with: The anchors to create the guides from.
	///
	private func align ( with anchors: [ SDScrollAnchor ] ) -> Void {
		
		//	Remove all existing guides, and create guides to reflect the bounds of the content
		
		self.guides.removeAll ( keepingCapacity: true )
		self.guides.formUnion ( Self.ScrollGuide.frame ( content: self.contentBounds, container: self.bounds ) )
		
		//	Loop over each scroll anchor
		
		for anchor in anchors {
			
			//	Loop over the guide configurations for each anchor
			
			for configuration in anchor.configurations {
				
				//	Loop over the alignments for each guide configuration
				
				for alignment in configuration.alignments {
					
					//	Define the guide position, the corrected origin of the anchor, the position offset, and the alignment offset
					
					var position: ( x: CGFloat?, y: CGFloat? ) = ( nil, nil ), origin: ( x: CGFloat, y: CGFloat ), positionOffset: ( x: CGFloat, y: CGFloat ), alignmentOffset: ( x: CGFloat, y: CGFloat )
					
					origin = ( anchor.bounds!.origin.x - ( self.position.x.literal - self.position.x.static ), anchor.bounds!.origin.y - ( self.position.y.literal - self.position.y.static ) )
					positionOffset = ( anchor.bounds!.width * configuration.position.x, anchor.bounds!.height * configuration.position.y )
					alignmentOffset = ( self.bounds.width * alignment.x, self.bounds.height * alignment.y )
					
					//	Assign a position to the guide for each specified axis
					
					if configuration.axes.contains ( .vertical ) { position.x = .zero - origin.x - positionOffset.x + alignmentOffset.x }
					if configuration.axes.contains ( .horizontal ) { position.y = .zero - origin.y - positionOffset.y + alignmentOffset.y }
					
					//  Create the guide
					
					let guide: Self.ScrollGuide = .init ( position: position, id: configuration.id )
					
					//  Add the guide to the stack, only if it doesn't already exist
					
					if self.guides.allSatisfy ( { $0 != guide } ) { self.guides.insert ( guide ) }
					
				}
				
			}
			
		}
		
	}
	
	///	Calculates an appropriate translation from some gesture data based on the scroll boundaries of the stack.
	///
	///	- Parameters:
	///	  - content: The bounds of the content.
	///	  - within: The bounds of the stack.
	///	  - from: The current position of the stack.
	///	  - to: The gesture translation data.
	///
	private func translate ( _ content: CGFloat, within container: CGFloat, from position: CGFloat, to translation: CGFloat ) -> CGFloat {
		
		//  Switch over boundary conditions, and set the translation distance accordingly
		
		switch true {
				
				//  Check if the translation is within the allowed scrolling bounds
				
			case ( .zero - ( content - container ) ... .zero ) .contains ( position + translation ):
				
				//  Set the translation as the unmodified gesture translation
				
				return translation
				
				//  Check if the translation exceeds the leading or top scroll boundary
				
			case position + translation > .zero:
				
				//	Set the translation as the square root of the gesture translation
				
				return ( pow ( abs ( position + translation ) + 1.0, self.elasticity ) - 1.0 ) - position
				
				//  Check if the translation exceeds the trailing or bottom scroll boundary
				
			case position + translation < .zero - ( content - container ):
				
				//	Set the translation as the square root of the gesture translation
				
				return .zero - ( pow ( abs ( position + translation + ( content - container ) ) + 1.0, self.elasticity ) - 1.0 ) * self.elasticity - ( position + ( content - container ) )
				
				//	The calculations were wrong
				
			default: fatalError ( "Logic error." )
				
		}
		
	}
	
	/// Processes the response of a touch interaction.
	///
	/// - Parameters:
	///   - active: Whether or not the screen is being pressed.
	///   - translation: The gesture translation data.
	///   - predictedTranslation: The gesture translation prediction data.
	///
	private func react ( active: Bool, translation: CGSize?, predictedTranslation: CGSize? ) -> Void {
		
		//	Unwrap the gesture data
		
		let translation: CGSize = translation ?? .zero, predictedTranslation: CGSize = predictedTranslation ?? .zero
		
		//	Check if the content is being dragged
		
		if active {
			
			//	Stop the animation, setting the target to it's literal representation if necessary
			
			if self.position.x.target != self.position.x.literal { withAnimation ( .linear ( duration: .zero ) ) { self.position.x.target = self.position.x.literal } }
			if self.position.y.target != self.position.y.literal { withAnimation ( .linear ( duration: .zero ) ) { self.position.y.target = self.position.y.literal } }
			
			//	Check if scrolling is enabled for each axis, and calculate the translation
			
			if self.axes.contains ( .horizontal ) { self.translation.x = translate ( self.contentBounds.width, within: self.bounds.width, from: self.position.x.target, to: translation.width ) }
			if self.axes.contains ( .vertical ) { self.translation.y = translate ( self.contentBounds.height, within: self.bounds.height, from: self.position.y.target, to: translation.height ) }
			
			//	If the screen is not being dragged, check if there has been a translation change
			
		} else if self.translation.x != .zero || self.translation.y != .zero {
			
			//  Update the position to reflect the translation
			
			self.position.x.target += self.translation.x
			self.position.y.target += self.translation.y
			
			self.position.x.literal = self.position.x.target
			self.position.y.literal = self.position.y.target
			
			// 	Calculate the remaining translation
			
			let translation: ( x: CGFloat, y: CGFloat )
			
			translation.x = predictedTranslation.width - self.translation.x
			translation.y = predictedTranslation.height - self.translation.y
			
			// 	Calculate the scroll direction
			
			let direction: ( x: CGFloat, y: CGFloat )
			
			direction.x = translation.x > .zero ? 0.0 : 1.0
			direction.y = translation.y > .zero ? 0.0 : 1.0
			
			//	Scroll to the translation
			
			self._scrollTo ( translation: translation, direction: .init ( x: direction.x, y: direction.y ) )
			
			//	Set the translation to zero
			
			self.translation = ( .zero, .zero )
			
		}
		
	}
	
	///	Scrolls to the specified position.
	///
	///	- Parameter position: The position to scroll to.
	///
	public func scrollTo ( position: ( x: CGFloat, y: CGFloat ) ) -> Void { self._scrollTo ( position: position ) }
	
	///	Performs a translation on the scroll position.
	///
	///	- Parameter translation: The translation to perform.
	///
	public func scrollTo ( translation: ( x: CGFloat, y: CGFloat ) ) -> Void { self._scrollTo ( translation: translation ) }
	
	///	Scrolls to the guide with the specified identifier.
	///
	///	- Parameter id: The identifier of the guide to scroll to.
	///
	public func scrollTo ( id: String ) -> Void { self._scrollTo ( id: id ) }
	
	///	Scrolls to a position, a guide with the specified identifier, or applies a translation.
	///
	///	- Parameters:
	///	  - position: The position to scroll to.
	///	  - translation: The translation to perform.
	///	  - id: The identifier of the guide to scroll to.
	///	  - direction: The scroll direction to bias the snap guide selection with.
	///
	private func _scrollTo ( position: ( x: CGFloat, y: CGFloat )? = nil, translation: ( x: CGFloat, y: CGFloat )? = nil, id: ( String )? = nil, direction: UnitPoint? = nil ) -> Void {
		
		//	Stop the animation, setting the target to it's literal representation if necessary
		
		if self.position.x.target != self.position.x.literal { withAnimation ( .linear ( duration: .zero ) ) { self.position.x.target = self.position.x.literal } }
		if self.position.y.target != self.position.y.literal { withAnimation ( .linear ( duration: .zero ) ) { self.position.y.target = self.position.y.literal } }
		
		//	Declare a mutated position
		
		var mutatedPosition: ( x: CGFloat, y: CGFloat )
		
		//	Retrieve all the guides with the specified identifier if applicable, and return if none exist
		
		let guides: Set < Self.ScrollGuide > = id != nil ? self.guides.filter { $0.id == id! } : self.guides
		if id != nil { guard !guides.isEmpty else { return } }
		
		//	Consolidate input data into a projected position
		
		let projectedPosition: ( x: CGFloat, y: CGFloat )
		
		projectedPosition.x = position?.x ?? ( translation != nil ? self.position.x.target + translation!.x : nil ) ?? self.position.x.target
		projectedPosition.y = position?.y ?? ( translation != nil ? self.position.y.target + translation!.y : nil ) ?? self.position.y.target
		
		//  Define a comparator function that finds the nearest guide
		
		let compare: ( _ guide: ( lhs: CGFloat?, rhs: CGFloat? ), _ currentPosition: CGFloat, _ projectedPosition: CGFloat, _ direction: CGFloat? ) -> Bool = { guide, currentPosition, projectedPosition, direction in
			
			//	Return if either guide position is nil, deprioritizing the nil values
			
			guard let lhs = guide.lhs else { return false }
			guard let rhs = guide.rhs else { return true }
			
			//	If directional snapping is enabled, a direction is provided, and the guide position is not in the specified direction from the current position, deprioritize the guide
			
			if self.directional, let direction = direction, ( direction > 0.5 && lhs > currentPosition ) || ( direction < 0.5 && lhs < currentPosition ) { return false }
			
			//	Mutate the guide positions by subtracting the projected position, and returning the comparison result
			
			return abs ( lhs - projectedPosition ) < abs ( rhs - projectedPosition )
			
		}
		
		//  Retrieve the position of the nearest guide, reverting to the projected position if nil
		
		mutatedPosition.x = guides.min ( by: { compare ( ( $0.position.x, $1.position.x ), self.position.x.target, projectedPosition.x, direction?.x ) } )? .position.x ?? projectedPosition.x
		mutatedPosition.y = guides.min ( by: { compare ( ( $0.position.y, $1.position.y ), self.position.y.target, projectedPosition.y, direction?.y ) } )? .position.y ?? projectedPosition.y
		
		//	If an identifier was not provided, and if the mutated position is not within the snap tolerance, revert to the projected position
		
		if id == nil && !( projectedPosition.x - self.tolerance ... projectedPosition.x + self.tolerance ) .contains ( mutatedPosition.x ) { mutatedPosition.x = projectedPosition.x }
		if id == nil && !( projectedPosition.y - self.tolerance ... projectedPosition.y + self.tolerance ) .contains ( mutatedPosition.y ) { mutatedPosition.y = projectedPosition.y }
		
		//	Clamp the position values within the bounds of the content
		
		mutatedPosition.x.clamp ( in: .zero - ( self.contentBounds.width - self.bounds.width ) ... .zero )
		mutatedPosition.y.clamp ( in: .zero - ( self.contentBounds.height - self.bounds.height ) ... .zero )
		
		//	Calculate the duration of the animation
		
		let duration: CGFloat = max ( ( sqrt ( abs ( mutatedPosition.x - self.position.x.target ) + 1.0 ) - 1.0 ) / ( 10.0 * self.deceleration ), ( sqrt ( abs ( mutatedPosition.y - self.position.y.target ) + 1.0 ) - 1.0 ) / ( 10.0 * self.deceleration ) ) .clamped ( in: 0.0 ... self.maxDuration )
		
		//	Animate to the mutated position
		
		if self.axes.contains ( .horizontal ) { withAnimation ( self.animation? ( duration ) ?? defaults.animations.expoOut ( duration: duration ) ) { self.position.x.target = mutatedPosition.x } }
		if self.axes.contains ( .vertical ) { withAnimation ( self.animation? ( duration ) ?? defaults.animations.expoOut ( duration: duration ) ) { self.position.y.target = mutatedPosition.y } }
		
	}
	
	/// Creates an ``SDSStack``.
	///
	/// - Parameters:
	///   - axes: The scrollable axes of the stack.
	///   - snaps: Enables scroll snapping.
	///   -	tolerance: The threshold between the scroll position and a guide before snap engagement.
	///   - directional: Snap exclusively in the direction of the scroll movement.
	///   - deceleration: The speed to decelerate scrolling content at.
	///   - maxDuration: The maximum duration to decelerate for.
	///   - elasticity: A number representing the stretch factor when dragging outside the bounds of the scroll content.
	///   - id: An identifier for the stack.
	///   - animation: A closure that accepts a duration relative to the scroll translation, and returns an animation to use when decelerating content.
	///   - content: The content of the stack.
	///
	public init ( axes: [ Axis.Set ] = [ .vertical ], snaps: Bool = true, tolerance: CGFloat = 256.0, directional: Bool = true, deceleration: CGFloat = 1.0, maxDuration: CGFloat = 4.0, elasticity: CGFloat = 0.875, id: String = UUID ( ) .uuidString, animation: ( ( _ duration: CGFloat ) -> Animation )? = nil, @ViewBuilder content: @escaping ( Self ) -> Content ) {
		
		self.id = id
		self.axes = axes
		self.snaps = snaps
		self.tolerance = tolerance
		self.directional = directional
		self.deceleration = deceleration
		self.maxDuration = maxDuration
		self.elasticity = elasticity
		self.animation = animation
		self.content = content
		
	}
	
}

/// Contains an anchor source, the relative bounds of the anchor, and a collection of guide configurations.
///
@available ( iOS 16.0, * )
private struct SDScrollAnchor: Equatable, Hashable, Identifiable {
	
	/// An identifier for the scroll anchor.
	///
	fileprivate let id: UUID = .init ( )
	
	/// An anchor containing the view's bounds.
	///
	fileprivate let source: Anchor < CGRect >
	
	/// The guide configurations for the anchor.
	///
	fileprivate let configurations: [ ( position: UnitPoint, axes: [ Axis.Set ], alignments: [ UnitPoint ], id: String ) ]
	
	/// The identifier of the associated ``SDSStack``.
	///
	fileprivate let stackID: String?
	
	/// The relative bounds of the anchor.
	///
	fileprivate var bounds: CGRect? = nil
	
	/// Assigns relative bounds to the anchor.
	///
	/// - Parameter bounds: The bounds to set.
	///
	fileprivate mutating func resolved ( with proxy: GeometryProxy ) -> Self {
		
		self.bounds = proxy [ self.source ]
		return self
		
	}
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	fileprivate static func == ( lhs: SDScrollAnchor, rhs: SDScrollAnchor ) -> Bool { return lhs.id == rhs.id }
	
	/// A hasher for hashable conformance.
	///
	/// - Parameter into: The hasher used to hash the value.
	///
	fileprivate func hash ( into hasher: inout Hasher ) { hasher.combine ( self.id ) }
	
	/// Creates a ``SDScrollAnchor`` from an anchor source, a set of guide configurations, and a stack identifier.
	///
	/// - Parameters:
	///   - source: An anchor containing the view's bounds.
	///   - configurations: The guide configurations for the anchor.
	///   - stackID: The identifier of the associated ``SDSStack``.
	///
	fileprivate init ( source: Anchor < CGRect >, configurations: [ ( position: UnitPoint, axes: [ Axis.Set ], alignments: [ UnitPoint ], id: String ) ], stackID: String? = nil ) {
		
		self.source = source
		self.configurations = configurations
		self.stackID = stackID
		
	}
	
}

/// Contains a collection of scroll anchors.
///
@available ( iOS 16.0, * )
private struct SDScrollAnchors: PreferenceKey {
	
	/// An empty collection of scroll anchors.
	///
	static var defaultValue: Set < SDScrollAnchor > = .init ( )
	
	/// Inserts new values into the preference key.
	///
	static func reduce ( value: inout Set < SDScrollAnchor >, nextValue: ( ) -> Set < SDScrollAnchor > ) { value.formUnion ( nextValue ( ) ) }
	
	/// Creates a ``SDScrollAnchors`` key.
	///
	fileprivate init ( ) { }
	
}

//
//

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Sets a scroll anchor for the view.
	///
	/// - Parameters:
	///   - source: The source of the anchor rect.
	///   - configurations: The guide configurations for the anchor.
	///   - stackID: The identifier of the associated ``SDSStack``.
	///
	func scrollAnchor ( _ source: Anchor < CGRect > .Source = .bounds, configurations: ( position: UnitPoint, axes: [ Axis.Set ], alignments: [ UnitPoint ], id: String )..., stackID: String? = nil ) -> some View { anchorPreference ( key: SDScrollAnchors.self, value: source ) { [ .init ( source: $0, configurations: configurations, stackID: stackID ) ] } }
	
}

//
//

