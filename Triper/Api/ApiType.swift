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
		let placesToVisit: Int
		let distance: Double
		let places: [Place]
	}
	
	struct TripPreview: Codable {
		let id: String
		let name: String
		let estimatedTime: Double
		let placesToVisit: Int
		let distance: Double
	}
	
	struct Place: Codable {
		let name: String
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
