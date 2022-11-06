
# SDKit

**A next-level suite of utilities and components for Swift and SwiftUI.**

Modelled for efficiency, intuitively documented, designed with precision, aesthetically perfect, and packed with type safety.

```
//
//
```

## TOC

### [ Utilities ]( #utilities )

* [ SDJSON ]( #sdjson )
* [ Bundle.name ]( #Bundlename )
* [ Bundle.displayName ]( #bundledisplayname )
* [ SDDefaults ]( #sddefaults )
* [ SDSchemeColor ]( #sdschemecolor )

### [ Components ]( #components )

* [ SDInterface ]( #sdinterface )
* [ SDXStack ]( #sdxstack )
* [ SDYStack ]( #sdystack )
* [ SDSStack ]( #sdsstack )
* [ SDNothing ]( #sdnothing )

### [ Contact ]( #contact )

```
//
//
```

## Utilities

### SDJSON

A JSON parser with dynamic lookup support. SDJSON is a lightweight JSONSerialization wrapper for digging through JSON objects with ease. SDJSON uses dynamic member lookup and subscripts, to replicate dot notation syntax used in other languages. Access, typecast, unwrap, and use. Returns nil if you make an error.

### Bundle.name

Returns the bundle name.

### Bundle.displayName

Returns the bundle display name.

### SDDefaults

A collection of overridable preferences powering SDKit.

### SDSchemeColor

A color initializer that switches between colors based on the device's color scheme.

```
// 
// 
```

## Components

### SDInterface

A base container that applies styling, injects defaults, and orients content on the z-axis. SDInterface is intended for use at the top level of your project, and should contain all of your other views. It applies most of the styling defaults set in SDDefaults, decluttering your main view, and passes it as a parameter to the container for external use.

### SDXStack

A view that arranges its subviews in a horizontal line, with default spacing set to zero.

### SDYStack

A view that arranges its subviews in a vertical line, with default spacing set to zero.

### SDSStack

A scrollable view that wraps an SDXStack or SDYStack, depending on the orientation.

### SDNothing

A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack. Minimum spacing defaults to zero.

```
// 
// 
```

## Contact

For questions or concerns, reach out:

[ riley@rileybarabash.com ]( mailto:riley@rileybarabash.com )

Riley Barabash\
**SPLIT Designs**

```
//
//
```
