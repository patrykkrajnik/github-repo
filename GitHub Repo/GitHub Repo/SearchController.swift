//
//  SearchController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {
    
    var filteredRepos = [Repositories]()
    let repos = Repositories.GetAllRepos()
    var safeArea: UILayoutGuide!
    
    struct Repositories {
        let title: String
        let stars: String
        
        static func GetAllRepos() -> [Repositories] {
            return [
                Repositories(title: "Hi", stars: "2137"),
                Repositories(title: "Hello", stars: "69"),
                Repositories(title: "World", stars: "10"),
                Repositories(title: "Good", stars: "1000"),
                Repositories(title: "Morning", stars: "800")
            ]
        }
    }
    
    lazy var repoList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        
        searchController.searchBar.delegate = self
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.view.backgroundColor = .white
        setupElements()
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
        // Do any additional setup after loading the view.
    }

    func filteredContentForSearchText(searchText: String) {
        filteredRepos = repos.filter({ (repository: Repositories) -> Bool in
            return repository.title.lowercased().contains(searchText.lowercased())
        })
        
        repoList.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchBar.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchBar.isActive && (!isSearchBarEmpty())
    }

}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() { return filteredRepos.count }
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                SearchCell else { return UITableViewCell() }
        
        let currentRepositories: Repositories
        
        if isFiltering() {
            currentRepositories = filteredRepos[indexPath.row]
        } else {
            currentRepositories = repos[indexPath.row]
        }
        
        cell.repoTitle.text = currentRepositories.title
        cell.starsNumber.text = currentRepositories.stars
        
        return cell
    }
}


extension SearchController {
    func setupElements() {
        view.addSubview(repoList)
        
        repoList.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        repoList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        repoList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        repoList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
