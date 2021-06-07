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
		MapView(annotations: $viewModel.annotations, routes: $viewModel.routes)
			.alert(item: $viewModel.errorMsg) {
				.init(title: Text("Error"), message: Text($0))
			}
			.edgesIgnoringSafeArea(.all)
			.onAppear(perform: viewModel.calcTrip)
			.loadingOverlay(viewModel.isLoading)
    }
}

extension String: Identifiable {
	public var id: String {
		self
	}
}
