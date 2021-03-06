//
//  TripPlanner.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 23/05/2021.
//

import Foundation
import CoreLocation

func getVisitOrder(places: [Place]) -> [Place] {
	var places = places
	var referencePlace = places.remove(at: 0)
	var result: [Place] = [referencePlace]
	while places.isEmpty == false {
		places.sort(by: { referencePlace.isFirstCloser(firstPlace: $0, secondPlace: $1) })
		referencePlace = places.remove(at: 0)
		result.append(referencePlace)
	}
	return result
}

extension Place {
	func isFirstCloser(firstPlace: Place, secondPlace: Place) -> Bool {
		guard
			let location = self.placemark.location,
			let loc1 = firstPlace.placemark.location,
			let loc2 = secondPlace.placemark.location
		else { fatalError("No location - \(self), \(firstPlace), \(secondPlace)") }
		return location.distance(from: loc1) < location.distance(from: loc2)
	}
}
