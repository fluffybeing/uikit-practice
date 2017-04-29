//
//  ViewController.swift
//  PersonalityType
//
//  Created by Rahul Ranjan on 4/29/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class QuestionController: UITableViewController {
    
    let answerCellId = "answerCellId"
    let headerCellId = "headerCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Question"
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.register(AnswerCell.self, forCellReuseIdentifier: answerCellId)
        tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerCellId)
        
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let answerCell = tableView.dequeueReusableCell(withIdentifier: answerCellId, for: indexPath) as! AnswerCell
        
        return answerCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let resultConrtoller = ResultConrtoller()
        
        navigationController?.pushViewController(resultConrtoller, animated: true)
    }

}


class ResultConrtoller: UIViewController {
    
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations, you are toal boss!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(resultLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultLabel]))
    }
}

class QuestionHeader: UITableViewHeaderFooterView {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your personality?"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(questionLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": questionLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": questionLabel]))
        
    }
    
}


class AnswerCell: UITableViewCell {
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nameLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
    }
}

