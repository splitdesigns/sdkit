
//
//  SDKit: State Observer
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Performs an action when a state change on a value is observed.
///
@available ( iOS 16.0, * )
public struct SDStateObserver: ViewModifier {
	
	///	The state describing a value.
	///
	public enum ValueState: String, CaseIterable { case unchanged, changed }
	
	/// The values to observe.
	///
	private let values: [ SDBox ]
	
	/// The state of the values to use in the action closure.
	///
	private let useState: Self.ValueState
	
	/// The action to perform when a change is detected.
	///
	private let action: ( ) -> Void
	
	/// Whether or not to perform the action.
	///
	@State private var isChanged: Bool = .init ( )
	
	///	Detects value changes, and stores the observation in the `isChanged` property. Doing so performs the action on the next body invocation, providing the ability to use the new values inside the action.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.onChange ( of: self.values ) { _ in if self.useState == .unchanged { self.action ( ) } else { self.isChanged.toggle ( ) } }
			.onChange ( of: self.isChanged ) { if $0 && useState == .changed {
				
				// Run the action on the next body invocation, and set the state to false
				
				self.action ( )
				self.isChanged.toggle ( )
				
			} }
			.onAppear ( perform: self.action )
		
	}
	
	/// Creates a ``SDStateObserver`` from a collection of values and an update closure.
	///
	/// - Parameters:
	///   - for: The values to observe.
	///   - usingState: The state of the values to use in the action closure.
	///   - compare: Whether or not to compare the values for equality before performing the action.
	///   - onChange: The action to perform when a value has changed.
	///
	public init ( for values: Any?..., usingState useState: Self.ValueState = .changed, compare: Bool, onChange action: @escaping ( ) -> Void ) {
		
		self.values = .init ( repeating: .init ( nil, unique: !compare ), count: values.count ) .enumerated ( ) .map { .init ( values [ $0.offset ] ) }
		self.useState = useState
		self.action = action
		
	}
	
}

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Performs an action when some values are created or mutated, regardless of their value.
	///
	/// - Parameters:
	///   - values: The values to observe.
	///   - usingState: The state of the values to use in the action closure.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate ( of values: Any?..., usingState useState: SDStateObserver.ValueState = .changed, perform action: @escaping ( ) -> Void ) -> some View { return self.modifier ( SDStateObserver ( for: values, usingState: useState, compare: false, onChange: action ) ) }
	
	/// Performs an action when some values are created or mutated to a different value.
	///
	/// - Parameters:
	///   - values: The values to observe.
	///   - usingState: The state of the values to use in the action closure.
	///   - perform: The action to run when a mutation is observed.
	///
	func onMutation ( of values: Any?..., usingState useState: SDStateObserver.ValueState = .changed, perform action: @escaping ( ) -> Void ) -> some View { return self.modifier ( SDStateObserver ( for: values, usingState: useState, compare: true, onChange: action ) ) }
	
}

//
//
