
//
//  SDKit: Mesh Gradient
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SceneKit
import SwiftUI

//
//

//  MARK: - Structures

/// A gradient mesh with animatable distortion for creating visual effects.
///
/// - Warning: ``SDMeshGradient`` is an experimental API, and performance heavy. Usage in production is not recommended.
///
@available ( iOS 16.0, * )
public struct SDMeshGradient: View, Equatable {
	
	/// A collection of elements represented as a two-dimensional grid.
	///
	fileprivate struct Matrix < Element > {
		
		/// The contents of the grid.
		///
		public var elements: ContiguousArray < Element >
		
		/// The width of the grid.
		///
		public let width: Int
		
		/// The height of the grid.
		///
		public let height: Int
		
		/// Creates a grid from a default value and a width and height.
		///
		public init ( repeating element: Element, width: Int, height: Int ) {
			
			self.width = width
			self.height = height
			self.elements = .init ( repeating: element, count: self.width * self.height )
			
		}
		
		/// Provides coordinate-based access to grid elements.
		///
		public subscript ( x: Int, y: Int ) -> Element {
			
			get { self.elements [ x + y * self.width ] }
			set { self.elements [ x + y * self.width ] = newValue }
			
		}
		
	}
	
	/// A point on the mesh, represented by a material, position, and a pair of tangent vectors.
	///
	private struct ControlPoint {
		
		fileprivate var material: simd_float3 = .init ( 0, 0, 0 )
		fileprivate var position: simd_float2 = .init ( 0, 0 )
		fileprivate var uTangent: simd_float2 = .init ( 0, 0 )
		fileprivate var vTangent: simd_float2 = .init ( 0, 0 )
		
		/// Creates a zero-defaulted ``ControlPoint``.
		///
		fileprivate init ( ) { }
		
	}
	
	/// The colors to create the gradient from.
	///
	private let colors: [ Color ]?
	
	/// The width of the control point matrix.
	///
	private let width: Int
	
	/// The height of the control point matrix.
	///
	private let height: Int
	
	/// The number of times to subdivide each material patch.
	///
	private let subdivisions: Int
	
	/// The orientation of the mesh distortion.
	///
	private let distortion: Axis
	
	/// The intensity of the mesh distortion.
	///
	private let amplitude: CGFloat
	
	/// The position of the animation.
	///
	private let phase: CGFloat
	
	/// The target framerate of the animation.
	///
	private let fps: CGFloat
	
	/// The Hermite matrix.
	///
	private let H: simd_float4x4 = .init ( rows: [
		
		.init ( 2, -2, 1, 1 ),
		.init ( -3, 3, -2, -1 ),
		.init ( 0, 0, 1, 0 ),
		.init ( 1, 0, 0, 0 )
		
	] )
	
	/// The scene containing the mesh.
	///
	@State private var scene: SCNScene = .init ( )
	
	/// The number of colors in `colors`.
	///
	@State private var colorCount: Int? = nil
	
	/// A set of ordered indexes representing the randomized colors.
	///
	@State private var colorMap: [ Int ]? = nil
	
	/// The colors used by the mesh, represented as RGB values.
	///
	@State private var materialCache: [ [ CGFloat ] ]? = nil
	
	/// A cache of the randomized animation seed values.
	///
	@State private var seedCache: [ ( x: CGFloat, y: CGFloat, tx: CGFloat, ty: CGFloat ) ]? = nil
	
	/// The absolute time of the previous render.
	///
	@State private var lastRender: CGFloat = CFAbsoluteTimeGetCurrent ( )
	
	/// Creates a scene containing the gradient mesh.
	///
	public var body: some View {
		
		SceneView ( scene: self.scene )
			.onUpdate ( of: self.colors, or: self.width, or: self.height, or: self.subdivisions, or: self.distortion, or: self.amplitude, or: self.phase, or: self.fps ) { self.generate ( colors: $0, width: $1, height: $2, subdivisions: $3, distortion: $4, amplitude: $5, phase: $6, fps: $7 ) }
			.onUpdate ( of: self.colors ) { self.materialize ( from: $0, width: self.width, height: self.height ) }
		
	}
	
