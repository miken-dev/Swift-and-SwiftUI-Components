//
//  LinkedList.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 8/4/24.
//

import Foundation

final class LinkedListNode<Element> {
	var value: Element
	var next: LinkedListNode?
	
	init(value: Element, next: LinkedListNode? = nil) {
		self.value = value
		self.next = next
	}
}

struct LinkedListIterator<Element>: IteratorProtocol {
	var current: LinkedListNode<Element>?
	
	mutating func next() -> LinkedListNode<Element>? {
		defer { current = current?.next }
		return current
	}
}

final class LinkedList<Element>: ExpressibleByArrayLiteral, Sequence {
	var start: LinkedListNode<Element>?
	
	init(arrayLiteral elements: Element...) {
		for element in elements.reversed() {
			start = LinkedListNode(value: element, next: start)
		}
	}
	
	init(array: [Element]) {
		for element in array.reversed() {
			start = LinkedListNode(value: element, next: start)
		}
	}
	
	func makeIterator() -> LinkedListIterator<Element> {
		LinkedListIterator(current: start)
	}
}
