//
//  RatingView.swift
//  Bookworm
//
//  Created by Michael Neal on 8/21/23.
//

import SwiftUI

struct StarRatingView: View {
	@Binding var rating: Int
	
	var label = ""
	var maximumRating = 5
	
	var offImage: Image?
	var onImage = Image(systemName: "star.fill")
	
	var offColor = Color.gray
	var onColor = Color.yellow
	
	
	var body: some View {
		HStack {
			if label.isEmpty == false {
				Text(label)
			}
			
			ForEach(1..<maximumRating + 1, id: \.self) { number in
				image(for: number)
					.foregroundColor(number > rating ? offColor : onColor)
					.onTapGesture {
						rating = number
					}
			}
		}
	}
	func image (for number: Int) -> Image {
		if number > rating {
			return offImage ?? onImage
		} else {
			return onImage
		}
	}
}

#Preview {
    StarRatingView(rating: .constant(4))
}
