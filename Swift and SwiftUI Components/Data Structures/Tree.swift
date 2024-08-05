//
//  Tree.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 8/4/24.
//

import Foundation

struct Node<Value> {
	var value: Value
	private(set) var children: [Node]
	
	// recursive count that traverses all children and counts the total
	var count: Int {
		1 + children.reduce(0) { $0 + $1.count }
	}
	
	// synthesized memberwise initializer requires us to pass in a value, and children, which we don't always want to do
	init(_ value: Value) {
		self.value = value
		children = []
	}
	
	init(_ value: Value, children: [Node]) {
		self.value = value
		self.children = children
	}
	
	init(_ value: Value, @NodeBuilder builder: () -> [Node]) {
		self.value = value
		self.children = builder()
	}
	
	mutating func add(child: Node) {
		children.append(child)
	}
}

// Conditional Conformances
extension Node: Equatable where Value: Equatable { }
extension Node: Hashable where Value: Hashable { }
extension Node: Codable where Value: Codable { }

extension Node where Value: Equatable {
	func find(_ value: Value) -> Node? {
		if self.value == value {
			return self
		}
		for child in children {
			if let match = child.find(value) {
				return match
			}
		}
		return nil
	}
}

@resultBuilder
struct NodeBuilder {
	// builds an array of children from a variatic input
	static func buildBlock<Value>(_ children: Node<Value>...) -> [Node<Value>] {
		children
	}
}
