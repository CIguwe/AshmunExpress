import UIKit
import Foundation
//
//
// This code is only placed here but if you self.hideKeyboardWhenTappedAround() in any view controller's viewDidLoad
// it will work for allowing the user to click anywhere on the screen and the keyboard will be removed
//
// This makes the user click the Next button twice because its closing the keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginSwitch: UISwitch!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    let downLoadData = "http://learningexpressapp.com/Application/down/findUser.php"//url for php file
    var login = 3

    func ErrorWarning(msg:String,titl:String){
        let alert = UIAlertController(title: titl, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:{ (result)-> Void in print("OK clicked") })
        alert.addAction(okAction)
        self.present(alert,animated:true,completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainMenuSegueID"{
            if let navVC = segue.destination as? UINavigationController {
                if let childVC = navVC.topViewController as? MainMenuView{ childVC.USER = userName.text! }
            }
        }else if segue.identifier == "TeacherMainMenuSegueID"{
            if let navVC = segue.destination as? UINavigationController {
                if let childVC = navVC.topViewController as? TeacherMainMenuView{ childVC.USER = userName.text! }
            }
        }else if segue.identifier == "WelcomeLoginSegueID"{
            if segue.destination is WelcomeView {
                let vc = segue.destination as? WelcomeView
                vc?.USER = userName.text!
                vc?.login = GetLogin()
            }
        }
        
        
    }
    
    func SetLogin(val:Int){
        self.login = val
    }
    func GetLogin()->Int{
        return self.login
    }
    func initializeTextFields() {
        userName.delegate = self
        userPassword.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        loginSwitch.isOn = false
        self.signInBtn.layer.cornerRadius = 23
        self.createBtn.layer.cornerRadius = 23
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func keyboardWillChange(notification:Notification){
        //print ("Keyboard will show:\(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y  = 0
        }
        
    }
    
    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func isLoggedIn() -> Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    @IBAction func LogInSwitch(_ sender: UISwitch) {
        if(sender.isOn == true){
           UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            //SetLogin(val: )
        }//this code needs to be written.....
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        userName.resignFirstResponder()
        userPassword.resignFirstResponder()
        return true
    }
    
    
    @IBAction func UserSignIn(_ sender: Any) {
        if (userName.text == "" || userPassword.text == "") { ErrorWarning(msg: "Please Enter Username And Password", titl:"Login Failed")
        }else{
            
            let request = NSMutableURLRequest(url: NSURL(string: downLoadData)! as URL)
            request.httpMethod = "POST"
            let postString = "&name=\(userName.text!)&pass=\(userPassword.text!)"
            request.httpBody = postString.data(using:String.Encoding.utf8)
            
            let session = URLSession.shared
            session.dataTask(with:request as URLRequest) {
                (data,response, err) in
                do{
                    if let data = data{
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Int]
                        //print("responseString=\(responseJSON)")//prints 1 or 0 success chance
                        if  responseJSON["success"] == 1{//Throws a successful login or fail
                            self.SetLogin(val: 1)
                            DispatchQueue.main.async {
                                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
                                self.present(vc, animated: true, completion: nil)*/
                                self.performSegue(withIdentifier: "MainMenuSegueID", sender: self)
                            }
                        }else if responseJSON["success"] == 2{
                            self.SetLogin(val: 2)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "TeacherMainMenuSegueID", sender: self)
                            }
                        }else if responseJSON["success"] == 3{
                            self.SetLogin(val: 3)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "WelcomeLoginSegueID", sender: self)
                            }
                        }else if responseJSON["success"] == 4{
                            self.SetLogin(val: 4)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "WelcomeLoginSegueID", sender: self)
                            }
                        }
                        
                    }
                }catch {
                    DispatchQueue.main.async {
                        self.ErrorWarning(msg: "Incorrect Username or Password", titl:"Login Failed")
                    }
                }
                
                }.resume()
        }
    }

    
    
    
    
}

class FirstTimeView: UIViewController,UITextFieldDelegate {
    var USER = String()
    var login = 0
    
    func initializeTextFields() {
        //fname.delegate = self
        //Here you set the textfield delegate to self
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        //fname.resignFirstResponder()
        //Here you have to use .resignFirstResponder() to your textfield outlet
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //This is where you initialize the textfields
        //initializeTextFields()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstMainMenuSegueID"{
            if let navVC = segue.destination as? UINavigationController {
                if let childVC = navVC.topViewController as? MainMenuView{
                    childVC.USER = USER
                }
            }
        }
    }

    @IBAction func Click(_ sender: Any) {
        if login == 3{
            self.performSegue(withIdentifier: "firstMainMenuSegueID", sender: self)
        }
    }
    
    
    
    
}
class FirstTimeTeacherView: UIViewController,UITextFieldDelegate {
    var USER = String()
    var login = 0
    @IBOutlet weak var course_titleField: UITextField!
    @IBOutlet weak var course_numberField: UITextField!
    @IBOutlet weak var semesterField: UITextField!
    let sendCourse = "http://learningexpressapp.com/Application/up/sendCourse.php"//url for php file
    func initializeTextFields() {
        course_titleField.delegate = self
        course_numberField.delegate = self
        semesterField.delegate = self
        //Here you set the textfield delegate to self
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        course_titleField.resignFirstResponder()
        course_numberField.resignFirstResponder()
        semesterField.resignFirstResponder()
        //Here you have to use .resignFirstResponder() to your textfield outlet
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This is where you initialize the textfields
        initializeTextFields()
        self.hideKeyboardWhenTappedAround()
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstTeacherMainMenuSegueID"{
            if let navVC = segue.destination as? UINavigationController {
                if let childVC = navVC.topViewController as? TeacherMainMenuView{
                    childVC.USER = USER
                }
            }
        }
    }
    @objc func keyboardWillChange(notification:Notification){
        //print ("Keyboard will show:\(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y  = 0
        }
        
    }
    func sendData() {
        let request = NSMutableURLRequest(url: NSURL(string: sendCourse)! as URL)
        request.httpMethod = "POST"
        
        let postString = "title=\(course_titleField.text)&number=\(course_numberField.text)&user=\(USER)"
        
        request.httpBody = postString.data(using:String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with:request as URLRequest){
            data,response, error in
            if error != nil{
                print ("Error Starts:")
                print("error=\(error)")
                return
            }
            //This produces a response for the log of the added user
            //print("response = \(response)")
            
        }
        task.resume()
    }
    @IBAction func Click(_ sender: Any) {
        
        if login == 4{
            sendData()
            self.performSegue(withIdentifier: "firstTeacherMainMenuSegueID", sender: self)
        }
    }
    
    
    
    
    
}


class WelcomeView: UIViewController {
    var USER = String()
    var login = 0
    
    override func viewDidLoad() { super.viewDidLoad() }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "firstLoginTeacherSegueID"{
            if segue.destination is FirstTimeView {
                let vc = segue.destination as? FirstTimeView
                vc?.USER = USER
                vc?.login = login
            }
        }else if segue.identifier == "firstLoginSegueID"{
            if segue.destination is FirstTimeView {
                let vc = segue.destination as? FirstTimeView
                vc?.USER = USER
                vc?.login = login
            }
        }
    }
    
    
    @IBAction func GetStarted(_ sender: Any) {
        if login == 3{
            self.performSegue(withIdentifier: "firstLoginSegueID", sender: self)
        }else if login == 4{
            self.performSegue(withIdentifier: "firstLoginTeacherSegueID", sender: self)
        }
    }
    
    
    

}

