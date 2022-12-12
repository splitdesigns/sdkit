
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

    /// Creates an `HStack` with the spacing defaulted to zero.
    ///
	public var body: some View { return HStack ( alignment: self.alignment, spacing: self.spacing ) { self.content ( ) } }
    
    /// Creates a ``SDXStack`` from some sensible defaults.
	///
	/// - Parameters:
	///   - alignment: Sets the alignment of the stack.
	///   - spacing: Sets the spacing of the stack.
	///   - content: Contains the content of the stack.
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
    
    /// Creates an `VStack` with the spacing defaulted to zero.
    ///
	public var body: some View { return VStack ( alignment: self.alignment, spacing: self.spacing ) { self.content ( ) } }
    
    /// Creates a ``SDYStack`` from some sensible defaults.
	///
	/// - Parameters:
	///   - alignment: Sets the alignment of the stack.
	///   - spacing: Sets the spacing of the stack.
	///   - content: Contains the content of the stack.
	///
    public init ( alignment: HorizontalAlignment = .center, spacing: CGFloat = .init ( ), @ViewBuilder content: @escaping ( ) -> Content ) {
        
        self.alignment = alignment
        self.spacing = spacing
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
	public var body: some View { return Spacer ( minLength: self.except ) }
    
    /// Creates a ``SDNothing`` from some sensible defaults.
	///
	/// - Parameter except: The spacing exception.
    ///
    public init ( except: CGFloat = .init ( ) ) { self.except = except }
    
}

//
//
