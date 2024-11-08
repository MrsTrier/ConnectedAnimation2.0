//
//  AppCoordinator.swift
//  ConnectedAnimation
//
//  Created by Daria Cheremina on 07/11/2024.
//

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func start()
}

final class AppCoordinator: AppCoordinatorProtocol {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let connectedAnimationViewController = ConnectedAnimationViewController()

        navigationController.pushViewController(connectedAnimationViewController, animated: false)
    }
}
