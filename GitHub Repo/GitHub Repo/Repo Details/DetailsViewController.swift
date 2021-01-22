//
//  DetailsViewController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 18/01/2021.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var commits = [Commits]()
    
    weak var coordinator: AppCoordinator?
    
    var scrollView: UIScrollView!
    var headerContainerView: UIView!
    var imageView = UIImageView()
    let image = UIImage(named: "Share.png")
    
    var labelRepoName: UILabel!
    var labelStargazersCount: UILabel!
    var labelHeaderRepo: UILabel!
    var labelRepoAuthor: UILabel!
    var labelCommitsHistory: UILabel!
    
    var viewOnlineButton: UIButton!
    var shareRepoButton: UIButton!
    
    var authorName: String = ""
    var repoName: String = ""
    var htmlUrl: String = ""
    var avatarUrl: String = ""
    var stargazersCount: String = ""
    
    var scaleRatio = UIScreen.main.bounds.height / 844
    
    lazy var commitsList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailsCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        createView()
        setViewConstraints()
        prepareToParse()
        
        labelRepoName.font = UIFont.systemFont(ofSize: 18*scaleRatio, weight: .semibold)
        labelRepoName.textColor = .label
        labelRepoName.text = repoName
        labelRepoName.numberOfLines = 2
        
        labelStargazersCount.font = UIFont.systemFont(ofSize: 14*scaleRatio, weight: .semibold)
        labelStargazersCount.textColor = .lightText
        labelStargazersCount.text = "Number of Stars (\(stargazersCount))"
        
        labelHeaderRepo.font = UIFont.systemFont(ofSize: 14*scaleRatio, weight: .semibold)
        labelHeaderRepo.textColor = .lightText
        labelHeaderRepo.text = "REPO BY"
        
        labelRepoAuthor.font = UIFont.systemFont(ofSize: 32*scaleRatio, weight: .bold)
        labelRepoAuthor.textColor = .white
        labelRepoAuthor.text = authorName
        
        labelCommitsHistory.font = UIFont.systemFont(ofSize: 22*scaleRatio, weight: .bold)
        labelCommitsHistory.textColor = .label
        labelCommitsHistory.text = "Commits History"
        
        viewOnlineButton.backgroundColor = .systemGray6
        viewOnlineButton.showsTouchWhenHighlighted = true
        viewOnlineButton.setTitleColor(.systemBlue, for: .normal)
        viewOnlineButton.titleLabel?.font = UIFont.systemFont(ofSize: 16*scaleRatio, weight: .semibold)
        viewOnlineButton.clipsToBounds = true
        viewOnlineButton.layer.cornerRadius = 15.0
        viewOnlineButton.setTitle("VIEW ONLINE", for: .normal)
        viewOnlineButton.addTarget(self, action: #selector(viewRepoOnline(sender:)), for: .touchUpInside)
        
        shareRepoButton.backgroundColor = .systemGray6
        shareRepoButton.showsTouchWhenHighlighted = true
        shareRepoButton.setTitleColor(.systemBlue, for: .normal)
        shareRepoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18*scaleRatio, weight: .semibold)
        shareRepoButton.clipsToBounds = true
        shareRepoButton.layer.cornerRadius = 10.0
        shareRepoButton.setTitle("Share Repo", for: .normal)
        shareRepoButton.addTarget(self, action: #selector(shareRepo(sender:)), for: .touchUpInside)
        shareRepoButton.setImage(image, for: .normal)
        shareRepoButton.imageView?.contentMode = .scaleAspectFit
        shareRepoButton.tintColor = .systemBlue
        shareRepoButton.imageEdgeInsets = UIEdgeInsets(top: 10*scaleRatio, left: -5*scaleRatio, bottom: 10*scaleRatio, right: 0)
        
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        print("Repo URL: \(htmlUrl)")
        print("Author Name: \(authorName)")
        print("Repo Name: \(repoName)")
        print("Repo stars count: \(stargazersCount)")
        print("Avatar URL: \(avatarUrl)")
    }
    
    @objc func viewRepoOnline(sender: UIButton!) {
        let finalUrl = htmlUrl + "/\(repoName)"
        guard let url = URL(string: finalUrl) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func shareRepo(sender: UIButton!) {
        let textToShare = "Check GitHub repository named \(repoName) created by \(authorName)!"
        let finalUrl = htmlUrl + "/" + repoName
        
        if let gitHubWebsite = URL(string: finalUrl) {
            let objectToShare = [textToShare, gitHubWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func prepareToParse() {
        let urlString = "https://api.github.com/repos/\(authorName)/\(repoName)/commits"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonCommits = try? decoder.decode([Commits].self, from: json) {
            commits = jsonCommits
        }
    }
    
    func setupNavBar() {
        let imageUrl = URL(string: avatarUrl)
        imageView.imageFrom(url: imageUrl!)
    }
    
    func createView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        labelRepoName = UILabel()
        labelRepoName.numberOfLines = 0
        scrollView.addSubview(labelRepoName)
        
        headerContainerView = UIView()
        headerContainerView.backgroundColor = .gray
        scrollView.addSubview(headerContainerView)
        
        labelStargazersCount = UILabel()
        labelStargazersCount.numberOfLines = 0
        scrollView.addSubview(labelStargazersCount)
        
        labelHeaderRepo = UILabel()
        labelHeaderRepo.numberOfLines = 0
        scrollView.addSubview(labelHeaderRepo)
        
        labelRepoAuthor = UILabel()
        labelRepoAuthor.numberOfLines = 0
        scrollView.addSubview(labelRepoAuthor)
        
        labelCommitsHistory = UILabel()
        labelCommitsHistory.numberOfLines = 0
        scrollView.addSubview(labelCommitsHistory)
        
        viewOnlineButton = UIButton()
        scrollView.addSubview(viewOnlineButton)
        
        shareRepoButton = UIButton()
        scrollView.addSubview(shareRepoButton)
        
        scrollView.addSubview(commitsList)

        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        headerContainerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        labelRepoName.translatesAutoresizingMaskIntoConstraints = false
        labelRepoName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        labelRepoName.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10*scaleRatio).isActive = true
        labelRepoName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 180*scaleRatio).isActive = true
        labelRepoName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        labelRepoName.rightAnchor.constraint(equalTo: viewOnlineButton.leftAnchor, constant: -20*scaleRatio).isActive = true
        
        let headerContainerViewBottom: NSLayoutConstraint!
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        headerContainerViewBottom = headerContainerView.bottomAnchor.constraint(equalTo: labelRepoName.topAnchor, constant: -20*scaleRatio)
        headerContainerViewBottom.priority = UILayoutPriority(rawValue: 900)
        headerContainerViewBottom.isActive = true
        
        let imageViewTopConstraint: NSLayoutConstraint!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        imageViewTopConstraint.priority = UILayoutPriority(rawValue: 900)
        imageViewTopConstraint.isActive = true
        
        labelStargazersCount.translatesAutoresizingMaskIntoConstraints = false
        labelStargazersCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        labelStargazersCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        labelStargazersCount.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        labelStargazersCount.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20*scaleRatio).isActive = true
        
        labelRepoAuthor.translatesAutoresizingMaskIntoConstraints = false
        labelRepoAuthor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        labelRepoAuthor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        labelRepoAuthor.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        labelRepoAuthor.bottomAnchor.constraint(equalTo: labelStargazersCount.topAnchor, constant: -10*scaleRatio).isActive = true
        
        labelHeaderRepo.translatesAutoresizingMaskIntoConstraints = false
        labelHeaderRepo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        labelHeaderRepo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        labelHeaderRepo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        labelHeaderRepo.bottomAnchor.constraint(equalTo: labelRepoAuthor.topAnchor, constant: -5*scaleRatio).isActive = true
        
        labelCommitsHistory.translatesAutoresizingMaskIntoConstraints = false
        labelCommitsHistory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20*scaleRatio).isActive = true
        labelCommitsHistory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10*scaleRatio).isActive = true
        labelCommitsHistory.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        labelCommitsHistory.topAnchor.constraint(equalTo: labelRepoName.bottomAnchor, constant: 30*scaleRatio).isActive = true
        
        viewOnlineButton.translatesAutoresizingMaskIntoConstraints = false
        viewOnlineButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20*scaleRatio).isActive = true
        viewOnlineButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 175*scaleRatio).isActive = true
        viewOnlineButton.widthAnchor.constraint(equalToConstant: 140*scaleRatio).isActive = true
        
        commitsList.topAnchor.constraint(equalTo: labelCommitsHistory.bottomAnchor, constant: 15*scaleRatio).isActive = true
        commitsList.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commitsList.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commitsList.bottomAnchor.constraint(equalTo: shareRepoButton.topAnchor, constant: -20*scaleRatio).isActive = true
        
        shareRepoButton.translatesAutoresizingMaskIntoConstraints = false
        shareRepoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20*scaleRatio).isActive = true
        shareRepoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20*scaleRatio).isActive = true
        shareRepoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40*scaleRatio).isActive = true
        shareRepoButton.heightAnchor.constraint(equalToConstant: 50*scaleRatio).isActive = true
    }
}

extension UIImageView {
    func imageFrom(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch commits.count {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as?
                DetailsCell else { return UITableViewCell() }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if !(commits.isEmpty) {
            let commit = commits[indexPath.row]
            cell.commitMessage.text = commit.commit.message
            cell.commitAuthor.text = commit.commit.author.name
            cell.authorEmail.text = commit.commit.author.email
        }
        
        cell.commitNumber.text = (indexPath.row + 1).description
        
        return cell
    }
}
