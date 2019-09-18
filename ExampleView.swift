import UIKit
import Foundation
class ExampleView: UIViewController {
    weak var delegate: TutorialView!
    @IBOutlet weak var Next: UIButton!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var ImgView: UIImageView!
    var USER = String()
    var Choice = [String]()
    
    @IBOutlet weak var lbLKeyTerms: UILabel!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnOne: UIButton!
    let CoinImage = UIImage(named:"coin")
    let DiceImage = UIImage(named: "dice")
    let chromosomeImage = UIImage(named: "chromosome")
    let chromosomeImageII = UIImage(named: "chromosomeii")
    let downLoadQuestion = "http://learningexpressapp.com/Application/down/testExample/getQuestion.php"//url for php file

    var screen = 0
    var questions = [""]
    var count = 0
    var examStart = false
    var isUserDone = false

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyTerms()
        Question.text = "\nAre you ready to begin?"
        Next.setTitle("Get Started", for: .normal)
        self.Next.layer.cornerRadius = 23
        let MainMenuButton = UIBarButtonItem(image: UIImage(named: "LElogo"), style: .plain, target: self, action: #selector(MainMenuButtonTapped))
        self.navigationItem.rightBarButtonItem = MainMenuButton
        retriveData(userSection: Choice[1], userLevel: Choice[3])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.isUserDone = false
        self.count = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        if examStart != true {
            hideKeyTerms()
            Next.setTitle("Back To Question", for: .normal)
        }
    }
    @objc func MainMenuButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    func hideKeyTerms() {
        btnOne.isHidden = true
        btnTwo.isHidden = true
        btnThree.isHidden = true
        btnFour.isHidden = true
        btnFive.isHidden = true
        btnSix.isHidden = true
        btnSeven.isHidden = true
        btnEight.isHidden = true
        lbLKeyTerms.isHidden = true
    }
    func unhideKeyTerms(btn1:Bool,btn2:Bool,btn3:Bool,btn4:Bool,btn5:Bool,btn6:Bool,btn7:Bool,btn8:Bool,lblbtn:Bool) {
        btnOne.isHidden = btn1
        btnTwo.isHidden = btn2
        btnThree.isHidden = btn3
        btnFour.isHidden = btn4
        btnFive.isHidden = btn5
        btnSix.isHidden = btn6
        btnSeven.isHidden = btn7
        btnEight.isHidden = btn8
        lbLKeyTerms.isHidden = lblbtn
    }
    func AnswerWarning(msg:String,titl:String){
        let alert = UIAlertController(title: titl, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion:nil)
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
                        self.questions.insert(responseJSON[i][0], at: i)
                    }
                }
            }catch {  print ("Error:::::::\(error.localizedDescription)") }
            
            }.resume()
    }
    @IBAction func Next(_ sender: Any) {
 
        if self.isUserDone == true {
           // let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
           // self.present(vc, animated: true, completion: nil)
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let destionationView = storyboard.instantiateViewController(withIdentifier: "PracticeID") as! PracticeView
            destionationView.Choice = Choice
            destionationView.delegate = self
            self.navigationController?.pushViewController(destionationView, animated: true)
        }else{
            if self.questions[self.count] != "" {
                self.examStart = true
                displayImage() //checks to see if there is images for the example problems
                displayDefinitions() //checks to see if there is images for the example problems
                Next.setTitle("Next", for: .normal)
                Question.text = "\(self.questions[self.count])"
                self.count = self.count + 1
            } else if self.questions[self.count] == ""{
                self.examStart = false
                self.isUserDone = true
                self.ImgView.isHidden = true
                hideKeyTerms()
                Question.text = "\nNext Section:\n\n\(Choice[1]) Practice Problems \n\nLevel \(Choice[3])"
                Next.setTitle("Next", for: .normal)
                //ImgView.removeFromSuperview()
            }else{
                
            }
        }
    }
    
    
    // This function decides what image is displayed during the example view
    func displayImage() {
        // This is the section for probability
        if Choice[1] == "Probability"{
            if Choice[3] == "1" {
                if self.count == 0 {
                    ImgView.isHidden = false
                    ImgView.image = CoinImage
                }else if self.count == 1 {
                    ImgView.isHidden = false
                    ImgView.image = DiceImage
                }else if self.count == 2 {
                    ImgView.isHidden = false
                    ImgView.image = DiceImage
                }else if self.count == 3 {
                    ImgView.isHidden = true
                }else if self.count == 4 {
                    ImgView.isHidden = false
                    ImgView.image = chromosomeImage
                }else if self.count == 5 {
                    ImgView.isHidden = true
                } else{
                    ImgView.isHidden = true
                }
            }else if Choice[3] == "2"{
                if self.count == 0 {
                    ImgView.isHidden = true
                    
                }else if self.count == 1 {
                    ImgView.isHidden = true
                    
                }else if self.count == 2 {
                    ImgView.isHidden = true
                }else if self.count == 3 {
                    ImgView.isHidden = false
                    ImgView.image = chromosomeImageII
                    
                }else if self.count == 4 {
                    ImgView.isHidden = true
                }else if self.count == 5 {
                    ImgView.isHidden = true
                } else{
                    ImgView.isHidden = true
                }
            }else if Choice[3] == "3"{
                
            }
        }
        
        
        
        
    }
    
    func displayDefinitions(){
        if Choice[1] == "Probability"{
            
            if Choice[3] == "1"{
                //
                //Makes all buttons needed visible
                // btnOne.isHidden = false
                // btnTwo.isHidden = false
                // lbLKeyTerms.isHidden = false
                //
                // This block of code is what changes the color from black to orange
                // You have to know where the specfic character is for the word you are looking for. I reccommend using some word count software online
                if self.count == 0{
                    unhideKeyTerms(btn1: false, btn2: false, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:58,length:7))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:232,length:12))
                    Question.attributedText = Mutablequest
                    btnOne.setTitle("Sample Space", for: .normal)
                    btnTwo.setTitle("Outcome", for: .normal)
                    
                } else if self.count == 1 {
                    unhideKeyTerms(btn1: true, btn2: true, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: true)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:58,length:7))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:258,length:12))
                    Question.attributedText = Mutablequest
                    
                    
                } else if self.count == 2 {
                    unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: false, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:58,length:7))
                    Question.attributedText = Mutablequest
                    btnOne.setTitle("Event", for: .normal)
                    btnTwo.setTitle("Outcome", for: .normal)
                    btnThree.setTitle("Sample Space", for: .normal)
                    btnFour.setTitle("Additive Rule", for: .normal)
                }else if self.count == 3 {
                    unhideKeyTerms(btn1: true, btn2: true, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: true)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:3,length:13))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:385,length:13))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:477,length:5))
                    Question.attributedText = Mutablequest
                    
                }else if self.count == 4 {
                    unhideKeyTerms(btn1: true, btn2: true, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: true)
                    
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:243,length:12))
                    
                }else if self.count == 5 {
                    unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: false, btn5: false, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:266,length:13))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:440,length:5))
                    Question.attributedText = Mutablequest
                    Question.attributedText = Mutablequest
                    btnOne.setTitle("Allele", for: .normal)
                    btnTwo.setTitle("Chromosomes", for: .normal)
                    btnThree.setTitle("Gamete", for: .normal)
                    btnFour.setTitle("Sample Space", for: .normal)
                    btnFive.setTitle("Trait", for: .normal)
                }
                //
                // Changing the title of the buttons I am going to be using
                
                /* if self.count > 2{
                 btnThree.isHidden = false
                 btnThree.setTitle("Event", for: .normal)
                 }
                 if self.count >= 3{
                 btnFour.isHidden = false
                 btnFour.setTitle("Additive Rule", for: .normal)
                 }*/
            } else if Choice[3] == "2"{
                if self.count == 0{
                    
                    unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:330,length:19))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:398,length:11))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:581,length:11))
                    Question.attributedText = Mutablequest
                    btnOne.setTitle("Event Space", for: .normal)
                    btnTwo.setTitle("Multiplicative Law", for: .normal)
                    btnThree.setTitle("Outcomes", for: .normal)
                    
                } else if self.count == 1 {
                    
                    unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:42,length:9))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:624,length:13))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:355,length:19))
                    Question.attributedText = Mutablequest
                    btnOne.setTitle("Event Space", for: .normal)
                    btnTwo.setTitle("Multiplicative Law", for: .normal)
                    btnThree.setTitle("Outcomes", for: .normal)
                } else if self.count == 2 {
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:62,length:9))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:263,length:19))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:293,length:11))
                    Question.attributedText = Mutablequest
                }else if self.count == 3 {
                    unhideKeyTerms(btn1: true, btn2: true, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: true)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    /* Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:3,length:13))
                     Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:385,length:13))
                     Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:477,length:5))*/
                    Question.attributedText = Mutablequest
                    
                }else if self.count == 4 {
                    unhideKeyTerms(btn1: false, btn2: false, btn3: true, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: false)
                    var Mutablequest = NSMutableAttributedString()
                    Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:396,length:18))
                    Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:730,length:9))
                    Question.attributedText = Mutablequest
                    self.screen = 1
                    btnOne.setTitle("Multiplicative Law", for: .normal)
                    btnTwo.setTitle("Outcomes", for: .normal)
                    
                    
                }
                
                
            }
            
        }
    }
    
    @IBAction func ButtonOne(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 1{
            AnswerWarning(msg: "A sample space is a set of all possible outcomes for an experiment.", titl: "Sample Space")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 3{
            AnswerWarning(msg: "a thing that happens, especially one of importance.", titl: "Event")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 6{
            AnswerWarning(msg: "one of two or more alternative forms of a gene that arise by mutation and are found at the same place on a chromosome.", titl: "Allele")
        }else if Choice[1] == "Probability" && Choice[3] == "2" && self.screen == 0  {
            AnswerWarning(msg: "The likelihood of something happening.", titl: "Event Space")
        }else if Choice[1] == "Probability" && Choice[3] == "2" && self.screen == 1{
            
            AnswerWarning(msg: "If an experiment can be done in multiple independent stages with n1 being the number of possible outcomes  of the stage 1, n2 being the number of possible outcomes  of the stage 2, and so on. Then the total number of possible outcomes of the whole experiment is N = n1 x n2 × ⋯ ", titl: "Multiplicative Law")
            
        }
        
    }
    @IBAction func ButtonTwo(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 1{
            AnswerWarning(msg: "An outcome is the result of an experiment.", titl: "Outcome")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 3{
            AnswerWarning(msg: "The result of an experiment. ", titl: "Outcomes")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 6{
            AnswerWarning(msg: "a threadlike structure of nucleic acids and protein found in the nucleus of most living cells, carrying genetic information in the form of genes.", titl: "Chromosomes")
        }else if Choice[1] == "Probability" && Choice[3] == "2" && self.screen == 0{
            
            AnswerWarning(msg: "If an experiment can be done in multiple independent stages with n1 being the number of possible outcomes  of the stage 1, n2 being the number of possible outcomes  of the stage 2, and so on. Then the total number of possible outcomes of the whole experiment is N = n1 x n2 × ⋯ ", titl: "Multiplicative Law")
            
        }else if Choice[1] == "Probability" && Choice[3] == "2" && self.screen == 1{
            AnswerWarning(msg: "The result of an experiment. ", titl: "Outcomes")
            
        }
        
    }
    @IBAction func ButtonThree(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1" {
            AnswerWarning(msg: "An event is a set of possible outcomes that are being tested for.", titl: "Event")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 3{
            AnswerWarning(msg: "A sample space is a set of all possible outcomes for an experiment.", titl: "Sample Space")}
        else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 6{
            AnswerWarning(msg: "a mature haploid male or female germ cell which is able to unite with another of the opposite sex in sexual reproduction to form a zygote.", titl: "Gamete")
        }else if Choice[1] == "Probability" && Choice[3] == "2" {
            AnswerWarning(msg: "The result of an experiment. ", titl: "Outcomes")
            
        }
    }
    @IBAction func ButtonFour(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 3{
            AnswerWarning(msg: "The probability that either event A or event B occurs is equal to the probability that event A occurs plus the probability that event B occurs. ", titl: "Additive Rule")
        }else if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 6{
            AnswerWarning(msg: "A sample space is the range of values of a random variable.", titl: "Sample Space")
            
        }
    }
    @IBAction func ButtonFive(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1" && self.count == 6{
            AnswerWarning(msg: "Characteristics or attributes of an organism that are expressed by genes and/or influenced by the environment. ", titl: "Trait")
        }
    }
    @IBAction func ButtonSix(_ sender: Any) {
        
    }
    @IBAction func ButtonSeven(_ sender: Any) {
        
    }
    @IBAction func ButtonEight(_ sender: Any) {
        
    }
    
    
    
    
    
    
    
    
    
    
}




//    func retriveImage()->UIImageView{
//        // URL---IMAGE----
//        let requestImg = URL(string:downLoadCoinImage)
//        let sessionImg = URLSession.shared
//        sessionImg.dataTask(with:requestImg!) {
//            (data,response, err) in
//            do{
//
//                if let data = data{
//
//                     let CoinImage = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! UIImage
//                        print("IMAGE!!!!!!!!!!!!!!!!")
//
//                    self.imgView = UIImageView(frame: CGRect(x:20,y:333,width:343,height:80))
//                    self.imgView.contentMode = .scaleToFill
//                    self.imgView.image = CoinImage
//                }
//                else{
//                    print ("NONONO")
//                }
//            } catch { print ("Error:::::::\(error.localizedDescription)") }
//
//            }.resume()
//       return self.imgView
//    }
