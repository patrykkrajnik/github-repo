//
//  DetailsViewController.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 18/01/2021.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    weak var coordinator: AppCoordinator?
    
    var scrollView: UIScrollView!
    var headerContainerView: UIView!
    var imageView = UIImageView()
    
    var labelRepoName: UILabel!
    var labelStargazersCount: UILabel!
    var labelHeaderRepo: UILabel!
    var labelRepoAuthor: UILabel!
    var labelCommitsHistory: UILabel!
    
    var viewOnlineButton: UIButton!
    
    var authorName: String = ""
    var repoName: String = ""
    var htmlUrl: String = ""
    var avatarUrl: String = ""
    var stargazersCount: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        createView()
        setViewConstraints()
        
        labelRepoName.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        labelRepoName.textColor = .label
        labelRepoName.text = repoName
        
        labelStargazersCount.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        labelStargazersCount.textColor = .lightText
        labelStargazersCount.text = "Number of Stars (\(stargazersCount))"
        
        labelHeaderRepo.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        labelHeaderRepo.textColor = .lightText
        labelHeaderRepo.text = "REPO BY"
        
        labelRepoAuthor.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        labelRepoAuthor.textColor = .white
        labelRepoAuthor.text = authorName
        
        viewOnlineButton.backgroundColor = .systemGray6
        viewOnlineButton.showsTouchWhenHighlighted = true
        viewOnlineButton.setTitleColor(.systemBlue, for: .normal)
        viewOnlineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        viewOnlineButton.clipsToBounds = true
        viewOnlineButton.layer.cornerRadius = 20.0
        viewOnlineButton.setTitle("VIEW ONLINE", for: .normal)
        viewOnlineButton.addTarget(self, action: #selector(viewRepoOnline(sender:)), for: .touchUpInside)
        
        self.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        
        viewOnlineButton = UIButton()
        scrollView.addSubview(viewOnlineButton)

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
        labelRepoName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelRepoName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelRepoName.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        labelRepoName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 180).isActive = true
        labelRepoName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        let headerContainerViewBottom: NSLayoutConstraint!
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        headerContainerViewBottom = headerContainerView.bottomAnchor.constraint(equalTo: labelRepoName.topAnchor, constant: -20)
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
        labelStargazersCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelStargazersCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelStargazersCount.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        labelStargazersCount.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -20).isActive = true
        
        labelRepoAuthor.translatesAutoresizingMaskIntoConstraints = false
        labelRepoAuthor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelRepoAuthor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelRepoAuthor.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        labelRepoAuthor.bottomAnchor.constraint(equalTo: labelStargazersCount.topAnchor, constant: -10).isActive = true
        
        labelHeaderRepo.translatesAutoresizingMaskIntoConstraints = false
        labelHeaderRepo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        labelHeaderRepo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        labelHeaderRepo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        labelHeaderRepo.bottomAnchor.constraint(equalTo: labelRepoAuthor.topAnchor, constant: -5).isActive = true
        
        viewOnlineButton.translatesAutoresizingMaskIntoConstraints = false
        viewOnlineButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        viewOnlineButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 175).isActive = true
        viewOnlineButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
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
