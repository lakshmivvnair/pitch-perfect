//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Lakshmi Vineeth on 4/18/15.
//  Copyright (c) 2015 Amstel Coder. All rights reserved.
//

import Foundation

//  Model Class for Recorded Audio
class RecordedAudio: NSObject{

    //  Properties
    var filePathUrl: NSURL!
    var title: String!
    
    //  Initialiser
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
