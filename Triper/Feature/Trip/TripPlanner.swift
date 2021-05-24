//
//  TripPlanner.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 23/05/2021.
//

import Foundation
import MapKit
import Combine


func planTrip(places: [Place]) -> AnyPublisher<[MKRoute], Error> {
	zip(places.dropLast().map(\.placemark), places.dropFirst().map(\.placemark))
		.publisher
		.flatMap { findDirections(sourcePlacemark: $0, destinationPlacemark: $1) }
		.collect()
		.eraseToAnyPublisher()
}

func findDirections(
	sourcePlacemark: CLPlacemark,
	destinationPlacemark: CLPlacemark,
	transport: MKDirectionsTransportType = .automobile,
	departureDate: Date = Date()
) -> AnyPublisher<MKRoute, Error> {
	let request = MKDirections.Request()
	request.source = MKMapItem(placemark: .init(placemark: sourcePlacemark))
	request.destination = .init(placemark: .init(placemark: destinationPlacemark))
	request.departureDate = departureDate
	request.transportType = transport
	return MKDirections(request: request)
		.calculate()
		.compactMap { $0.routes.first }
		.eraseToAnyPublisher()
}


extension MKDirections {
	func calculate() -> AnyPublisher<MKDirections.Response, Error> {
		Deferred {
			Future { promise in
				self.calculate { response, error in
					if let error = error {
						promise(.failure(error))
					} else {
						promise(.success(response!))
					}
				}
			}
		}.eraseToAnyPublisher()
	}
}

extension Array {
	func oddElements() -> Array<Element> {
		self.enumerated().filter { $0.offset % 2 != 0 }.map(\.element)
	}
	
	func evenElements() -> Array<Element> {
		self.enumerated().filter { $0.offset % 2 == 0 }.map(\.element)
	}
}