	/// A comparator for equatable conformance.
	///
	/// - Parameters:
	///   - lhs: The first value to compare.
	///   - rhs: The second value to compare.
	///
	public static func == ( lhs: SDMeshGradient, rhs: SDMeshGradient ) -> Bool { return rhs.colors == lhs.colors && rhs.width == lhs.width && rhs.height == lhs.height && rhs.subdivisions == lhs.subdivisions && rhs.distortion == lhs.distortion && rhs.amplitude == lhs.amplitude && rhs.phase == lhs.phase && rhs.fps == lhs.fps }
	
	/// Creates and configures a matrix of control points.
	///
	/// - Parameters:
	///   - colors: The colors to create the gradient from.
	///   - width: The width of the control point matrix.
	///   - height: The height of the control point matrix.
	///   - distortion: The orientation of the mesh distortion.
	///   - amplitude: The intensity of the mesh distortion.
	///   - phase: The position of the animation.
	///
	private func manipulate ( colors: [ Color ]?, width: Int, height: Int, distortion: Axis, amplitude: CGFloat, phase: CGFloat ) -> Self.Matrix < Self.ControlPoint > {
		
		//  Initialize a grid of control points
		
		var controlPoints: Self.Matrix < Self.ControlPoint > = .init ( repeating: Self.ControlPoint ( ), width: width, height: height )
		
		//	Check if the material cache is empty or if the grid size was updated, and process colors
		
		if self.materialCache == nil || self.materialCache?.count != controlPoints.elements.count { materialize ( from: colors, width: width, height: height ) }
		
		//	Check if the seed cache is empty or if the grid size was updated, and reinitialize the seed cache
		
		if self.seedCache == nil || self.seedCache?.count != controlPoints.elements.count { self.seedCache = .init ( ) }
		
		//  Loop over grid dimensions
		
		for y in 0 ..< controlPoints.height {
			
			for x in 0 ..< controlPoints.width {
				
				//  Set a material for the control point
				
				controlPoints [ x, y ] .material = .init (
					
					Float ( self.materialCache! [ y * controlPoints.width + x ] [ 0 ] ),
					Float ( self.materialCache! [ y * controlPoints.width + x ] [ 1 ] ),
					Float ( self.materialCache! [ y * controlPoints.width + x ] [ 2 ] )
					
				)
				
				//	Check if the seed cache contains the current point
				
				if !self.seedCache!.indices.contains ( [ y * controlPoints.width + x ] ) {
					
					//	Check if the current point is a boundary element of the matrix
					
					let edgePoint: Bool = ( y * controlPoints.width + x ) .isMatrixBoundaryElement ( width: controlPoints.width, height: controlPoints.height )
					
					//	Set the seed for the current point
					
					self.seedCache!.insert ( (
						
						edgePoint ? 0.0 : .random ( in: -1.0 ... 1.0 ),
						edgePoint ? 0.0 : .random ( in: -1.0 ... 1.0 ),
						edgePoint ? 0.0 : .random ( in: -1.0 ... 1.0 ),
						edgePoint ? 0.0 : .random ( in: -1.0 ... 1.0 )
						
					), at: y * controlPoints.width + x )
					
				}
				
				//	Create offsets for the control point position and tangent vectors
				
				var displacementX, displacementY, displacementTX, displacementTY: Float
				
				displacementX = Float ( sin ( Angle ( degrees: ( self.seedCache! [ y * controlPoints.width + x ] .x * phase * 360.0 ) .wrapped ( in: -360.0 ..< 360.0 ) ) .radians ) * amplitude / CGFloat ( controlPoints.width - 1 ) )
				displacementY = Float ( sin ( Angle ( degrees: ( self.seedCache! [ y * controlPoints.width + x ] .y * phase * 360.0 ) .wrapped ( in: -360.0 ..< 360.0 ) ) .radians ) * amplitude / CGFloat ( controlPoints.height - 1 ) )
				displacementTX = Float ( sin ( Angle ( degrees: ( self.seedCache! [ y * controlPoints.width + x ] .ty * phase * 360.0 ) .wrapped ( in: -360.0 ..< 360.0 ) ) .radians ) * amplitude * 2.0 )
				displacementTY = Float ( sin ( Angle ( degrees: ( self.seedCache! [ y * controlPoints.width + x ] .tx * phase * 360.0 ) .wrapped ( in: -360.0 ..< 360.0 ) ) .radians ) * amplitude * 2.0 )
				
				//  Set a position for the control point
				
				controlPoints [ x, y ] .position = .init (
					
					( ( Float ( x ) + displacementX ) / Float ( controlPoints.width - 1 ) ) .lerp ( in: -1.0 ... 1.0 ),
					( ( Float ( y ) + displacementY ) / Float ( controlPoints.height - 1 ) ) .lerp ( in: -1.0 ... 1.0 )
					
				)
				
				//  Set the tangents for the control point
				
				controlPoints [ x, y ] .uTangent.x = 2 / Float ( controlPoints.width - 1 ) * ( distortion == .horizontal ? displacementTX : 1.0 )
				controlPoints [ x, y ] .vTangent.x = 2 / Float ( controlPoints.width - 1 ) * ( distortion == .horizontal ? displacementTX : 0.0 )
				controlPoints [ x, y ] .uTangent.y = 2 / Float ( controlPoints.height - 1 ) * ( distortion == .vertical ? displacementTY : 0.0 )
				controlPoints [ x, y ] .vTangent.y = 2 / Float ( controlPoints.height - 1 ) * ( distortion == .vertical ? displacementTY: 1.0 )
				
			}
			
		}
		
		return controlPoints
		
	}
	
