//
//  Assessment.swift
//  AshmunExpress
//
//  Created by Kameron Hayman on 6/14/19.
//  Copyright © 2019 CSC_Research. All rights reserved.
//

import UIKit

class Assessments: Codable{
    let assessments : [Assessment]
    
    init(assessments: [Assessment]) {
        self.assessments = assessments 
    }
    
}

class Assessment: Codable {
   
        let assess = [""]
        let userID = [""]
        let section = [""]
        let level = [""]
        let attempt = [""]
        let time = [""]
        let score = [""]
    
   
}
