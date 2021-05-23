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
					HStack {
						Text("Places: \(viewModel.places.count)")
							.font(.largeTitle)
							.bold()
							.foregroundColor(Color(.label).opacity(0.6))
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
					Button(action: viewModel.planTrip) {
						HStack {
							Spacer()
							Text("Plan my trip")
								.font(.headline)
								.foregroundColor(Color(.label))
							Image(systemName: "paperplane")
							Spacer()
						}
						.padding()
						.background(Color(.systemFill))
						.cornerRadius(18)
					}
				}.padding([.horizontal, .bottom])
			}.navigationBarTitle("New Trip")
			.sheet(isPresented: $placeSelection, content: {
				PlaceSelectionView(
					viewModel:
						PlaceSelectionViewModel(
							addPlaceCallback: viewModel.addPlace(place:),
							country: viewModel.places.last?.country
						)
				)
			})
		}
		
    }
}

//struct NewTripView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTripView()
//    }
//}

struct PlaceView: View {
	let name: String
	let emoji: String
	
	var body: some View {
		HStack {
			Spacer()
			Group {
				Text(emoji)
				Text(name)
			}
			.font(.caption)
			Spacer()
			
		}
		.padding(.all, 6)
		.background(Color.gray)
		.cornerRadius(18)
	}
}