	///	Coordinates a set of materials from a collection of colors.
	///
	/// - Parameters:
	///   - colors: The colors to create the gradient from.
	///   - width: The width of the control point matrix.
	///   - height: The height of the control point matrix.
	///
	private func materialize ( from colors: [ Color ]?, width: Int, height: Int ) -> Void {
		
		//	Check for color additions, an uninitialized color map, and a change in grid size
		
		if colors?.count != self.colorCount || self.colorMap?.count != width * height {
			
			//	Check for colors
			
			if let colors = colors, !colors.isEmpty {
				
				//	Reinitialize the color map
				
				self.colorMap = .init ( )
				
				//	Loop over colors and append a random index
				
				for _ in 0 ..< width * height { self.colorMap!.append ( colors.indices.randomElement ( )! ) }
				
			} else {
				
				// Set color map to nil
				
				self.colorMap = nil
				
			}
			
		}
		
		//	Reinitialize the material cache
		
		self.materialCache = .init ( )
		
		//  Loop over the size of the control point matrix
		
		for index in 0 ..< width * height {
			
			//	Append the RGB values of each mapped color to the material cache, or a random color if the color map is `nil`
			
			self.materialCache!.append ( UIColor ( colors != nil && self.colorMap != nil ? colors! [ self.colorMap! [ index ] ] : [
				
				Color ( red: 255.0 / 255.0, green: 0.0 / 255.0, blue: 128.0 / 255.0 ), /* pink */
				Color ( red: 0.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0 ), /* blue */
				Color ( red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 0.0 / 255.0 ), /* orange */
				Color ( red: 128.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0 ) /* purple */
				
			] .randomElement ( )! ) .cgColor.components! )
			
		}
		
		//	Update the color count
		
		self.colorCount = colors?.count
		
		return
		
	}
	
