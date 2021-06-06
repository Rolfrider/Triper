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
	@Published var likedIds: [String] = []
	@Published var showOnlyLiked: Bool = false
	@Published var errorMsg: String?
	var cancellables: Set<AnyCancellable> = .init()
	
	func loadTrips() {
		fetchTrips()
			.receive(on: DispatchQueue.main)
			.handleEvents(
				receiveCompletion: { _ in DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.isLoading = false } },
				receiveRequest: { _ in self.isLoading = true }
			)
			.catch { error -> Empty<[ApiType.TripPreview], Never>in
				self.errorMsg = "Couldn't fetch trips, reason: \(error)"
				return Empty<[ApiType.TripPreview], Never>(completeImmediately: true)
			}
			.assign(to: \.trips, on: self)
			.store(in: &cancellables)
	}
}
