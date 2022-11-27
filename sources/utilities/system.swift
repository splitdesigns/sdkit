
//
//  SDKit: System
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Classes

/// Manages state for the app.
/// 
@available ( iOS 16.0, * )
public final class SDSystem {
	
	/// A static instance of ``SDKit`` for use outside of the view environment.
	///
	public static var defaults: SDDefaults = .init ( )
	
}

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension SDSystem {
	
	/// Responsible for coordinating your app.
	///
	class Coordinator: ObservableObject {
		
		/// The current view hierarchy.
		///
		@SDPublishedWithAnimation public var flow: SDFlow
		
		/// Whether or not the application has launched.
		/// 
		@Published public var launched: Bool = .init ( )
		
		/// Creates a `Coordinator`.
		///
		/// - Parameter flow: Initializes a flow.
		///
		public init ( flow: SDPublishedWithAnimation < SDFlow > ) { self._flow = flow }
		
	}
	
}

//
//