	/// Creates a coefficient matrix for a mesh from the four neighboring control points of a patch.
	///
	/// - Parameters:
	///   - p00: The bottom left neighboring control point.
	///   - p01: The top left neighboring control point.
	///   - p10: The bottom right neighboring control point.
	///   - p11: The top right neighboring control point.
	///   - axis: A `KeyPath` that references the axis of the control point value.
	///
	private func meshCoefficients ( _ p00: Self.ControlPoint, _ p01: Self.ControlPoint, _ p10: Self.ControlPoint, _ p11: Self.ControlPoint, axis: KeyPath < simd_float2, Float > ) -> simd_float4x4 {
		
		/// Retrieves a `position` value from the specified location.
		///
		/// - Parameter controlPoint: The control point to get the value from.
		///
		func position ( _ controlPoint: Self.ControlPoint ) -> Float { return controlPoint.position [ keyPath: axis ] }
		
		/// Retrieves a `uTangent` value from the specified location.
		///
		/// - Parameter controlPoint: The control point to get the value from.
		///
		func uTangent ( _ controlPoint: Self.ControlPoint ) -> Float { return controlPoint.uTangent [ keyPath: axis ] }
		
		/// Retrieves a `vTangent` value from the specified location.
		///
		/// - Parameter controlPoint: The control point to get the value from.
		///
		func vTangent ( _ controlPoint: Self.ControlPoint ) -> Float { return controlPoint.vTangent [ keyPath: axis ] }
		
		//	Return the coefficient matrix
		
		return .init (
			
			rows: [
				
				.init ( position ( p00 ), position ( p01 ), vTangent ( p00 ), vTangent ( p01 ) ),
				.init ( position ( p10 ), position ( p11 ), vTangent ( p10 ), vTangent ( p11 ) ),
				.init ( uTangent ( p00 ), uTangent ( p01 ), 0, 0 ),
				.init ( uTangent ( p10 ), uTangent ( p11 ), 0, 0 )
				
			]
			
		)
		
	}
	
	/// Derives a boundary condition value for a mesh.
	///
	/// - Parameters:
	///   - u: The coordinate of the tangent vector along the horizontal edge.
	///   - v: The coordinate of the tangent vector along the horizontal edge.
	///   - X: The boundary condition matrix for the horizontal axis.
	///   - Y: The boundary condition matrix for the vertical axis.
	///
	private func meshPoint ( u: Float, v: Float, X: simd_float4x4, Y: simd_float4x4 ) -> simd_float2 {
		
		//	Calculate the vectors of the third to zeroth powers of u and v
		
		let U, V: simd_float4
		
		U = .init ( u * u * u, u * u, u, 1 )
		V = .init ( v * v * v, v * v, v, 1 )
		
		//	Return the point
		
		return .init (
			
			dot ( V, U * self.H * X * self.H.transpose ),
			dot ( V, U * self.H * Y * self.H.transpose )
			
		)
		
	}
	
	/// Creates a coefficient matrix for a material from the four neighboring control points of a patch.
	///
	/// - Parameters:
	///   - p00: The bottom left neighboring control point.
	///   - p01: The top left neighboring control point.
	///   - p10: The bottom right neighboring control point.
	///   - p11: The top right neighboring control point.
	///   - channel: A `KeyPath` that references the color channel of a control point's material.
	///
	private func materialCoefficients ( _ p00: Self.ControlPoint, _ p01: Self.ControlPoint, _ p10: Self.ControlPoint, _ p11: Self.ControlPoint, channel: KeyPath < simd_float3, Float > ) -> simd_float4x4 {
		
		/// Retrieves a `material` value from the specified location.
		///
		/// - Parameter controlPoint: The control point to get the value from.
		///
		func material ( _ controlPoint: Self.ControlPoint ) -> Float { return controlPoint.material [ keyPath: channel ] }
		
		//	Return the coefficient matrix
		
		return .init (
			
			rows: [
				
				.init ( material ( p00 ), material ( p01 ), 0, 0 ),
				.init ( material ( p10 ), material ( p11 ), 0, 0 ),
				.init ( 0, 0, 0, 0 ),
				.init ( 0, 0, 0, 0 )
				
			]
			
		)
		
	}
	
	/// Derives a boundary condition value for a material.
	///
	/// - Parameters:
	///   - u: The coordinate of the tangent vector along the horizontal edge.
	///   - v: The coordinate of the tangent vector along the horizontal edge.
	///   - R: The boundary condition matrix for the red color channel.
	///   - G: The boundary condition matrix for the green color channel.
	///   - B: The boundary condition matrix for the blue color channel.
	///
	private func materialPoint ( u: Float, v: Float, R: simd_float4x4, G: simd_float4x4, B: simd_float4x4 ) -> simd_float3 {
		
		//	Calculate the vectors of the third to zeroth powers of u and v
		
		let U, V: simd_float4
		
		U = .init ( u * u * u, u * u, u, 1 )
		V = .init ( v * v * v, v * v, v, 1 )
		
		//	Return the point
		
		return .init (
			
			dot ( V, U * H * R * H.transpose ),
			dot ( V, U * H * G * H.transpose ),
			dot ( V, U * H * B * H.transpose )
			
		)
		
	}
	
