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
	@Published var estimatedTime: Double = 0
	@Published var distance: Double = 0
	@Published var selectedPlace: (Int, Place)
	var cancellables: Set<AnyCancellable> = .init()
	private let places: [Place]
	let tripName: String
	var wasAdded: Bool = false
	
	init(placesFactory: () -> [Place], tripName: String, wasAdded: Bool = false) {
		self.places = placesFactory()
		self.tripName = tripName.isEmpty ? "Trip \(places.first?.name)" : tripName
		self.wasAdded = wasAdded
		self.selectedPlace = (1, places[0])
	}
	
	func annotationSelected(annotation: MKAnnotation) {
		if let (index, place) = places.enumerated().filter({ _ ,place in
			place.placemark.location?.coordinate.latitude == annotation.coordinate.latitude
				&& place.placemark.location?.coordinate.longitude == annotation.coordinate.longitude
		}).first {
			selectedPlace = (index + 1, place)
		}
	}
	
	
	func calcTrip() {
		annotations = places.map { MKPlacemark(placemark: $0.placemark) }
		let tripPublisher: AnyPublisher<[MKRoute], Never> = planTrip(places: places)
			.share()
			.catch { error -> Empty<[MKRoute], Never>in
				self.errorMsg = "Couldn't find route for trip, reason: \(error)"
				return Empty<[MKRoute], Never>(completeImmediately: true)
			}
			.handleEvents(
				receiveRequest: { _ in self.isLoading = true }
			)
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
				.sink(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
					self.wasAdded = true
				} , receiveValue: {})
				.store(in: &cancellables)
		}
		
		tripPublisher
			.handleEvents(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
			})
			.receive(on: DispatchQueue.main)
			.assign(to: \.routes, on: self)
			.store(in: &cancellables)
		
		tripPublisher
			.handleEvents(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
			})
			.map { $0.map(\.expectedTravelTime).reduce(0, +)
			}
			.receive(on: DispatchQueue.main)
			.assign(to: \.estimatedTime, on: self)
			.store(in: &cancellables)
		
		tripPublisher
			.handleEvents(receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
			})
			.map { $0.map(\.distance).reduce(0, +) }
			.receive(on: DispatchQueue.main)
			.assign(to: \.distance, on: self)
			.store(in: &cancellables)
	}
	
}
