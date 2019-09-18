//
//  StudentView.swift
//  LearningExpress
//
//  Created by Admin1 on 6/8/18.
//  Copyright © 2018 CSC_Research. All rights reserved.
//

import UIKit
import Foundation

struct TableStats:Decodable {
    let assess_id: String
    let user_id: String
    let section: String
    let level: String
    let attempt: String
    let time_spent: String
    let score: String
    let first_name: String
}

class StudentView: UIViewController {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var sectionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var attemptLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    var table:TableStats?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfile.layer.cornerRadius = 60
        nameLbl.text = table?.user_id
        sectionLbl.text = table?.section
        levelLbl.text = table?.level
        attemptLbl.text = table?.attempt
        timeLbl.text = table?.time_spent
        scoreLbl.text = table?.score
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
}

/* This is suppose to be able to bring an image from the database and place it in the app
 
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
*/
