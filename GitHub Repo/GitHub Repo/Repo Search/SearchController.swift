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
    
    var isFirstSearchingDone = false
    var safeArea: UILayoutGuide!
    
    lazy var repoList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none

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
    
    lazy var repositoriesLabel: UILabel = {
        let label = UILabel()

        label.text = "Repositories"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        return label
    }()
    
    lazy var initialRepoLabel: UILabel = {
        let label = UILabel()

        label.text = "Search repositories to display results"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center

        return label
    }()
    
    lazy var avatarImage: UIImage = {
        let avatar = UIImage()

        return avatar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        self.view.backgroundColor = .white
        setupRepoLabel()
        setupInitialLabel()
        self.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar
    }
    
    func prepareToParse(query: String) {
        let urlString = "https://api.github.com/search/repositories?q=\(query)&page=1&per_page=20"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        isFirstSearchingDone = true
        
        if isFirstSearchingDone {
            setupElements()
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonItems = try? decoder.decode(Repositories.self, from: json) {
            items = jsonItems.items
            for item in jsonItems.items {
                owners.append(item.owner)
            }
        }
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchBar.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchBar.isActive && (!isSearchBarEmpty())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        prepareToParse(query: query)
        repoList.reloadData()
    }

}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isFiltering() {
            initialRepoLabel.removeFromSuperview()
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                SearchCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray6
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.white.cgColor

        let item = items[indexPath.row]
        let owner = owners[indexPath.row]
        
        var image = UIImage(named: "launchScreenLogo.png")
        if let data = try? Data(contentsOf: owner.avatarUrl) {
            image = UIImage(data: data)!
        }

        cell.repoTitle.text = item.name
        cell.starsNumber.text = item.stargazersCount.description
        cell.avatar.image = image

        return cell
    }
}


extension SearchController {
    func setupElements() {
        view.addSubview(repoList)
        
        repoList.topAnchor.constraint(equalTo: repositoriesLabel.bottomAnchor, constant: 20).isActive = true
        repoList.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        repoList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        repoList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    func setupRepoLabel() {
        view.addSubview(repositoriesLabel)

        repositoriesLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        repositoriesLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        repositoriesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    func setupInitialLabel() {
        view.addSubview(initialRepoLabel)
        
        initialRepoLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        initialRepoLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        initialRepoLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        initialRepoLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}
