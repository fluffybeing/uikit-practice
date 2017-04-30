//
//  Posts.swift
//  Facebook Feed
//
//  Created by Rahul Ranjan on 5/1/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit


class Post {
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
    
    var statusImageURL: String?
}

class Posts {
    private let postList: [Post]
    
    init() {
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.statusText = "Meanwhile, Beast turned to the dark side."
        postMark.numLikes = 400
        postMark.numComments = 123
        postMark.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/mark_zuckerberg_background.jpg"
        
        let postSteve = Post()
        postSteve.name = "Steve Jobs"
        postSteve.statusText = "Design is not what it looks like and feels like. Design id how it works.\n\n" + "Being the richest man in the cementery doesn't matter to me. Going to bed at night saying we'have done something wonderful, that's what matters to me. \n\n" + "Sometimes when you innovate' you make mistakes. It id best to admit them quickly, and get on with improving your other innovations."
        postSteve.numLikes = 500
        postSteve.numComments = 100
        postSteve.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/steve_jobs_background.jpg"
        
        let postGandhi = Post()
        postGandhi.name = "Mahatama Gandhi"
        postGandhi.statusText = "Like live you will die tommorrow but learn like your will live forever"
        postGandhi.numLikes = 50000
        postGandhi.numComments = 1000
        postGandhi.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gandhi_status.jpg"
        
        
       postList = [postGandhi, postSteve, postMark]
    }
    
    func getPostList() -> [Post] {
        return postList
    }
}
