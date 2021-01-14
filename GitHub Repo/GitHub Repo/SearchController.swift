//
//  SearchController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchController: UIViewController {
    
    struct Repositories {
        let title: String
        let stars: String
        
        static func GetAllRepos() -> [Repositories] {
            return [
                Repositories(title: "Hi", stars: "2137"),
                Repositories(title: "JD", stars: "69")
            ]
        }
    }
    
    let repos = Repositories.GetAllRepos()
    
    lazy var repoList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupElements()
        // Do any additional setup after loading the view.
    }


}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                SearchCell else { return UITableViewCell() }
        
        cell.repoTitle.text = repos[indexPath.row].title
        cell.starsNumber.text = repos[indexPath.row].stars
        
        return cell
    }
}


extension SearchController {
    func setupElements() {
        view.addSubview(repoList)
        
        repoList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        repoList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        repoList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        repoList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
