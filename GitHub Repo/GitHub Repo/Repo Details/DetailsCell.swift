//
//  DetailsCell.swift
//  GitHub Repo
//
//  Created by Patryk Krajnik on 19/01/2021.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    let commitNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .systemGray6
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20.0
        label.textAlignment = .center
        
        return label
    }()
    
    let commitAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "COMMIT AUTHOR NAME"
        label.textColor = .systemBlue
        
        return label
    }()
    
    let authorEmail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "email@authorname.com"
        label.textColor = .label
        
        return label
    }()
    
    let commitMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "This is a short commit message. This is a short commit message."
        label.numberOfLines = 2
        label.textColor = .lightGray
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(commitNumber)
        addSubview(commitAuthor)
        addSubview(authorEmail)
        addSubview(commitMessage)
        
        commitNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        commitNumber.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        commitNumber.heightAnchor.constraint(equalToConstant: 40).isActive = true
        commitNumber.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        commitAuthor.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        commitAuthor.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        authorEmail.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        authorEmail.topAnchor.constraint(equalTo: commitAuthor.bottomAnchor, constant: 5).isActive = true
        
        commitMessage.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        commitMessage.topAnchor.constraint(equalTo: authorEmail.bottomAnchor, constant: 5).isActive = true
        commitMessage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        commitMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
