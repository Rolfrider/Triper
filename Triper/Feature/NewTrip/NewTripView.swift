//
//  NewTripView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import SwiftUI

struct NewTripView: View {
	
	@StateObject var viewModel = NewTripViewModel()
	@State var placeSelection = false
	
    var body: some View {
		NavigationView {
			ZStack {
				Color(.systemBackground)
				VStack(alignment: .leading, spacing: 0) {
					TextField("Trip name", text: $viewModel.name)
						.font(.largeTitle)
						.padding(.top)
					HStack {
						Text("Places: \(viewModel.places.count)")
							.font(.largeTitle)
							.bold()
							.foregroundColor(Color(.label))
						Spacer()
						Button("+") { self.placeSelection = true }
							.font(.largeTitle)
					}
					VStack(spacing: 0) {
						if viewModel.places.isEmpty {
							Spacer()
							HStack {
								Spacer()
								Button("+ Add place to visit") { self.placeSelection = true }
									.font(.headline)
								Spacer()
							}
						} else {
							ScrollView {
								ForEach(viewModel.places, id: \.id) { place in
									HStack {
										Text (place.name)
										Spacer()
										if viewModel.startPlaceId == place.id {
											Text("🏁")
										}
									}
									.contentShape(Rectangle())
									.onTapGesture {
										withAnimation { viewModel.selectedPlace = place }
									}
									.padding()
									.background(Color(.secondarySystemBackground))
									.cornerRadius(18)
								}
							}
							.padding(.top)
						}
						Spacer()
					}
					viewModel.selectedPlace.map { place in
						PlacePreviewView(
							place: place,
							isFirstPlace: place.id == viewModel.startPlaceId,
							onDelete: viewModel.deletePlace(id:)
						) { viewModel.startPlaceId = $0 }
					}
					Spacer(minLength: 16)
					NavigationLink(
						destination: TripMapView(viewModel: .init(placesFactory: viewModel.placesForTrip)),
						isActive: $viewModel.showTrip) {
						Button(action: viewModel.planTrip) {
							HStack {
								Spacer()
								Text("Plan my trip")
									.font(.headline)
									.foregroundColor(Color(isDisabled ? .label.withAlphaComponent(0.5) : .label))
								Image(systemName: "paperplane")
								Spacer()
							}
							.disabled(isDisabled)
							.padding()
							.background(Color(isDisabled ? .systemFill.withAlphaComponent(0.5) : .systemFill))
							.cornerRadius(18)
						}
					}
				}.padding([.horizontal, .bottom])
			}.navigationBarHidden(true)
			.sheet(isPresented: $placeSelection, content: {
				PlaceSelectionView(
					viewModel:
						PlaceSelectionViewModel(
							addPlaceCallback: viewModel.addPlace(place:)
						)
				)
			})
		}
		
    }
	
	var isDisabled: Bool {
		viewModel.places.count < 2
	}
}

extension Array {
	var isNotEmpty: Bool {
		self.isEmpty == false
	}
}

