import UIKit

class TestView: UIViewController {
    weak var delegate:PracticeView!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var OptionA: UILabel!
    @IBOutlet weak var OptionB: UILabel!
    @IBOutlet weak var OptionC: UILabel!
    @IBOutlet weak var OptionD: UILabel!
    @IBOutlet weak var Inputlabel: UILabel!
    @IBOutlet weak var InputTextField: UITextField!
    @IBOutlet weak var Next: UIButton!
    
    var USER = String()
    var Choice = [String]()
    var questions = [""]
    var questions2 = [""]
    var ID = [""]
    var Answer = [""]
    var OptA = [""]
    var OptB = [""]
    var OptC = [""]
    var OptD = [""]
    var correctExplanation = [""]
    var incorrectExplanation = [""]
    var count = 0
    var attempts = 1
    var correctAnswers = 0
    var examStart = false
    var isUserDone = false
    
    var timer = Timer()
    var seconds = 00
    var isTimeRunning = false
    
    let downLoadQuestion = "http://learningexpressapp.com/Application/down/testTest/getQuestion.php"//url for php file
    let sendAssessment = "http://learningexpressapp.com/Application/up/sendUserAssessment.php"//url for php file

    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        self.hideKeyboardWhenTappedAround()
        initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: true, inText: true)
        self.Next.layer.cornerRadius = 23
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        Question.text = "\nThis is your chance to show what you have learned.\n\nGood luck and have fun!"
        
        Next.setTitle("Begin", for: .normal)
        retriveData(userSection: Choice[1], userLevel: Choice[3])
        
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.isUserDone = false
        self.count = 0
        self.correctAnswers = 0
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
    
    func initializeTextFields() {
        //InputTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        //InputTextField.resignFirstResponder()
        return true
    }
    func SendAssessment(grade:Double,timeSpent:String) {
        let request = NSMutableURLRequest(url: NSURL(string: sendAssessment)! as URL)
        request.httpMethod = "POST"
            
        let postString = "user=\(USER)&sect=\(Choice[1])&level=\(Choice[3])&time=\(timeSpent)&score=\(grade)"
            print(USER)
            print(Choice[1])
            print(Choice[3])
            print(timeSpent)
            print(grade)
            request.httpBody = postString.data(using:String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with:request as URLRequest){
                data,response, error in
                if error != nil{
                    print ("Error Starts:")
                    print("error=\(error)")
                    return
                }
                //This produces a response for the log of the added user
                print("response = \(response)")
                
            }
            task.resume()
        
    }
    //This will retrive data from the database
    // which in connected to a php scipt file found in the database
    func retriveData(userSection sec:String, userLevel level:String ){
        let request = NSMutableURLRequest(url: NSURL(string: downLoadQuestion)! as URL)
        request.httpMethod = "POST"
        let postString = "&Section=\(sec)&Level=\(level)"
        request.httpBody = postString.data(using:String.Encoding.utf8)
        
        let session = URLSession.shared
        session.dataTask(with:request as URLRequest) {
            (data,response, err) in
            do{
                if let data = data{
                    print("responseString=\(data)")//prints 1 or 0 success chance
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [[String]]
                    
                    print("responseString=\(responseJSON)")//prints 1 or 0 success chance
                    for i in 0..<responseJSON.count{
                        self.questions.insert(responseJSON[i][0], at: i)
                        self.Answer.insert(responseJSON[i][1],at:i)
                        self.OptA.insert(responseJSON[i][2],at:i)
                        self.OptB.insert(responseJSON[i][3],at:i)
                        self.OptC.insert(responseJSON[i][4],at:i)
                        self.OptD.insert(responseJSON[i][5],at:i)
                        self.incorrectExplanation.insert(responseJSON[i][6],at:i)
                        self.correctExplanation.insert(responseJSON[i][7],at:i)
                    }
                }
            }catch {  print ("Error:::::::\(error.localizedDescription)") }
            
            }.resume()
    }
    
    func Warning(msg:String,titl:String){
        let alert = UIAlertController(title: titl, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion:nil)
    }
    func initializeQuestionView(a:Bool,b:Bool,c:Bool,d:Bool,inlabel:Bool,inText:Bool) {
        OptionA.isHidden = a
        OptionB.isHidden = b
        OptionC.isHidden = c
        OptionD.isHidden = d
        Inputlabel.isHidden = inlabel
        InputTextField.isHidden = inText
    }
    func initializeQuestionView(a:Bool,b:Bool,c:Bool,d:Bool,inlabel:Bool,inText:Bool,inTextField:String) {
        OptionA.isHidden = a
        OptionB.isHidden = b
        OptionC.isHidden = c
        OptionD.isHidden = d
        Inputlabel.isHidden = inlabel
        InputTextField.isHidden = inText
        InputTextField.text = inTextField
    }
    @IBAction func Next(_ sender: Any) {
        
        if self.isUserDone == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }else{
                if self.isTimeRunning == false{
                    runTimer()//This starts the timer
                    self.isTimeRunning = true
                }
            
                // This check to see if the answer is correct
                if InputTextField.text?.lowercased() != self.Answer[(self.count)]{
                    if self.examStart == true && self.isUserDone == false{
                        Warning(msg: self.incorrectExplanation[self.count], titl: "Incorrect")
                        self.count = self.count + 1
                        //any code for a incorrect answer should go here
                    }
                }else{
                    if self.examStart == true && self.isUserDone == false{
                        Warning(msg: self.correctExplanation[self.count], titl: "Correct")
                        self.count = self.count + 1
                        self.correctAnswers = self.correctAnswers + 1
                        //any code for a correct answer should go here
                    }
                }
            
                self.examStart = true // this will make sure the exam has started
            
            
                if self.OptA[self.count] == "" && self.questions[self.count] != ""{
                    initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: false, inText: false,inTextField: "")

                    Next.setTitle("Next", for: .normal)
                    Question.text = "\(self.count+1).) \(self.questions[self.count])"
                }else if self.questions[self.count] != ""{
                    initializeQuestionView(a: false, b: false, c: false, d: false, inlabel: false, inText: false,inTextField: "")
                    Next.setTitle("Next", for: .normal)
                    Question.text = "\(self.count+1).) \(self.questions[self.count])"
                    OptionA.text = "A. \(self.OptA[self.count])"
                    OptionB.text = "B. \(self.OptB[self.count])"
                    OptionC.text = "C. \(self.OptC[self.count])"
                    OptionD.text = "D. \(self.OptD[self.count])"
                    
                } else {
                    stopTimer() // this contains the var that checks to see if user is done
                    initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: true, inText: true,inTextField: "")
                    print(self.questions.count)
                    print(self.correctAnswers)
                    if self.questions.count !=  1 {
                        let studentGrade = (Double(self.correctAnswers) / (Double(self.questions.count) - 1)) * 100
                        //print(studentGrade)
                        
                        Question.text = "\t\n\n Score: \(studentGrade)%"
                        SendAssessment(grade:studentGrade,timeSpent:timeString(time: TimeInterval(seconds))) // This sends the users result to the database
                    }else {Warning(msg: "Unable to retrive data from database.", titl: "Error") }
                    
                    
                    Next.setTitle("Done", for: .normal)
                }
            
            }
    }
        
    @objc func updateTimer() {
        seconds+=1
        //print( timeString(time: TimeInterval(seconds)) ) //This allows you to view the timer running
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time)/3600
        let minutes = Int(time)/60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    func stopTimer() {
        timer.invalidate()
        self.isUserDone = true
        self.examStart = false
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TestView.updateTimer), userInfo: nil, repeats: true)
    }
    

}
