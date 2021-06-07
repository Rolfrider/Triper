//
//  TripInfoView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 05/06/2021.
//

import SwiftUI

struct TripInfoView: View {
	let placesCount: Int
	let estimatedTime: String
	let distance: Double
	
	var body: some View {
		HStack {
			TripInfoCell(label: "Places", value: "\(placesCount)")
			dividerWithSpacers
			TripInfoCell(label: "Estimated time", value: "\(estimatedTime)")
			dividerWithSpacers
			TripInfoCell(label: "Distance", value: String(format: "%.1f km", distance))
		}
	}
	
	private var dividerWithSpacers: some View {
		Group {
			Spacer()
			Divider()
			Spacer()
		}
	}
}

struct TripInfoCell: View {
	let label: String
	let value: String
	
	var body: some View {
		VStack {
			Text(label)
				.font(.callout)
				.foregroundColor(Color(.label))
			Text(value)
				.foregroundColor(Color(.secondaryLabel))
		}
	}
}
