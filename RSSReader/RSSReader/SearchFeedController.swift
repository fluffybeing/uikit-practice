//
//  ViewController.swift
//  RSSReader
//
//  Created by Rahul Ranjan on 4/28/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

struct Entry {
    var title: String?
    var contentSnippet: String?
    var url: String?
}

class SearchFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let entryCellId = "entryCellId"
    let headerId = "headerId"
    
    var entries: [Entry]? = [
        Entry(title: "Sample Title 1", contentSnippet: "Sample Content Snippet 1", url: nil),
        Entry(title: "Sample Title 2", contentSnippet: "Sample Content Snippet 2", url: nil),
        Entry(title: "Sample Title 3", contentSnippet: "Sample Content Snippet 3", url: nil)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "RSS Reader"
        
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        // layout
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func performSearchForText(text: String) {
        print("Searching......news")
        
        // Add API for feeds
        // Google Feed API depreciated
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = entries?.count {
            return count
        }
        
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
        
        let entry = entries?[indexPath.item]
        entryCell.titleLabel.text = entry?.title
        entryCell.contentSnippetTextView.text = entry?.contentSnippet
        
        return entryCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchHeader
        
        header.searchFeedController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}

