import UIKit

class CreateUserView: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repassword: UITextField!
    @IBOutlet weak var UserType: UIPickerView!
    @IBOutlet weak var submit: UIButton!
    
    var UserList = [String]()
    var SelectedUserValue = 0
    var selecteduser = ""
    let UpLoadData = "http://learningexpressapp.com/Application/up/sendUser.php"
    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    func initializeTextFields() {
        fname.delegate = self
        lname.delegate = self
        email.delegate = self
        userName.delegate = self
        password.delegate = self
        repassword.delegate = self
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        fname.resignFirstResponder()
        lname.resignFirstResponder()
        email.resignFirstResponder()
        userName.resignFirstResponder()
        password.resignFirstResponder()
        repassword.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint (x: 0, y: -320 ), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submit.layer.cornerRadius = 23
        initializeTextFields()
        self.hideKeyboardWhenTappedAround()
        loadUserType()
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view.
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
    func loadUserType(){
        let prof = "Professor"
        let stud = "Student"
        
        UserList.append(stud)
        UserList.append(prof)
    }
    func numberOfComponents(in :UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ UserType: UIPickerView, numberOfRowsInComponent commponent: Int) -> Int {
        return  UserList.count
    }
    func pickerView(_ UserType: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectedUserValue = row
    }
    @IBAction func Submit(_ sender: Any) {
        do{
            if (fname.text == ""){ErrorWarning(msg:"Please Enter First Name",titl:"Account Creation Error")}
            else if (lname.text == ""){ErrorWarning(msg:"Please Enter Last Name",titl:"Account Creation Error")}
            else if (email.text == ""){ErrorWarning(msg:"Please Enter Email",titl:"Account Creation Error")}
            else if (userName.text == ""){ErrorWarning(msg:"Please Enter User Name",titl:"Account Creation Error")}
            else if (password.text == ""){ErrorWarning(msg:"Please Enter Password",titl:"Account Creation Error")}
            else if (repassword.text == ""){ErrorWarning(msg:"Please Enter Password Again",titl:"Account Creation Error")}
            else if (!(password.text == repassword.text)){ErrorWarning(msg:"Passwords Do Not Match",titl:"Account Creation Error")}
            else{
                try SendData()
                
               /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! UINavigationController
                self.present(vc, animated: true, completion: nil)*/
            }
        }catch{
            print("Error!!!!!")
        }
    }
    //Sends New User To Database
    func SendData() throws {
        selecteduser = UserList[SelectedUserValue] // finds the value selected by pickerview
        let request = NSMutableURLRequest(url: NSURL(string: UpLoadData)! as URL)
        request.httpMethod = "POST"
        
        let postString = "f=\(fname.text!)&l=\(lname.text!)&e=\(email.text!)&u=\(userName.text!)&p=\(password.text!)&t=\(selecteduser)"
        
        request.httpBody = postString.data(using:String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with:request as URLRequest){
            data,response, error in
            if error != nil{
                print ("Error Starts:")
                print("error=\(error)")
                DispatchQueue.main.async {
                    self.ErrorWarning(msg: error!.localizedDescription, titl: "Account Creation Error")
                }
                return
            }
            //This produces a response for the log of the added user
            //print("response = \(response)")
            let responseString = NSString(data: data!,encoding: String.Encoding.utf8.rawValue)
            if responseString! == "Fail"{
                DispatchQueue.main.async {
                    self.userName.text = ""
                    self.password.text = ""
                    self.repassword.text = ""
                    self.ErrorWarning(msg: "Username already exits.", titl: "Account Creation Error")
                }
            }else{
                DispatchQueue.main.async {
                    self.ErrorWarning(msg: "Account has been created successfully.", titl: "Success")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginID") as! UINavigationController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    func ErrorWarning(msg:String,titl:String){
        let alert = UIAlertController(title: titl, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:{ (result)-> Void in print("OK clicked")})
        alert.addAction(okAction)
        self.present(alert,animated:true,completion:nil)
    }
}
