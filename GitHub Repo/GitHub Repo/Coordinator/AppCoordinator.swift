//
//  AppCoordinator.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 18/01/2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetails(repoName: String, stargazersCount: Int, authorName: String, htmlUrl: URL, avatarUrl: URL) {
        let vc = DetailsViewController()
        vc.authorName = authorName
        vc.repoName = repoName
        vc.htmlUrl = htmlUrl.absoluteString
        vc.stargazersCount = stargazersCount.description
        vc.avatarUrl = avatarUrl.absoluteString
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
