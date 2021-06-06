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
	let tripName: String
	var wasAdded: Bool = false
	
	init(placesFactory: () -> [Place], tripName: String) {
		self.places = placesFactory()
		self.tripName = tripName
	}
	
	
	func calcTrip() {
		annotations = places.map { MKPlacemark(placemark: $0.placemark) }
		let tripPublisher: AnyPublisher<[MKRoute], Never> = planTrip(places: places)
			.share()
			.catch { error -> Empty<[MKRoute], Never>in
				self.errorMsg = "Couldn't find route for trip, reason: \(error)"
				return Empty<[MKRoute], Never>(completeImmediately: true)
			}
			.eraseToAnyPublisher()
		
		if wasAdded == false {
			tripPublisher
				.flatMap { routes in
					postTrip(
						trip: .init(
							name: self.tripName,
							estimatedTime: routes.map(\.expectedTravelTime).reduce(0, +),
							placesToVisit: self.places.count,
							distance: routes.map(\.distance).reduce(0, +),
							places: self.places.map(Trip.Place.init(place:))
						)
					)
					.receive(on: DispatchQueue.main)
					.catch { error -> Empty<Void, Never>in
						self.errorMsg = "Couldn't save trip, reason: \(error)"
						return Empty<Void, Never>(completeImmediately: true)
					}
				}
				.receive(on: DispatchQueue.main)
				.handleEvents(
					receiveRequest: { _ in self.isLoading = true }
				)
				.sink(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.isLoading = false }
					self.wasAdded = true
				} , receiveValue: {})
				.store(in: &cancellables)
		}
		
		tripPublisher
			.receive(on: DispatchQueue.main)
			.assign(to: \.routes, on: self)
			.store(in: &cancellables)
	}
	
}
