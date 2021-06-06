//
//  TripPreviewView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 25/05/2021.
//

import SwiftUI

struct TripPreviewView: View {
	
	@StateObject var viewModel: TripPreviewViewModel
	@State var showTrip = false
	
    var body: some View {
			ZStack {
				Color(.systemBackground)
				VStack(alignment: .leading, spacing: 0) {
					Text("Places: \(viewModel.places.count)")
						.font(.largeTitle)
						.bold()
						.foregroundColor(Color(.label))
					VStack(spacing: 0) {
						ScrollView {
							ForEach(viewModel.places, id: \.id) { place in
								PlacePreviewView(place: place)
							}
						}
						.padding(.top)
						Spacer()
					}
					NavigationLink(
						destination: TripMapView(viewModel: .init(placesFactory: viewModel.placesForTrip, tripName: viewModel.name)),
						isActive: $showTrip) {
						Button(action: { showTrip.toggle() }) {
							HStack {
								Spacer()
								Text("Show trip plan")
									.font(.headline)
									.foregroundColor(Color(.label))
								Image(systemName: "paperplane")
								Spacer()
							}
							.padding()
							.background(Color(.systemFill))
							.cornerRadius(18)
						}
					}
				}.padding([.horizontal, .bottom])
				.onAppear { viewModel.loadTrip() }
			}.navigationBarTitle(viewModel.name)
			.loadingOverlay(viewModel.isLoading)
			.alert(item: $viewModel.errorMsg) {
				.init(title: Text($0), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Retry"), action: { viewModel.loadTrip() }))
			}
//			.navigationBarTitleDisplayMode(.inline)
    }
}
