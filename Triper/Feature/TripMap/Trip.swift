//
//  Trip.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/06/2021.
//

import Foundation


struct Trip {
	let name: String
	let estimatedTime: Double
	let placesToVisit: Int
	let distance: Double
	let places: [Trip.Place]
	
	struct Place {
		let latitude: Double
		let longitude: Double
		let name: String
		let note: String
		let address: Address
		
		struct Address {
			let country: String
			let state: String
			let city: String
			let street: String
			let subLocality: String
			let postalCode: String
		}
	}
}

extension Trip.Place {
	init(place: Place) {
		name = place.name
		latitude = place.placemark.location?.coordinate.latitude ?? 0
		longitude = place.placemark.location?.coordinate.longitude ?? 0
		note = place.note ?? ""
		address = .init(
			country: place.placemark.country.orEmpty,
			state: place.placemark.administrativeArea.orEmpty,
			city: place.placemark.locality.orEmpty,
			street: place.placemark.thoroughfare.orEmpty,
			subLocality: place.placemark.subLocality.orEmpty,
			postalCode: place.placemark.postalCode.orEmpty
		)
	}
}

extension Optional where Wrapped == String {
	var orEmpty: String {
		self ?? ""
	}
}
