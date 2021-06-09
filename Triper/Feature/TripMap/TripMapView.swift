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
	@State var directionsSheet: Bool = false
    var body: some View {
		ZStack {
			MapView(annotations: $viewModel.annotations, routes: $viewModel.routes, selectedAnnotation: selectedAnnotationBinding)
				.alert(item: $viewModel.errorMsg) {
					.init(title: Text("Error"), message: Text($0))
				}
				.edgesIgnoringSafeArea(.all)
				.onAppear(perform: viewModel.calcTrip)
			VStack {
				Spacer().layoutPriority(1)
				VStack {
					Text("\(viewModel.selectedPlace.0). \(viewModel.selectedPlace.1.name)")
						.font(.callout)
						.padding()
					Button("Show directions") { directionsSheet.toggle() }
					Divider().padding(.horizontal)
					TripInfoView(placesCount: viewModel.annotations.count, estimatedTime: viewModel.estimatedTime.stringFromTimeInterval(), distance: viewModel.distance/1000)
						.padding()
				}
				.background(Color(.systemBackground))
				.cornerRadius(12)
				.padding()
			}
			.shadow(radius: 4)
			.offset(x: 0, y: isTripInfoHidden ? 140 : 0)
			.onTapGesture {
				withAnimation {
					isTripInfoHidden.toggle()
				}
			}
		}
		.actionSheet(isPresented: $directionsSheet) {
			.init(title: Text("Select Map App"), buttons: [
				.default(Text("Google Maps")) { viewModel.openInGoogleMaps() },
				.default(Text("Apple Maps")) { viewModel.openInAppleMaps() },
				.cancel()
			])
		}
		.loadingOverlay(viewModel.isLoading)
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
