//
//  Post.swift
//  ParseStarterProject-Swift
//
//  Created by Vinay Reddy Polati on 9/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation;
import Parse;

class Post {
    public let userId:String!;
    public let image:Data!;
    public let message:String?;
    
    init(withUserId:String, image:Data, message:String){
        self.userId = withUserId;
        self.image = image;
        self.message = message;
    }
}
