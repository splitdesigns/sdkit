
//
//  SDKit: Stacks And Spacers
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Structures

/// A view that arranges its subviews in a horizontal line, with default spacing set to zero.
///
@available ( iOS 16.0, * )
public struct SDXStack < Content: View > : View {
    
    /// The guide for aligning the subviews in this stack. This guide has the same vertical screen coordinate for every subview.
    ///
    private let alignment: VerticalAlignment
    
    /// The distance between adjacent subviews, or nil if you want the stack to choose a default distance for each pair of subviews.
    ///
    private let spacing: CGFloat
    
    /// A view builder that creates the content of this stack.
    ///
    private let content: ( ) -> Content

    /// The main view of the ``SDXStack`` struct.
    ///
    public var body: some View { return HStack ( alignment: alignment, spacing: spacing ) { content ( ) } }
    
    /// A public initializer for the ``SDXStack`` struct.
    ///
    public init ( alignment: VerticalAlignment = .center, spacing: CGFloat = .init ( ), @ViewBuilder content: @escaping ( ) -> Content ) {
        
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
        
    }
    
}

/// A view that arranges its subviews in a vertical line, with default spacing set to zero.
///
@available ( iOS 16.0, * )
public struct SDYStack < Content: View > : View {
    
    /// The guide for aligning the subviews in this stack. This guide has the same vertical screen coordinate for every subview.
    ///
    private let alignment: HorizontalAlignment
    
    /// The distance between adjacent subviews, or nil if you want the stack to choose a default distance for each pair of subviews.
    ///
    private let spacing: CGFloat
    
    /// A view builder that creates the content of this stack.
    ///
    private let content: ( ) -> Content
    
    /// The main view of the ``SDYStack`` struct.
    ///
    public var body: some View { return VStack ( alignment: alignment, spacing: spacing ) { content ( ) } }
    
    /// A public initializer for the ``SDYStack`` struct.
    ///
    public init ( alignment: HorizontalAlignment = .center, spacing: CGFloat = .init ( ), @ViewBuilder content: @escaping ( ) -> Content ) {
        
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
        
    }
    
}

/// A scrollable view that wraps an ``SDXStack`` or ``SDYStack``, depending on the orientation.
///
@available ( iOS 16.0, * )
public struct SDSStack < Content: View > : View {

    /// The scroll view’s scrollable axis. The default axis is the vertical axis.
    ///
    private let axis: Axis.Set
    
    /// A Boolean value that indicates whether the scroll view displays the scrollable component of the content offset, in a way suitable for the platform. The default value for this parameter is false.
    ///
    private let showsIndicators: Bool
    
    /// The view builder that creates the scrollable view.
    ///
    private let content: ( ) -> Content
    
    /// The main view of the ``SDSStack`` struct.
    ///
    public var body: some View { return ScrollView ( axis, showsIndicators: showsIndicators ) { if axis == .horizontal { SDXStack { content ( ) } } else { SDYStack { content ( ) } } } }
    
    /// A public initializer for the ``SDSStack`` struct.
    ///
    public init ( axis: Axis.Set = .vertical, showsIndicators: Bool = false, @ViewBuilder content: @escaping ( ) -> Content ) {
        
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
        
    }

}

/// A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack. Minimum spacing defaults to zero.
///
@available ( iOS 16.0, * )
public struct SDNothing: View {
    
    /// The minimum amount of space to consume.
    ///
    private let except: CGFloat
    
    /// The main view of the ``SDNothing`` struct.
    ///
    public var body: some View { return Spacer ( minLength: except ) }
    
    /// A public initializer for the ``SDNothing`` struct.
    ///
    public init ( except: CGFloat = .init ( ) ) { self.except = except }
    
}

//
//
