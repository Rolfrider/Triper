//
//  AppState.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 17/03/2021.
//

import Foundation
import ComposableArchitecture
import ComposableNavigator

struct AppState {
	var home: HomeState
	
	
	init() {
		home = .init()
	}
}

struct AppEnvironment {
	let navigator: Navigator
	
	var home: HomeEnvironment { .init(navigator: navigator) }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>
	.combine(
		homeReducer
			.pullback(
				state: \.home,
				action: /AppAction.home,
				environment: \.home
			)
)

enum AppAction {
	case home(HomeAction)
}