	/// Subdivides each patch in the grid arbitrarily to form a smooth surface.
	///
	/// - Parameters:
	///   - controlPoints: The control points to interpolate.
	///   - subdivisions: The number of times to subdivide each patch.
	///
	/// - Returns: A tuple containing the interpolated mesh and material.
	///
	private func interpolate ( controlPoints: Self.Matrix < Self.ControlPoint >, subdivisions: Int ) -> ( mesh: Self.Matrix < simd_float2 >, material: Self.Matrix < simd_float3 > ) {
		
		//	Initialize a mesh grid
		
		var mesh: Self.Matrix < simd_float2 > = .init (
			
			repeating: .init ( 0, 0 ),
			width: ( controlPoints.width - 1 ) * subdivisions,
			height: ( controlPoints.height - 1 ) * subdivisions
			
		)
		
		//	Initialize a material grid
		
		var material: Self.Matrix < simd_float3 > = .init (
			
			repeating: .init ( 0, 0, 0 ),
			width: ( controlPoints.width - 1 ) * subdivisions,
			height: ( controlPoints.height - 1 ) * subdivisions
			
		)
		
		//	Loop over the control point matrix
		
		for x in 0 ..< controlPoints.width - 1 {
			
			for y in 0 ..< controlPoints.height - 1 {
				
				//	Walk the grid of control points along each axis to obtain the four neighboring control points of a patch
				
				let p00, p01, p10, p11: Self.ControlPoint
				
				p00 = controlPoints [ x, y ]
				p01 = controlPoints [ x, y + 1 ]
				p10 = controlPoints [ x + 1, y ]
				p11 = controlPoints [ x + 1, y + 1 ]
				
				//	Obtain the coefficient matrices to resolve an arbitrary point on the patch
				
				let X, Y: simd_float4x4
				
				X = self.meshCoefficients ( p00, p01, p10, p11, axis: \ .x )
				Y = self.meshCoefficients ( p00, p01, p10, p11, axis: \ .y )
				
				//  The coefficient matrices for the current patch in RGB space
				
				let R, G, B: simd_float4x4
				
				R = self.materialCoefficients ( p00, p01, p10, p11, channel: \ .x )
				G = self.materialCoefficients ( p00, p01, p10, p11, channel: \ .y )
				B = self.materialCoefficients ( p00, p01, p10, p11, channel: \ .z )
				
				//	Loop over the matrix of subdivisions for the patch
				
				for ySD in 0 ..< subdivisions {
					
					for xSD in 0 ..< subdivisions {
						
						//  Update each mesh point with its coefficient matrices and tangent vectors
						
						mesh [ x * subdivisions + xSD, y * subdivisions + ySD ] = self.meshPoint (
							
							u: Float ( xSD ) / Float ( subdivisions - 1 ),
							v: Float ( ySD ) / Float ( subdivisions - 1 ),
							
							X: X,
							Y: Y
							
						)
						
						//  Update each material point with its coefficient matrices and tangent vectors
						
						material [ x * subdivisions + xSD, y * subdivisions + ySD ] = self.materialPoint (
							
							u: Float ( xSD ) / Float ( subdivisions - 1 ),
							v: Float ( ySD ) / Float ( subdivisions - 1 ),
							
							R: R,
							G: G,
							B: B
							
						)
						
					}
					
				}
				
			}
			
		}
		
		return ( mesh, material )
		
	}
	
