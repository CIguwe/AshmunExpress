import UIKit

class SettingsView: UIViewController {
    @IBOutlet weak var userProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProfile.layer.cornerRadius = 120
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
