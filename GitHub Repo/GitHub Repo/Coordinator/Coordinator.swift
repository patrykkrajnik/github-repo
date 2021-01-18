//
//  Coordinator.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 18/01/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
