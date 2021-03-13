//
//  NavigationReducer.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 13/03/2021.
//

import Foundation
import ComposableArchitecture

struct NavigationEnvironment {}

typealias NavigationReducer = Reducer<NavigationState, NavigationAction, NavigationEnvironment>

let navigationReducer = NavigationReducer { state, action, _ in
	switch action {
	case .set(let items): state = items
	case .push(let item): state.append(item)
	case .pop: _ = state.popLast()
	case .popToRoot: state = Array(state.prefix(1))
	}
	return .none
}
