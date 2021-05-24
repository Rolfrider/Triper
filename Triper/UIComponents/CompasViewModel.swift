//
//  CompasViewModel.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/03/2021.
//

import Foundation
import SwiftUI
import CoreMotion

class CompassViewModel: ObservableObject {
	@Published var rotationAngle: Double = 0
	let motionManager = CMMotionManager()
	
	init() {
		rotationAngle = motionManager.deviceMotion?.attitude.yaw ?? 0
		
		if motionManager.isDeviceMotionAvailable {
			motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
				guard let `self` = self, let data = data else { return }
				
				self.rotationAngle = data.attitude.yaw
			}
		}
	}
	
	deinit {
		motionManager.stopDeviceMotionUpdates()
	}
	
	func magnitude(from attitude: CMAttitude) -> Double {
		return sqrt(pow(attitude.roll, 2) +
						pow(attitude.yaw, 2) +
						pow(attitude.pitch, 2))
	}
}
