//
//  MapViewViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 23/05/2021.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class TripMapViewModel: ObservableObject {
	
	@Published var routes: [MKRoute] = []
	@Published var annotations: [MKAnnotation] = []
	@Published var isLoading: Bool = false
	@Published var errorMsg: String?
	
	var cancellables: Set<AnyCancellable> = .init()
	private let places: [Place]
	
	init(placesFactory: () -> [Place]) {
		self.places = placesFactory()
	}
	
	
	func calcTrip() {
		annotations = places.map{ MKPlacemark(placemark: $0.placemark) }
		planTrip(places: places)
//			.subscribe(on: DispatchQueue.global())
			.receive(on: DispatchQueue.main)
			.handleEvents(
				receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.isLoading = false } },
				receiveRequest: { _ in self.isLoading = true }
			)
			.print()
			.catch { error -> Empty<[MKRoute], Never>in
				self.errorMsg = "Couldn't find route for trip, reason: \(error)"
				return Empty<[MKRoute], Never>(completeImmediately: true)
			}
			.assign(to: \.routes, on: self)
			.store(in: &cancellables)
	}
	
}
