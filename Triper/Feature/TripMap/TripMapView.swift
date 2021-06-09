//
//  TripView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 23/05/2021.
//

import SwiftUI
import MapKit

struct TripMapView: View {
	@StateObject var viewModel: TripMapViewModel
	
    var body: some View {
		ZStack {
			MapView(annotations: $viewModel.annotations, routes: $viewModel.routes)
				.alert(item: $viewModel.errorMsg) {
					.init(title: Text("Error"), message: Text($0))
				}
				.edgesIgnoringSafeArea(.all)
				.onAppear(perform: viewModel.calcTrip)
				.loadingOverlay(viewModel.isLoading)
			VStack {
				Spacer().layoutPriority(1)
				TripInfoView(placesCount: viewModel.annotations.count, estimatedTime: viewModel.estimatedTime.stringFromTimeInterval(), distance: viewModel.distance/1000)
					.padding()
					.background(Color(.systemBackground))
					.cornerRadius(12)
					.padding()
			}
		}
    }
}

extension String: Identifiable {
	public var id: String {
		self
	}
}
