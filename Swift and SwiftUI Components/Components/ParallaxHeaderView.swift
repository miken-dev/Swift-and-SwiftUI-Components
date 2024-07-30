//
//  ParallaxHeaderView.swift
//  Swift and SwiftUI Components
//
//  Created by Michael Neal on 7/27/24.
//

import SwiftUI

/// A parallax header to go at the top of a View. 
/// Has a blur effect when pulled down past the end of the ScrollView
///
/// ## Discussion
/// Must be placed inside of a ScrollView
/// To set up:
/// ```swift
///struct ContentView: View {
///    private enum CoordinateSpaces {
///        case scrollView
///    }
///    var body: some View {
///        ScrollView {
///            ParallaxHeaderView(
///                coordinateSpace: CoordinateSpaces.scrollView,
///                defaultHeight: 200
///                ) {
///                Image("Image Name")
///                    .resizable()
///                    .scaledToFill()
///            }
///        }
///    }
///
/// ```
struct ParallaxHeaderView<Content: View, Space: Hashable>: View {
	let content: () -> Content
	let coordinateSpace: Space
	let defaultHeight: CGFloat
	
	init(
		coordinateSpace: Space,
		defaultHeight: CGFloat,
		@ViewBuilder _ content: @escaping () -> Content
	) {
		self.content = content
		self.coordinateSpace = coordinateSpace
		self.defaultHeight = defaultHeight
	}
	
	
	var body: some View {
		GeometryReader { proxy in
			let offset = offset(for: proxy)
			let heightModifier = heightModifier(for: proxy)
			let blurRadius = min(
				(heightModifier - 100) / 20 ,
				max(10, heightModifier / 20)
			)
			content()
				.edgesIgnoringSafeArea(.horizontal)
				.frame(width: proxy.size.width, height: proxy.size.height + heightModifier)
				.offset(y: offset)
				.blur(radius: blurRadius)
		}.frame(height: defaultHeight)
	}
	
	private func offset(for proxy: GeometryProxy) -> CGFloat {
		let frame = proxy.frame(in: .named(coordinateSpace))
		if frame.minY < 0 {
			return -frame.minY * 0.09
		}
		return -frame.minY
	}
	
	private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
		let frame = proxy.frame(in: .named(coordinateSpace))
		return max(0, frame.minY)
	}
}


//#Preview {
//    ParallaxHeaderView()
//}
