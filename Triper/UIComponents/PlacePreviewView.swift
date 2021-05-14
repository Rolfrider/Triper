//
//  PlacePreviewView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 28/03/2021.
//

import SwiftUI

struct PlacePreviewView: View {
	var body: some View {
		HStack {
			Spacer()
			Text("🇿🇦")
				.font(.largeTitle)
			VStack(alignment: .leading) {
				Text("Museum Twojej Starej")
					.font(.headline)
					.lineLimit(1)
				Text("Polska")
					.font(.subheadline)
					.lineLimit(1)
				Text("Chciałbym zobaczyć jak gruba jest twoja stara")
					.font(.body)
					.lineLimit(2)
			}
			Spacer()
		}
		.padding()
		.background(Color(.secondarySystemFill))
		.cornerRadius(16)
	}
}

struct PlacePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PlacePreviewView()
    }
}
