import UIKit
class PracticeView: UIViewController,UITextFieldDelegate {
    weak var delegate: ExampleView!
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
    var correctAnswers = 0
    var Answer = [""]
    var OptA = [""]
    var OptB = [""]
    var OptC = [""]
    var OptD = [""]
    var correctExplanation = [""]
    var incorrectExplanation = [""]
    var count = 0
    var attempts = 1
    var examStart = false
    var isUserDone = false
    var isTimeRunning = false
    var timer = Timer()
    var seconds = 00
    let downLoadQuestion = "http://learningexpressapp.com/Application/down/testPractice/getQuestion.php"//url for php file
    let sendAssessment = "http://learningexpressapp.com/Application/up/sendUserAssessment.php"//url for php file
    func initializeTextFields() {
        InputTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField:UITextField)-> Bool{
        InputTextField.resignFirstResponder()
        return true
    }
    deinit {
        //stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.isUserDone = false
        self.count = 0
        self.correctAnswers = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        if examStart == true {
            Next.setTitle("Back To Question", for: .normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        initializeTextFields()
        initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: true, inText: true)
        let MainMenuButton = UIBarButtonItem(image: UIImage(named: "LElogo"), style: .plain, target: self, action: #selector(MainMenuButtonTapped))
        self.navigationItem.rightBarButtonItem = MainMenuButton
        self.Next.layer.cornerRadius = 23
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        Question.text = "\nThis is a practice exam that will test your knowledge of course material.\n\nIf you fail to answer a question correctly 3 times you will be sent back to Tutorials.\n\n Just try to relax and do your best.\n\nAre you ready to begin?"
        Next.setTitle("Get Started", for: .normal)
        
        
        retriveData(userSection: Choice[1], userLevel: Choice[3])

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @objc func MainMenuButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
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
                        self.questions.insert(responseJSON[i][0],at: i)
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
    //
    //This func is used to hide or show multiple choice options, and input label, and text field
    func initializeQuestionView(a:Bool,b:Bool,c:Bool,d:Bool,inlabel:Bool,inText:Bool,inTextField:String) {
        OptionA.isHidden = a
        OptionB.isHidden = b
        OptionC.isHidden = c
        OptionD.isHidden = d
        Inputlabel.isHidden = inlabel
        InputTextField.isHidden = inText
        InputTextField.text = inTextField
    }
    func initializeQuestionView(a:Bool,b:Bool,c:Bool,d:Bool,inlabel:Bool,inText:Bool) {
        OptionA.isHidden = a
        OptionB.isHidden = b
        OptionC.isHidden = c
        OptionD.isHidden = d
        Inputlabel.isHidden = inlabel
        InputTextField.isHidden = inText
    }
    
    @IBAction func Next(_ sender: Any) {
       
        if self.isUserDone == true {
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
            //self.present(vc, animated: true, completion: nil)
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let destionationView = storyboard.instantiateViewController(withIdentifier: "TestID") as! TestView
            destionationView.Choice = Choice
            destionationView.delegate = self
            self.navigationController?.pushViewController(destionationView, animated: true)
        }else{
            if self.isTimeRunning == false{
                runTimer()//This starts the timer
                self.isTimeRunning = true
            }
           
            // ---------This code test to see if the user failed to answer the question 3 times
            //---------- It will then send him BACK to either Tutorial or Example
            if InputTextField.text?.lowercased() != self.Answer[self.count] && self.attempts == 2{
                self.examStart = false
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TutorialID")as! TutorialView
                vc.Choice = Choice
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            //------------------------------------------------------------------------------
            // ---------This code test to see if the user failed to answer the question
            //---------- If they failed then it will display a message for them to see how many attempts are left
            if InputTextField.text?.lowercased() != self.Answer[(self.count)] && self.attempts < 2 && self.examStart == true{
                Warning(msg:"\(self.incorrectExplanation[self.count])\n\nYou have \(3 - self.attempts) attempts left.", titl: "Incorrect")
                self.attempts = self.attempts + 1
                
                
            }else{
                
                if self.examStart == true && self.isUserDone == false{
                    Warning(msg:self.correctExplanation[self.count], titl: "Correct")
                    correctAnswers=correctAnswers+1
                    self.count = self.count + 1
                    
                    //any code for a correct answer should go here
                }
                self.examStart = true

    
                if self.OptA[self.count] == "" && self.questions[self.count] != ""{
                    initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: false, inText: false,inTextField:"")// makes multiple choice question not visible, also this function allows the inputfield to be reset back to being empty
                    Next.setTitle("Next", for: .normal)
                    Question.text = "\(self.questions[self.count])"
                    
                }else if self.questions[self.count] != ""{
                    initializeQuestionView(a: false, b: false, c: false, d: false, inlabel: false, inText: false,inTextField:"")// makes multiple choice question visible, also this function allows the inputfield to be reset back to being empty
                    Next.setTitle("Next", for: .normal)
                    Question.text = "\(self.questions[self.count])"
                    OptionA.text = "A. \(self.OptA[self.count])"
                    OptionB.text = "B. \(self.OptB[self.count])"
                    OptionC.text = "C. \(self.OptC[self.count])"
                    OptionD.text = "D. \(self.OptD[self.count])"
                    self.attempts = 0
                    
                } else{
                    stopTimer() // this contains the var that checks to see if user is done
                    initializeQuestionView(a: true, b: true, c: true, d: true, inlabel: true, inText: true)// makes multiple choice question not visible
                    if self.questions.count !=  1 {
                         let studentGrade = (Double(self.correctAnswers) / (Double(self.questions.count) - 1)) * 100
                        Question.text = "\nPractice Exam Over\n\n\n Score: \(studentGrade)%\n\n\nNext Section:\n\n\(Choice[1]) Test Problems \n\n\nLevel\(Choice[3])"
                        //SendAssessment(grade:studentGrade,timeSpent:timeString(time: TimeInterval(seconds)))
                    }else {Warning(msg: "Unable to retrive data from database.", titl: "Error") }
                    
                    Next.setTitle("Ready", for: .normal)
                    
                }
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
    func runTimer() { timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PracticeView.updateTimer), userInfo: nil, repeats: true) }
    func stopTimer() {
        timer.invalidate()
        self.isUserDone = true
        self.examStart = false
    }
    

    
    
    
    
    
    
    
    
    
}
