//
//  PlacePreviewView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 28/03/2021.
//

import SwiftUI

struct PlacePreviewView: View {
	let place: Place
	let isFirstPlace: Bool
	let onDelete: (UUID) -> ()
	let firstPlaceTapped: (UUID) -> ()
	
	var body: some View {
		VStack(spacing: 16) {
			HStack {
//				place.country.flagEmoji.map(Text.init)
//					.font(.largeTitle)
				VStack(alignment: .leading) {
					Text("\(place.name), \(place.placemark.country ?? "") \(place.placemark.isoCountryCode ?? "")")
						.font(.headline)
						.lineLimit(2)
					Text(place.name)
						.font(.body)
						.lineLimit(2)
				}
				Spacer()
			}
			.padding(.horizontal)
			HStack {
				Button("Set starting point") {
					firstPlaceTapped(place.id)
				}
				Spacer()
				Button("Delete point") { onDelete(place.id) }
					.foregroundColor(.red)
			}
			.padding(.horizontal)
		}
		.padding()
		.background(Color(.secondarySystemFill))
		.cornerRadius(16)
	}
}
