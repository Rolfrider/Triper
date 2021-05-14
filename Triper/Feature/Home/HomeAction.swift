//
//  HomeAction.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 26/03/2021.
//

import Foundation
enum HomeAction: Equatable {
	case set(Tab)
	case newTrip(NewTripAction)
}
