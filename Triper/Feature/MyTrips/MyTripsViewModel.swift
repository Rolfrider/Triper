//
//  MyTripsViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/06/2021.
//

import Foundation
import SwiftUI
import Combine

class MyTripsViewModel: ObservableObject {
	@Published var trips: [ApiType.TripPreview] = []
	@Published var isLoading: Bool = false
	@Published var errorMsg: String?
	var cancellables: Set<AnyCancellable> = .init()
	
	func loadTrips() {
		fetchMyTrips()
			.receive(on: DispatchQueue.main)
			.handleEvents(
				receiveCompletion: { _ in
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.isLoading = false }
				},
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

