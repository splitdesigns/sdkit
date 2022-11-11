
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
public class SDSystem { }

//	MARK: - Extensions

@available ( iOS 16.0, * )
public extension SDSystem {
	
	/// Responsible for managing coordination for your app.
	///
	class Coordinator: ObservableObject {
		
		/// The current view hierarchy.
		///
		@Published public var flow: SDFlow
		
		/// Creates a `Coordinator`.
		///
		public init ( flow: SDFlow ) {
			
			self.flow = flow
			
		}
		
	}
	
}
