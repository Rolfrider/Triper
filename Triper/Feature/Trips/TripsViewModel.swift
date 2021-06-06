//
//  TripsViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/06/2021.
//

import Foundation
import SwiftUI
import Combine

class TripsViewModel: ObservableObject {
	@Published var trips: [ApiType.TripPreview] = []
	@Published var isLoading: Bool = false
	@Published var likedIds: [String] = getFromUserDefaults()
	@Published var showOnlyLiked: Bool = false {
		didSet {
			if showOnlyLiked {
				trips = allTrips.filter { likedIds.contains($0.id) }
			} else {
				trips = allTrips
			}
		}
	}
	@Published var errorMsg: String?
	var cancellables: Set<AnyCancellable> = .init()
	var allTrips: [ApiType.TripPreview] = []
	
	func loadTrips() {
		fetchTrips()
			.receive(on: DispatchQueue.main)
			.handleEvents(
				receiveCompletion: { _ in
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.isLoading = false }
					self.trips = self.allTrips
				},
				receiveRequest: { _ in self.isLoading = true }
			)
			.catch { error -> Empty<[ApiType.TripPreview], Never>in
				self.errorMsg = "Couldn't fetch trips, reason: \(error)"
				return Empty<[ApiType.TripPreview], Never>(completeImmediately: true)
			}
			.assign(to: \.allTrips, on: self)
			.store(in: &cancellables)
	}
	
	func likeTapped(id: String) {
		if let indexToDel = likedIds.firstIndex(of: id) {
			likedIds.remove(at: indexToDel)
		} else {
			likedIds.append(id)
		}
		saveToUserDefaults(ids: likedIds)
	}
}
