// swift-tools-version: 5.7

//
//  SDKit: Configuration
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import PackageDescription

//
//

//  MARK: - Variables

let package = Package (
    
    name: "SDKit",
    
    products: [
        
        .library (
            
            name: "SDKit",
            targets: [ "SDKit" ]
            
        ),
        
    ],
    
    dependencies: [ ],
    
    targets: [
        
        .target (
            
            name: "SDKit",
            dependencies: [ ],
            path: "sources"
            
        ),
        
        .testTarget (
            
            name: "SDKitTests",
            dependencies: [ "SDKit" ],
            path: "tests"
            
        ),
        
    ]
    
)

//
//
