//
//  SearchController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 14/01/2021.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {
    
    var items = [Item]()
    var owners = [Owner]()
    
    var filteredRepos = [Repositories2]()
    let repos = Repositories2.GetAllRepos()
    var safeArea: UILayoutGuide!
    
    struct Repositories2 {
        let title: String
        let stars: String
        
        static func GetAllRepos() -> [Repositories2] {
            return [
                Repositories2(title: "Hi", stars: "2137"),
                Repositories2(title: "Hello", stars: "69"),
                Repositories2(title: "World", stars: "10"),
                Repositories2(title: "Good", stars: "1000"),
                Repositories2(title: "Morning", stars: "800")
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
    
//    lazy var repositoriesLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.view.backgroundColor = .white
        setupElements()
        //setupLabel()
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
        
        let urlString = "https://api.github.com/search/repositories?q=tetris+language:swift"
        
        if let url = URL(string: urlString) {
            print("1")
            if let data = try? Data(contentsOf: url) {
                print("2")
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        print("3")
        
        if let jsonItems = try? decoder.decode(Repositories.self, from: json) {
            print("4")
            items = jsonItems.items
            for item in jsonItems.items {
                owners.append(item.owner)
            }
            //print(owners)
            //print(items)
        }
    }

    func filteredContentForSearchText(searchText: String) {
        filteredRepos = repos.filter({ (repository: Repositories2) -> Bool in
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
        cell.accessoryType = .disclosureIndicator
        
        let currentRepositories: Repositories2
        //let item = items[indexPath.row]
        //let owner = owners[indexPath.row]
        
        if isFiltering() {
            currentRepositories = filteredRepos[indexPath.row]
        } else {
            currentRepositories = repos[indexPath.row]
        }
        
        cell.repoTitle.text = currentRepositories.title
        //cell.repoTitle.text = owner.login
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
    
//    func setupLabel() {
//        view.addSubview(repositoriesLabel)
//
//        repositoriesLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//        repositoriesLabel.bottomAnchor.constraint(equalTo: repoList.bottomAnchor).isActive = true
//        repositoriesLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        repositoriesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//    }
}
