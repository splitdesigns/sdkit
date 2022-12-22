
//
//  SDKit: Sequenced Animation
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// An intuitive API for sequencing SwiftUI animations.
///
/// To create a sequence, initialize an ``SDSequencedAnimation``, and append animations directly using ``SDSequencedAnimation/append(with:performing:)``.
///
/// A default animation configuration can be set when initialized, or using ``SDSequencedAnimation/set(configuration:)``. The configuration of a sequenced animation can always be overwritten inside the ``SDSequencedAnimation/append(with:performing:)`` method.
///
/// Use ``SDSequencedAnimation/wait(for:)`` to create a delay before the next animation, or ``SDSequencedAnimation/repeat(times:)`` to loop the animation sequence.
///
/// Finally, use the ``SDSequencedAnimation/start()`` method to start the animation.
///
///		/// The amount to offset the content.
///		///
///		@State private var offset: CGFloat = 0.0
///
///		...
///
///		Text ( "Hello, world!" )
///			.offset ( x: self.offset )
///			.onAppear {
///
///				SDSequencedAnimation ( )
///					.append { self.offset = 32.0 }
///					.append ( with: .init ( duration: 2.0, delay: 0.0 ) ) { self.offset = -32.0 }
///					.append { self.offset = 0.0 }
///					.repeat ( times: 2 )
///					.wait ( for: 2.0 )
///					.set ( configuration: .init ( duration: 2.0, delay: 1.0, timingCurve: { return self.defaults.animations.primary ( $0 ) } ) )
///					.append { self.offset = 64.0 }
///					.append ( with: .init ( duration: 4.0, delay: 1.0 ) ) { self.offset = -64.0 }
///					.append { self.offset = 0.0 }
///					.start ( )
///
///			}
///
/// - Note: The ``SDSequencedAnimation`` callback is asynchronous, so it may be executed slightly after the animation finishes.
///
/// - Warning: Initializing a configuration with a duration of zero will break the animation.
///
@available ( iOS 16.0, * )
public class SDSequencedAnimation {
	
	/// A configuration for a sequence animation.
	///
	public struct Configuration {
		
		/// The duration of the animation.
		///
		fileprivate var duration: CGFloat?
		
		/// The duration of the delay before animating.
		///
		fileprivate var delay: CGFloat?
		
		/// Accepts a duration and returns a timing curve for animating value changes.
		///
		fileprivate var timingCurve: ( ( _ duration: CGFloat ) -> Animation )?
		
		/// Creates an ``SDSequencedAnimation/Configuration`` instance from an action configuration.
		///
		/// - Parameters:
		///   - duration: The duration of the animation.
		///   - delay: The duration of the delay before animating.
		///   - timingCurve: Accepts a duration and returns a timing curve for animating value changes.
		///
		public init ( duration: CGFloat? = nil, delay: CGFloat? = nil, timingCurve: ( ( _ duration: CGFloat ) -> Animation )? = nil ) {
			
			self.duration = duration
			self.delay = delay
			self.timingCurve = timingCurve
			
		}
		
	}
	
	/// A default configuration for sequenced animations.
	///
	private var configuration: Configuration
	
	/// The animation sequence.
	///
	private var sequence: [ ( configuration: Configuration, action: ( ( ) -> Void )? ) ] = .init ( )
	
	/// An action to perform when the animation has completed.
	///
	private var callback: ( ( ) -> Void )?
	
	/// Appends an animation to the sequence.
	///
	/// - Parameters:
	///   - with: The animation configuration.
	///   - perform: The action to animate.
	///
	@discardableResult public func append ( with configuration: Configuration? = nil, performing action: @escaping ( ) -> Void ) -> Self {
		
		//	Unwrap the configuration
		
		var configuration = configuration ?? self.configuration
			
		//	If a property doesn't exist, overwrite it with the matching property from the default configuration
		
		if configuration.duration == nil { configuration.duration = self.configuration.duration }
		if configuration.delay == nil { configuration.delay = self.configuration.delay }
		if configuration.timingCurve == nil { configuration.timingCurve = self.configuration.timingCurve }
					
		//	Append the new animation
		
		self.sequence.append ( ( configuration, action ) )
		
		//	Return the sequenced animation
		
		return self
		
	}
	
	///	Repeats the existing sequence for a specified number of repetitions.
	///
	/// - Parameter times: The number of times to repeat the sequence.
	///
	@discardableResult public func `repeat` ( times repetitions: Int ) -> SDSequencedAnimation {
		
		//	Copy the unmodified sequence, and append it multiple times to the sequence
		
		let unmodifiedSequence: [ ( configuration: Configuration, action: ( ( ) -> Void )? ) ] = self.sequence
		for _ in .zero ..< repetitions { self.sequence.append ( contentsOf: unmodifiedSequence ) }
		
		//	Return the sequenced animation
		
		return self
		
	}
	
	/// Appends an empty animation with a delay.
	///
	/// - Parameter for: The delay duration.
	///
	@discardableResult public func wait ( for duration: CGFloat ) -> SDSequencedAnimation {
		
		//	Append an empty animation
		
		self.sequence.append ( ( .init ( duration: .zero, delay: duration ), nil ) )
		
		//	Return the sequenced animation
		
		return self
		
	}
	
	/// Sets a property for the animation sequence.
	///
	/// - Parameters:
	///   - configuration: Sets the default configuration for sequenced animations.
	///   - callback: An action to perform when the animation has completed.
	///
	@discardableResult public func set ( configuration: Configuration? = nil, callback: ( ( ) -> Void )? = nil ) -> SDSequencedAnimation {
		
		//	If a configuration was provided and a property exists, overwrite that property on the default configuration
		
		if let duration = configuration?.duration { self.configuration.duration = duration }
		if let delay = configuration?.delay { self.configuration.delay = delay }
		if let timingCurve = configuration?.timingCurve { self.configuration.timingCurve = timingCurve }
		
		//	If a callback was provided, set it on the sequenced animation
		
		if let callback = callback { self.callback = callback }

		//	Return the sequenced animation
		
		return self
		
	}
	
	/// Starts the animation sequence.
	///
	public func start ( ) -> Void {
		
		//	Initialize a variable to store the accumulated time
		
		var time: CGFloat = .zero
		
		//	Iterate over the sequenced animations
		
		for animation in self.sequence {
			
			//	Add the delay to the time
			
			time += animation.configuration.delay ?? .zero
			
			//	Performs the action with an animation
			
			withAnimation ( ( animation.configuration.timingCurve ?? { return .linear ( duration: $0 ) } ) ( animation.configuration.duration ?? 1.0 ) .delay ( time ) ) { animation.action? ( ) }
			
			//	Add the duration to the time
			
			time += animation.configuration.duration ?? 1.0
			
		}
		
		//	Schedule the callback
		
		DispatchQueue.main.asyncAfter ( deadline: .now ( ) + time ) { self.callback? ( ) }
		
		return
		
	}
	
	/// Creates an ``SDSequencedAnimation`` instance from a configuration.
	///
	/// - Parameter configuration: A default configuration for sequenced animations.
	///
	public init ( configuration: Configuration = .init ( ) ) { self.configuration = configuration }
	
}

//
//
