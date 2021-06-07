//
//  TripPreviewViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/06/2021.
//

import Foundation
import SwiftUI
import Combine
import Intents
import Contacts

class TripPreviewViewModel: ObservableObject {
	@Published var name: String = ""
	@Published var places: [Place] = []
	@Published var isLoading: Bool = false
	@Published var startPlaceId: UUID?
	@Published var errorMsg: String?
	private let tripId: String
	var cancellables: Set<AnyCancellable> = .init()
	
	init(id: String) {
		self.tripId = id
	}
	
	func placesForTrip() -> [Place] {
		var placesToCalc = places
		if let firstIndex = placesToCalc.firstIndex(where: { $0.id == startPlaceId }) {
			let place = placesToCalc.remove(at: firstIndex)
			placesToCalc.insert(place, at: 0)
		}
		return getVisitOrder(places: placesToCalc)
	}
	
	func loadTrip() {
		let tripPublisher = fetchTrip(id: tripId)
			.receive(on: DispatchQueue.main)
			.handleEvents(
				receiveCompletion: { _ in
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
				},
				receiveRequest: { _ in self.isLoading = true }
			)
			.catch { error -> Empty<ApiType.Trip, Never>in
				self.errorMsg = "Couldn't fetch trip, reason: \(error)"
				return Empty<ApiType.Trip, Never>(completeImmediately: true)
			}.share()
			
		tripPublisher
			.map(\.places)
			.map { places in
				places.map {
					Place(name: $0.name, id: UUID(), placemark: $0.placemark, note: $0.note)
				}
			}
			.assign(to: \.places, on: self)
			.store(in: &cancellables)
		
		tripPublisher
			.map(\.name)
			.assign(to: \.name, on: self)
			.store(in: &cancellables)
	
	}
}

extension ApiType.Place {
	var placemark: CLPlacemark {
		.init(
			location: .init(latitude: latitude, longitude: longitude),
			name: name,
			postalAddress: address.cnPostalAddress
		)
	}
}

extension ApiType.Place.Address {
	var cnPostalAddress: CNPostalAddress {
		let postalAddress = CNMutablePostalAddress()
		postalAddress.city = city
		postalAddress.country = country
		postalAddress.postalCode = postalCode
		postalAddress.state = state
		postalAddress.subLocality = subLocality
		postalAddress.street = street
		postalAddress.subAdministrativeArea = state
		return postalAddress
	}
}
