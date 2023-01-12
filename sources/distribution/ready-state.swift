
//
//  SDKit: Ready State
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Sets the readiness state of the application.
///
@available ( iOS 16.0, * )
public struct SDIsReady: ViewModifier {
	
	/// Access to the defaults object.
	///
	@EnvironmentObject private var defaults: SDDefaults
	
	/// The readiness state to set.
	///
	private let readyState: Bool
	
	/// The delay after the view appears before the ready state is set.
	///
	private let initialDelay: CGFloat
	
	///	A lock that prevents changes from being written to the application's readiness state.
	///
	@State private var isLocked: Bool = true
	
	/// Sets the readiness state of the application after an initial delay.
	///
	public func body ( content: Content ) -> some View {
		
		content
			.onAppear { if self.initialDelay != .zero { DispatchQueue.main.asyncAfter ( deadline: .now ( ) + self.initialDelay ) { self.isLocked = false } } else { self.isLocked = false } }
			.onUpdate ( of: self.isLocked, or: self.readyState ) { if !$0 { self.defaults.coordination.isReady = $1 } }
		
	}
	
	/// Creates an ``SDIsReady`` instance.
	///
	/// - Parameters:
	///   - readyState: The readiness state to set.
	///   - initialDelay: The delay after the view appears before the ready state is set.
	///
	public init ( _ readyState: Bool, initialDelay: CGFloat = .zero ) {
		
		self.readyState = readyState
		self.initialDelay = initialDelay
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Sets the readiness state of the application.
	///
	/// - Parameters:
	///   - readyState: The readiness state to set.
	///   - initialDelay: The delay after the view appears before the ready state is set.
	///
	func isReady ( _ readyState: Bool, initialDelay: CGFloat = .zero ) -> some View { self.modifier ( SDIsReady ( readyState, initialDelay: initialDelay ) ) }
	
}

//
//
