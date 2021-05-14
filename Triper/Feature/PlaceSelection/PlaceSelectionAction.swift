//
//  PlaceSelectionAction.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 03/04/2021.
//

import Foundation
import ComposableArchitecture
import ComposableNavigator

enum PlaceSelectionAction: Equatable {
	case binding(BindingAction<Place>)
	case addPlace(ScreenID)
}
