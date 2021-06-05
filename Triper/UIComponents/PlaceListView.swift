//
//  PlaceListView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 25/05/2021.
//

import SwiftUI

struct PlaceListView: View {
	let place: Place
	let isStartPlace: Bool
	
	var body: some View {
		HStack {
			Text (place.name)
			Spacer()
			if isStartPlace {
				Text("🏁")
			}
		}
		.contentShape(Rectangle())
		.padding()
		.background(Color(.secondarySystemBackground))
		.cornerRadius(18)
	}
}