	/// Derives geometry sources for a mesh and a material.
	///
	/// - Parameters:
	///   - mesh: The mesh to consolidate.
	///   - material: The material to consolidate.
	///   - distortion: The distorted axis.
	///
	/// - Returns: A tuple containing the consolidated mesh and material.
	///
	private func consolidate ( mesh: Self.Matrix < simd_float2 >, material: Self.Matrix < simd_float3 >, distortion: Axis ) -> ( mesh: [ simd_float3 ], material: [ simd_float3 ] ) {
		
		//  Initialize the geometry source arrays
		
		var sourceMesh, sourceMaterial: [ simd_float3 ]
		
		sourceMesh = .init ( repeating: .init ( ), count: mesh.elements.count * 6 )
		sourceMaterial = .init ( repeating: .init ( ), count: mesh.elements.count * 6 )
		
		//  Refactor the mesh and material matrix values into their respective source array for use as geometry sources
		
		for y in 0 ..< mesh.height - 1 {
			
			for x in 0 ..< mesh.width - 1 {
				
				//	Retrieve the mesh point values
				
				let p00, p01, p10, p11: simd_float2
				
				p00 = mesh [ x, y ]
				p10 = mesh [ x + 1, y ]
				p01 = mesh [ x, y + 1 ]
				p11 = mesh [ x + 1, y + 1 ]
				
				//	Initialize three-dimensional vertices from the two-dimensional mesh points
				
				let v00, v01, v10, v11: simd_float3
				
				v00 = .init ( p00.x, p00.y, 0.0 )
				v10 = .init ( p10.x, p10.y, 0.0 )
				v01 = .init ( p01.x, p01.y, 0.0 )
				v11 = .init ( p11.x, p11.y, 0.0 )
				
				//	Retrieve the material point values
				
				let m1, m2, m3, m4: simd_float3
				
				m1 = material [ x, y ]
				m2 = material [ x + 1, y ]
				m3 = material [ x , y + 1 ]
				m4 = material [ x + 1, y + 1 ]
				
				//	Encapsulate the mesh and material values
				
				let meshValues, materialValues: [ simd_float3 ]
				
				meshValues = [ v00, v10, v11, v11, v01, v00 ]
				materialValues = [ m1, m2, m4, m4, m3, m1 ]
				
				//	Modify the association order to aid in mitigating visual discrepancies
				
				let index: Int = distortion == .horizontal ? ( x * mesh.height + y ) : ( y * mesh.width + x )
				
				//	Loop over the mesh values
				
				for meshValue in meshValues.enumerated ( ) {
					
					//	Assign the mesh values to the source array
					
					sourceMesh [ index * meshValues.count + meshValue.offset ] = meshValue.element
					
				}
				
				//	Loop over the material values
				
				for materialValue in materialValues.enumerated ( ) {
					
					//	Assign the material values to the source array
					
					sourceMaterial [ index * materialValues.count + materialValue.offset ] = materialValue.element
					
				}
				
			}
			
		}
		
		return ( sourceMesh, sourceMaterial )
		
	}
	
	/// Renders a gradient mesh and adds it to the scene.
	///
	/// - Parameters:
	///   - colors: The colors to create the gradient from.
	///   - width: The width of the control point matrix.
	///   - height: The height of the control point matrix.
	///   - subdivisions: The number of times to subdivide each gradient patch.
	///   - distortion: The orientation of the mesh distortion.
	///   - amplitude: The intensity of the mesh distortion.
	///   - phase: The position of the animation.
	///   - fps: The target framerate of the animation.
	///
	private func generate ( colors: [ Color ]?, width: Int, height: Int, subdivisions: Int, distortion: Axis, amplitude: CGFloat, phase: CGFloat, fps: CGFloat ) -> Void {
		
		//	Get the current time
		
		let currentRender: CGFloat = CFAbsoluteTimeGetCurrent ( )
		
		//	If the current render is within the last frame, return, otherwise update the last render
		
		if currentRender - self.lastRender >= 1.0 / fps { self.lastRender = currentRender } else { return }
		
		//	Generate source geometry from the configuration
		
		let controlPoints: Self.Matrix < Self.ControlPoint > = self.manipulate ( colors: colors, width: width, height: height, distortion: distortion, amplitude: amplitude, phase: phase )
		let subdivided: ( mesh: Self.Matrix < simd_float2 >, material: Self.Matrix < simd_float3 > ) = self.interpolate ( controlPoints: controlPoints, subdivisions: subdivisions )
		let source: ( mesh: [ simd_float3 ], material: [ simd_float3 ] ) = self.consolidate ( mesh: subdivided.mesh, material: subdivided.material, distortion: distortion )
		
		//	Check if the gradient mesh node exists
		
		if let gradientMesh = self.scene.rootNode.childNode ( withName: "gradient-mesh", recursively: false ) {
			
			//	Update the geometry
			
			gradientMesh.geometry = SCNGeometry ( meshes: source.mesh, materials: source.material )
			
		} else {
			
			//	Create a node from the geometry
			
			let gradientMesh: SCNNode
			
			gradientMesh = .init ( geometry: SCNGeometry ( meshes: source.mesh, materials: source.material ) )
			gradientMesh.name = "gradient-mesh"
			
			//	Add the node to the scene
			
			self.scene.rootNode.addChildNode ( gradientMesh )
			
		}
		
		return
		
	}
	
