//
//  MyTripsView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import SwiftUI

struct MyTripsView: View {
	@StateObject var viewModel: MyTripsViewModel
	
    var body: some View {
		NavigationView {
			ScrollView {
				LazyVStack(spacing: 12) {
					ForEach(viewModel.trips, id: \.id) { trip in
						TripPreviewCell(tripName: trip.name, tripId: trip.id, placesCount: trip.numberOfPlaces, estimatedTime: trip.estimatedTime.stringFromTimeInterval(), distance: trip.distance/1000)
					}
				}.padding()
			}
			.onAppear { viewModel.loadTrips() }
			
			.navigationBarTitle("My Trips")
			.alert(item: $viewModel.errorMsg) {
				.init(title: Text($0), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Retry"), action: { viewModel.loadTrips() }))
			}
		}
		.loadingOverlay(viewModel.isLoading)
    }
	
	struct TripPreviewCell: View {
		let tripName: String
		let tripId: String
		let placesCount: Int
		let estimatedTime: String
		let distance: Double
		
		var body: some View {
			NavigationLink(destination: TripPreviewView(viewModel: .init(id: tripId))) {
				HStack {
					Spacer()
					VStack {
						HStack {
							Text(tripName)
								.font(.title)
								.foregroundColor(Color(.label))
								.bold()
							Spacer()
						}
						TripInfoView(
							placesCount: placesCount,
							estimatedTime: estimatedTime,
							distance: distance
						)
					}
					Spacer()
				}
				.padding()
				.background(Color(.secondarySystemBackground))
				.cornerRadius(10)
				.shadow(radius: 5)
			}.buttonStyle(PlainButtonStyle())
		}
	}
}
