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
	@State var isTripInfoHidden: Bool = false
    var body: some View {
		ZStack {
			MapView(annotations: $viewModel.annotations, routes: $viewModel.routes, selectedAnnotation: selectedAnnotationBinding)
				.alert(item: $viewModel.errorMsg) {
					.init(title: Text("Error"), message: Text($0))
				}
				.edgesIgnoringSafeArea(.all)
				.onAppear(perform: viewModel.calcTrip)
				.loadingOverlay(viewModel.isLoading)
			VStack {
				Spacer().layoutPriority(1)
				VStack {
					Text("\(viewModel.selectedPlace.0). \(viewModel.selectedPlace.1.name)")
						.font(.callout)
						.padding()
					Divider().padding(.horizontal)
					TripInfoView(placesCount: viewModel.annotations.count, estimatedTime: viewModel.estimatedTime.stringFromTimeInterval(), distance: viewModel.distance/1000)
						.padding()
				}
				.background(Color(.systemBackground))
				.cornerRadius(12)
				.padding()
			}
			.offset(x: 0, y: isTripInfoHidden ? 100 : 0)
			.onTapGesture {
				withAnimation {
					isTripInfoHidden.toggle()
				}
			}
		}
//		.navigationBarTitleDisplayMode(.inline)
    }
	
	var selectedAnnotationBinding: Binding<MKAnnotation> {
		.init(
			get: { MKPlacemark(placemark: viewModel.selectedPlace.1.placemark) },
			set: viewModel.annotationSelected(annotation:)
		)
	}
}

extension String: Identifiable {
	public var id: String {
		self
	}
}
