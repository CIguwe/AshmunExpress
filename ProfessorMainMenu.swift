//
//  TeacherMainMenuView.swift
//  AshmunExpress
//
//  Created by Kameron Hayman on 6/7/19.
//  Copyright © 2019 CSC_Research. All rights reserved.
//

import Foundation
import UIKit

class teacherMainMenuView: UIViewController {
    @IBOutlet weak var assessment: UITableViewCell!
    var assess = [""]
    var userID = [""]
    var section = [""]
    var level = [""]
    var attempt = [""]
    var time = [""]
    var score = [""]
    let downloadAssesment = "http://learningexpressapp.com/Application/down/pullStudentData/pullData.php"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retriveData(assessID: assess, user_id: userID, section: section, Level: level, userAttempts: attempt, userTime: time, userScore: score)
    }
    
    func retriveData(assessID assess:[String], user_id user:[String], section S_ection:[String], Level l_evel:[String], userAttempts attempt:[String], userTime time:[String], userScore score:[String]){
        
        let request = NSMutableURLRequest(url: NSURL(string: downloadAssesment)! as URL)
        //request.httpMethod = "POST"
        //let postString = "&Section=\(sec)&Level=\(level)"
        request.httpBody = downloadAssesment.data(using:String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with:request as URLRequest) {
            (data,response, err) in
            do{
                if let data = data{
                    print("responseString=\(data)")//prints 1 or 0 success chance
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [[String]]
                    
                    print("responseString=\(responseJSON)")//prints 1 or 0 success chance
                    for i in 0..<responseJSON.count{
                        self.assess.insert(responseJSON[i][0], at: i)
                        self.userID.insert(responseJSON[i][1],at:i)
                        self.section.insert(responseJSON[i][2],at:i)
                        self.level.insert(responseJSON[i][3],at:i)
                        self.attempt.insert(responseJSON[i][4],at:i)
                        self.time.insert(responseJSON[i][5],at:i)
                        self.score.insert(responseJSON[i][6],at:i)
                    }
                    print(data)
                }
            }catch {  print ("Error:::::::\(error.localizedDescription)") }
            
            }.resume()
    }
    
}







