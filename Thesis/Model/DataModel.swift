//
//  DataModel.swift
//  Thesis
//
//  Created by Gaurav Gudaliya on 15/04/21.
//

import Foundation


class ImageModel:NSObject{

    var name:String = ""
    var image:String = ""
    var object:[String:AnyObject] = [:]
    var score = 0
    init(name:String,image:String,object:[String:AnyObject]) {
        self.name = name
        self.image = image
        self.object = object
    }
}
