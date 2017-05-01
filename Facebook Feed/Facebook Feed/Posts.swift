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
        
        let postBillGates = Post()
        postBillGates.name = "Bill Gates"
        postBillGates.profileImageName = "bill_gates_profile"
        postBillGates.statusText = "Success is a lousy teacher. It seduces smart people into thinking they can't lose.\n\n" +
            "Your most unhappy customers are your greatest source of learning.\n\n" +
        "As we look ahead into the next century, leaders will be those who empower others."
        postBillGates.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gates_background.jpg"
        
        let postTimCook = Post()
        postTimCook.name = "Tim Cook"
        postTimCook.profileImageName = "tim_cook_profile"
        postTimCook.statusText = "The worst thing in the world that can happen to you if you're an engineer that has given his life to something is for someone to rip it off and put their name on it."
        postTimCook.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/Tim+Cook.png"
        
        let postDonaldTrump = Post()
        postDonaldTrump.name = "Donald Trump"
        postDonaldTrump.profileImageName = "donald_trump_profile"
        postDonaldTrump.statusText = "An ‘extremely credible source’ has called my office and " +
        "told me that Barack Obama’s birth certificate is a fraud."
        postDonaldTrump.statusImageURL = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/trump_background.jpg"
        
        
        
       postList = [postGandhi, postSteve, postMark, postBillGates, postTimCook, postDonaldTrump]
    }
    
    func numberOfPosts() -> Int {
        return postList.count
    }
    
    subscript(indexPath: IndexPath) -> Post {
        get {
            return postList[indexPath.item]
        }
    }
}
