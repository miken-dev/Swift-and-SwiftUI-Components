//
//  QueuesAndDeques.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 8/4/24.
//

import Foundation

struct Queue<Element> {
	private var array = [Element]()
	
	var first: Element? { array.first }
	var last: Element? { array.last }
	
	mutating func append(_ element: Element) {
		array.append(element)
	}
	
	mutating func dequeue() -> Element? {
		guard array.count > 0 else { return nil }
		return array.remove(at: 0)
	}
	
	
}
//Swift will always prefer the most constrained version of your method
protocol Prioritized {
	var priority: Int { get }
}

extension Queue where Element: Prioritized {
	mutating func dequeue() -> Element? {
		guard array.count > 0 else { return nil }
		
		var choice = array[0]
		var choiceIndex = 0
		
		for (index, item) in array.enumerated() {
			if item.priority > choice.priority {
				choice = item
				choiceIndex = index
			}
		}
		
		return array.remove(at: choiceIndex)
	}
	
}
//example of prioritized object
struct Work: Prioritized {
	let name: String
	let priority: Int
}
