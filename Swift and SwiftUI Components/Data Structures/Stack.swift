//
//  Stack.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 8/4/24.
//

import Foundation

struct Stack<Element> {
	private var array = [Element]()
	var count: Int { array.count }
	var isEmpty: Bool { array.isEmpty }
	
	init(_ items: [Element]) {
		self.array = items
	}
	
	init() { }
	
	mutating func push(_ element: Element) {
		array.append(element)
	}
	
	mutating func pop() -> Element? {
		array.popLast()
	}
	
	func peek() -> Element? {
		array.last
	}
}

extension Stack: ExpressibleByArrayLiteral {
	init(arrayLiteral elements: Element...) {
		self.array = elements
	}
}

// allows print to print it out like an array
extension Stack: CustomDebugStringConvertible {
	var debugDescription: String {
		var result = "["
		var first = true
		
		for item in array {
			if first {
				first = false
			} else {
				result += ", "
			}
			
			debugPrint(item, terminator: "", to: &result)
		}
		
		result += "]"
		return result
	}
}

//Adds Equatable(==), Hashable(can be added to dicts and sets), and Codable(can be saved and loaded)
extension Stack: Equatable where Element: Equatable { }
extension Stack: Hashable where Element: Hashable { }
extension Stack: Decodable where Element: Decodable { }
extension Stack: Encodable where Element: Encodable { }

