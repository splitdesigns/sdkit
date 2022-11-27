
//
//  SDKit: Launch
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// Shows some content on application launch.
///
@available ( iOS 16.0, * )
public struct SDLaunch < Content: View > : View {
	
	/// Access to the application's coordination manager.
	///
	@EnvironmentObject private var coordinator: SDSystem.Coordinator
	
	/// Access to the `SDDefaults` configuration.
	///
	@Environment ( \ .defaults ) private var defaults
	
	/// The number of seconds to show the launch screen.
	///
	private let duration: CGFloat?
	
	/// The path to redirect to when the launch finishes.
	///
	private let redirect: String?
	
	/// The content to show on launch.
	///
	private let content: ( ) -> Content
	
	/// Displays the app icon for a certain period of time.
	///
	public var body: some View {
		
		content ( )
			.onAppear { if let duration = self.duration, !self.coordinator.launched { DispatchQueue.main.asyncAfter ( deadline: .now ( ) + duration ) { self.coordinator.launched = true } } }
			.task ( id: self.coordinator.launched ) { if self.coordinator.launched { self.coordinator.flow.move ( .to ( hierarchy: self.redirect ?? "/" ) ) } }
		
	}
	
	/// Creates an ``SDLaunch`` from a duration and some content.
	///
	/// - Parameters:
	///   - duration: The number of seconds to show the launch screen.
	///   - redirect: The path to redirect to when the launch finishes.
	///   - content: The content to show on launch.
	///
	public init ( duration: CGFloat? = nil, redirect: String? = nil, @ViewBuilder content: @escaping ( ) -> Content ) {
		
		self.duration = duration
		self.redirect = redirect
		self.content = content
		
	}
	
}

//
//
