//
//  ContentView.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 06/03/2021.
//

import SwiftUI
import ComposableArchitecture
import ComposableNavigator

struct ContentView: View {
	let dataSource: Navigator.Datasource = Navigator.Datasource(root: HomeScreen())
	let navigator: Navigator
	let appStore: Store<AppState, AppAction>
	init() {
		navigator = Navigator(dataSource: dataSource).debug()
		appStore = Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment(navigator: navigator))
	}
    var body: some View {
		Root(
			dataSource: dataSource,
			navigator: navigator,
			pathBuilder: HomeScreen.Builder(appStore: appStore)
		)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
