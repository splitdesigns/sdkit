//
//  SDKit: Animated Publisher
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import Combine
import SwiftUI

//
//

//  MARK: - Structures

/// Publishes a property of a class with an animation.
///
@available ( iOS 16.0, * )
@propertyWrapper public struct SDPublishedWithAnimation < Value > {
	
	/// The wrapped value for the property wrapper.
	///
	@available ( *, unavailable, message: "`@PublishedWithAnimation` can only be defined on properties of classes." )
	public var wrappedValue: Value {
		
		get { fatalError ( "WrappedValue is unavailable for `@PublishedWithAnimation`." ) }
		set { fatalError ( "WrappedValue is unavailable for `@PublishedWithAnimation`." ) }
		
	}
	
	/// The value to store.
	///
	private var value: Value
	
	/// The animation curve to animate changes with.
	///
	public var animation: Animation?
	
	/// Provides access to properties of the enclosing instance.
	///
	/// - Parameter _enclosingInstance: The enclosing container.
	/// - Parameter wrapped: The `KeyPath` to the instance's wrapped value.
	/// - Parameter storage: The `KeyPath` to the property wrapper's storage.
	///
	public static subscript < Container: ObservableObject > (
		
		_enclosingInstance enclosingInstance: Container,
		wrapped wrappedValueKeyPath: ReferenceWritableKeyPath < Container, Value > ,
		storage propertyWrapperKeyPath: ReferenceWritableKeyPath < Container, Self >
		
	) -> Value {
		
		get { enclosingInstance [ keyPath: propertyWrapperKeyPath ] .value }
		
		set {
			
			withAnimation ( enclosingInstance [ keyPath: propertyWrapperKeyPath ] .animation ) { ( enclosingInstance.objectWillChange as! ObservableObjectPublisher ) .send ( ) }
			enclosingInstance [keyPath: propertyWrapperKeyPath ] .value = newValue
			
		}
	}
	
	/// Creates a ``PublishedWithAnimation`` wrapping the property.
	///
	/// - Parameter wrappedValue: The value to store.
	/// - Parameter animation: The timing curve to animate the value with.
	///
	public init ( wrappedValue: Value, animation: Animation? = nil ) {
		
		self.value = wrappedValue
		self.animation = animation
		
	}
	
}

//
//