	/// Creates a ``SDMeshGradient`` from a configuration.
	///
	/// - Parameters:
	///   - colors: The colors to create the gradient from.
	///   - width: The number of columns of control points to generate. Minimum of three columns.
	///   - height: The number of rows of control points to generate. Minimum of three rows.
	///   - subdivisions: The number of times to subdivide each gradient patch. Determines the resolution of the mesh.
	///   - distortion: The orientation of the mesh distortion.
	///   - amplitude: The intensity of the mesh distortion.
	///   - phase: The position of the animation.
	///   - fps: The target framerate of the animation.
	///
	public init ( colors: [ Color ]? = nil, width: Int = 4, height: Int = 4, subdivisions: Int = 16, distortion: Axis = .horizontal, amplitude: CGFloat = 0.5, phase: CGFloat = 0.0, fps: CGFloat = 30.0 ) {
		
		self.colors = colors
		self.width = max ( 3, width )
		self.height = max ( 3, height )
		self.subdivisions = max ( 0, subdivisions ) + 2
		self.distortion = distortion
		self.amplitude = amplitude.clamped ( in: -1.0 ... 1.0 )
		self.phase = phase
		self.fps = fps
		
	}
	
}

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
extension SDMeshGradient.Matrix: Equatable where Element: Equatable { }

@available ( iOS 16.0, * )
extension SDMeshGradient.Matrix: Hashable where Element: Hashable { }

@available ( iOS 16.0, * )
fileprivate extension SCNGeometrySource {
	
	/// Creates an `SCNGeometrySource` from an array of color values.
	///
	/// - Parameter colors: A collection of values, each representing the channels of an sRGB color.
	///
	convenience init ( colors: [ SCNVector3 ] ) {
		
		//	Create a data instance from the colors
		
		let colorData: Data = .init ( bytes: colors, count: MemoryLayout < SCNVector3 > .size * colors.count )
		
		//	Create a `SCNGeometrySource`
		
		self.init (
			
			data: colorData,
			semantic: .color,
			vectorCount: colors.count,
			usesFloatComponents: true,
			componentsPerVector: 3,
			bytesPerComponent: MemoryLayout < Float > .size,
			dataOffset: 0,
			dataStride: MemoryLayout < SCNVector3 > .size
			
		)
		
	}
	
}

@available ( iOS 16.0, * )
fileprivate extension SCNGeometry {
	
	/// Creates an `SCNGeometry` from a collection of meshes and a collection of materials.
	///
	/// - Parameters:
	///   - meshes: A collection of values, each representing the channels of an sRGB color.
	///   - materials: A collection of vertex coordinates.
	///
	convenience init ( meshes: [ simd_float3 ], materials: [ simd_float3 ] ) {
		
		//	Create a `SCNGeometry`
		
		self.init (
			
			sources: [
				
				SCNGeometrySource ( vertices: meshes.map { SCNVector3 ( $0 ) } ),
				SCNGeometrySource ( colors: materials.map { SCNVector3 ( $0 ) } )
				
			],
			
			elements: [
				
				SCNGeometryElement (
					
					indices: meshes.indices.map ( Int32.init ),
					primitiveType: .triangles
					
				)
				
			]
			
		)
		
	}
	
}

//
//
