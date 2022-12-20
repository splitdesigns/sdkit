
//
//  SDKit: State Observers
//  Developed by SPLIT Designs
//

//  MARK: - Imports

import SwiftUI

//
//

//  MARK: - Extensions

@available ( iOS 16.0, * )
public extension View {
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate < Value: Equatable > ( of value: Value, perform action: @escaping ( _ value: Value ) -> Void ) -> some View {
		
		return self
			.onChange ( of: value ) { action ( $0 ) }
			.onAppear { action ( value ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0 ) }
			.onAppear { action ( valueZero, valueOne ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo ) }
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable,
		ValueFive: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		or valueFive: ValueFive,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour,
			_ valueFive: ValueFive
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour, valueFive ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour, valueFive ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour, valueFive ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour, valueFive ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0, valueFive ) }
			.onChange ( of: valueFive ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable,
		ValueFive: Equatable,
		ValueSix: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		or valueFive: ValueFive,
		or valueSix: ValueSix,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour,
			_ valueFive: ValueFive,
			_ valueSix: ValueSix
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour, valueFive, valueSix ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour, valueFive, valueSix ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour, valueFive, valueSix ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0, valueFive, valueSix ) }
			.onChange ( of: valueFive ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, $0, valueSix ) }
			.onChange ( of: valueSix ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable,
		ValueFive: Equatable,
		ValueSix: Equatable,
		ValueSeven: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		or valueFive: ValueFive,
		or valueSix: ValueSix,
		or valueSeven: ValueSeven,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour,
			_ valueFive: ValueFive,
			_ valueSix: ValueSix,
			_ valueSeven: ValueSeven
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour, valueFive, valueSix, valueSeven ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour, valueFive, valueSix, valueSeven ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0, valueFive, valueSix, valueSeven ) }
			.onChange ( of: valueFive ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, $0, valueSix, valueSeven ) }
			.onChange ( of: valueSix ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, $0, valueSeven ) }
			.onChange ( of: valueSeven ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable,
		ValueFive: Equatable,
		ValueSix: Equatable,
		ValueSeven: Equatable,
		ValueEight: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		or valueFive: ValueFive,
		or valueSix: ValueSix,
		or valueSeven: ValueSeven,
		or valueEight: ValueEight,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour,
			_ valueFive: ValueFive,
			_ valueSix: ValueSix,
			_ valueSeven: ValueSeven,
			_ valueEight: ValueEight
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour, valueFive, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0, valueFive, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueFive ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, $0, valueSix, valueSeven, valueEight ) }
			.onChange ( of: valueSix ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, $0, valueSeven, valueEight ) }
			.onChange ( of: valueSeven ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, $0, valueEight ) }
			.onChange ( of: valueEight ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight ) }
		
	}
	
	/// Performs an action when a value is created or mutated to a different value, passing the new value to the action closure.
	///
	/// - Parameters:
	///   - of: The value to observe.
	///   - or: Another value to observe simultaneously.
	///   - perform: The action to run when an update is observed.
	///
	func onUpdate <
		
		ValueZero: Equatable,
		ValueOne: Equatable,
		ValueTwo: Equatable,
		ValueThree: Equatable,
		ValueFour: Equatable,
		ValueFive: Equatable,
		ValueSix: Equatable,
		ValueSeven: Equatable,
		ValueEight: Equatable,
		ValueNine: Equatable
			
	> (
		
		of valueZero: ValueZero,
		or valueOne: ValueOne,
		or valueTwo: ValueTwo,
		or valueThree: ValueThree,
		or valueFour: ValueFour,
		or valueFive: ValueFive,
		or valueSix: ValueSix,
		or valueSeven: ValueSeven,
		or valueEight: ValueEight,
		or valueNine: ValueNine,
		
		perform action: @escaping (
			
			_ valueZero: ValueZero,
			_ valueOne: ValueOne,
			_ valueTwo: ValueTwo,
			_ valueThree: ValueThree,
			_ valueFour: ValueFour,
			_ valueFive: ValueFive,
			_ valueSix: ValueSix,
			_ valueSeven: ValueSeven,
			_ valueEight: ValueEight,
			_ valueNine: ValueNine
			
		) -> Void
		
	) -> some View {
		
		return self
			.onChange ( of: valueZero ) { action ( $0, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueOne ) { action ( valueZero, $0, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueTwo ) { action ( valueZero, valueOne, $0, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueThree ) { action ( valueZero, valueOne, valueTwo, $0, valueFour, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueFour ) { action ( valueZero, valueOne, valueTwo, valueThree, $0, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueFive ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, $0, valueSix, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueSix ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, $0, valueSeven, valueEight, valueNine ) }
			.onChange ( of: valueSeven ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, $0, valueEight, valueNine ) }
			.onChange ( of: valueEight ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, $0, valueNine ) }
			.onChange ( of: valueNine ) { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight, $0 ) }
			.onAppear { action ( valueZero, valueOne, valueTwo, valueThree, valueFour, valueFive, valueSix, valueSeven, valueEight, valueNine ) }
		
	}
	
}

//
//
