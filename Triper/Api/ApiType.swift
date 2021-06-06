//
//  ApiType.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 05/06/2021.
//

import Foundation

struct ApiType {
	
	struct Trip: Codable {
		let id: String
		let name: String
		let estimatedTime: Double
		let distance: Double
		let places: [Place]
	}
	
	struct NewTrip: Codable {
		let deviceUuid: String
		let name: String
		let estimatedTime: Double
		let distance: Double
		let places: [Place]
	}
	
	struct TripPreview: Codable {
		let id: String
		let name: String
		let estimatedTime: Double
		let numberOfPlaces: Int
		let distance: Double
	}
	
	struct Place: Codable {
		let name: String
		let note: String
		let latitude: Double
		let longitude: Double
		let address: Address
		
		struct Address: Codable {
			let country: String
			let state: String
			let city: String
			let street: String
			let subLocality: String
			let postalCode: String
		}
	}
}

extension ApiType.Place.Address {
	init(address: Trip.Place.Address) {
		country = address.country
		state = address.state
		city = address.city
		street = address.street
		subLocality = address.subLocality
		postalCode = address.postalCode
	}
}

extension ApiType.Place {
	init(place: Trip.Place) {
		name = place.name
		latitude = place.latitude
		longitude = place.longitude
		address = .init(address: place.address)
		note = place.note
	}
}

extension ApiType.NewTrip {
	init(deviceUuid: String, trip: Trip) {
		self.deviceUuid = deviceUuid
		name = trip.name
		distance = trip.distance
		estimatedTime = trip.estimatedTime
		places = trip.places.map(ApiType.Place.init(place:))
	}
}
