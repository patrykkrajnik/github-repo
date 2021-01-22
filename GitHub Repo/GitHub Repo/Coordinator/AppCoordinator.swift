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
        let initialViewController = SearchViewController()
        initialViewController.coordinator = self
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func showDetails(repoName: String, stargazersCount: Int, authorName: String, htmlUrl: URL, avatarUrl: URL) {
        let secondViewController = DetailsViewController()
        
        //Data that is passed to second ViewController
        secondViewController.authorName = authorName
        secondViewController.repoName = repoName
        secondViewController.htmlUrl = htmlUrl.absoluteString
        secondViewController.stargazersCount = stargazersCount.description
        secondViewController.avatarUrl = avatarUrl.absoluteString
        
        secondViewController.coordinator = self
        navigationController.pushViewController(secondViewController, animated: true)
    }
}
