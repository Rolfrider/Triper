//
//  NavigationAction.swift
//  Triper
//
//  Created by Rafał Kwiatkowski on 13/03/2021.
//

import Foundation

enum NavigationAction {
	case set([NavigationItem])
	case push(NavigationItem)
	case pop
	case popToRoot
}
