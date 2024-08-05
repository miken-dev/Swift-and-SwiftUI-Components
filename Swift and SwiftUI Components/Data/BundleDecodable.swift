//
//  BundleDecodable.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 7/27/24.
//

import Foundation


extension Bundle {
	
	/// A bundle extension method that decodes JSON files to Swift Objects
	/// - Parameters:
	///   - file: A file
	///   - type: The data model to decode to, must conform to Decodable
	/// - Returns: The given objects
	/// ## Discussion
	/// Example:
	/// ```swift
	/// let AllObjects = Bundle.main.decode("Objects.json", as: [Object].self)
	/// ```
	func decode<T: Decodable>(
		_ file: String,
		as type: T.Type = T.self,
		dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
		keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
	) -> T {
		guard let url = self.url(forResource: file, withExtension: nil) else {
			fatalError("Failed to locate \(file) in bundle")
		}
		
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load \(file) from bundle")
		}
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
		
		do {
			return try decoder.decode(T.self, from: data)
		} catch DecodingError.keyNotFound(let key, let context) {
			fatalError("Failed to decode \(file): missing key '\(key.stringValue)' - \(context.debugDescription)")
		} catch DecodingError.typeMismatch(_, let context) {
			fatalError("Failed to decode \(file): type mismatch - \(context.debugDescription)")
		} catch DecodingError.valueNotFound(let type, let context) {
			fatalError("Failed to decode \(file): missing \(type) value - \(context.debugDescription)")
		} catch DecodingError.dataCorrupted(_) {
			fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
		} catch {
			fatalError("Failed to decode\(file) from bundle: \(error.localizedDescription)")
		}
	}
}
