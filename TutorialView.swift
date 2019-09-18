import UIKit
class TutorialView: UIViewController {
    weak var delegate: PracticeView!
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var Next: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
 
    
    @IBOutlet weak var lbLKeyTerms: UILabel!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnOne: UIButton!
  
    let tableOfOut = UIImage(named: "tableofoutcomes")
    var Choice = [String]()
    var USER = String()
    let downLoadQuestion = "http://learningexpressapp.com/Application/down/testTutorial/getQuestion.php"//url for php file
    var questions = [""]
    var count = 0
    var examStart = false
    var isUserDone = false

    func AnswerWarning(msg:String,titl:String){
        let alert = UIAlertController(title: titl, message:msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        self.present(alert,animated:true,completion:nil)
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        Question.text = "\nAre you ready to begin?"
        Next.setTitle("Get Started", for: .normal)
        self.count = 0
        self.Next.layer.cornerRadius = 23
 
        retriveData(userSection: Choice[1], userLevel: Choice[3])
        hideKeyTerms()
        let MainMenuButton = UIBarButtonItem(image: UIImage(named: "LElogo"), style: .plain, target: self, action: #selector(MainMenuButtonTapped))
        self.navigationItem.rightBarButtonItem = MainMenuButton
        
        
        //MAKES LABEL BECOME TAPPABLE -------- This may be usefull later
        //let tap = UITapGestureRecognizer(target:self, action: #selector(TutorialView.LabelTapped))
        //Question.isUserInteractionEnabled = true
        //Question.addGestureRecognizer(tap)

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

    /* ----------------------------------                      This works with the UITapGestureRecognizer inside of view did load
    @objc func LabelTapped(sender:UITapGestureRecognizer){
        popTip.actionAnimation = .bounce(10)
        popTip.shouldDismissOnTap = true/Users/admin1/Desktop/Swift/LearningExpress_1t/TestView.swift
        popTip.show(text: outcomes+finiteSet+infiniteSet , direction: .down, maxWidth: 300, in: view, from: Question.frame)
    } */
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
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuID") as! UINavigationController
            //self.present(vc, animated: true, completion: nil)
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let destionationView = storyboard.instantiateViewController(withIdentifier: "ExampleID") as! ExampleView
            destionationView.Choice = Choice
            destionationView.delegate = self
            self.navigationController?.pushViewController(destionationView, animated: true)
            //self.present(destionationView, animated: true, completion: nil)
            //self.navigationController?.present(destionationView, animated: true, completion: nil)
            
        }else {
            
            if self.questions[self.count] != ""{
                displayImage()
                displayDefinitions()
                self.examStart = true
                
                Next.setTitle("Next", for: .normal)
                Question.text = "\(self.questions[self.count])"
                self.count = self.count + 1 
                
            }else if self.questions[self.count] == ""{
                hideKeyTerms()// hides all boxes
                self.examStart = false
                self.isUserDone = true
                ImageView.isHidden = true
                Question.text = "\nNext Section:\n\n\(Choice[1]) Example Problems \n\nLevel \(Choice[3])"//Question category and text
                Next.setTitle("Next", for: .normal)
               
            }
            
        }
       

    }
    
    func displayImage() {
        // This is the section for probability
        if Choice[1] == "Probability"{
            if Choice[3] == "2" {
                if self.count == 0 {
                    ImageView.isHidden = false
                    ImageView.image = tableOfOut
                }else if self.count == 1 {
                    ImageView.isHidden = true
                    // ImgView.image = DiceImage
                }else if self.count == 2 {
                    ImageView.isHidden = true
                    // ImgView.image = DiceImage
                }else if self.count == 3 {
                    ImageView.isHidden = true
                }else if self.count == 4 {
                    ImageView.isHidden = true
                    //  ImgView.image = chromosomeImage
                }else if self.count == 5 {
                    ImageView.isHidden = true
                } else{
                    ImageView.isHidden = true
                }
            }else if Choice[3] == "2"{
                ImageView.isHidden = true
            }else if Choice[3] == "3"{
                ImageView.isHidden = true
            }
        }
    }
   
    
    func displayDefinitions(){
        if Choice[1] == "Probability"{
            
            if Choice[3] == "1"{
                //
                //Makes all buttons needed visible
                unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: false, btn5: false, btn6: true, btn7: true, btn8: true, lblbtn: false)
                //
                // This block of code is what changes the color from black to orange
                // You have to know where the specfic character is for the word you are looking for. I reccommend using some word count software online
                var Mutablequest = NSMutableAttributedString()
                Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:71,length:6))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:78,length:9))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:560,length:7))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:574,length:8))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:809,length:6))
                Question.attributedText = Mutablequest
                //
                // Changing the title of the buttons I am going to be using
                btnOne.setTitle("Random", for: .normal)
                btnTwo.setTitle("Event", for: .normal)
                btnThree.setTitle("Outcome", for: .normal)
                btnFour.setTitle("Finite", for: .normal)
                btnFive.setTitle("Infinite", for: .normal)
            } else if Choice[3] == "2"{
                //
                //Makes all buttons needed visible
                unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: true, btn5: true, btn6: true, btn7: true, btn8: true, lblbtn: true)
                //
                // This block of code is what changes the color from black to orange
                // You have to know where the specfic character is for the word you are looking for. I reccommend using some word count software online
                var Mutablequest = NSMutableAttributedString()
                Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                
                
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:3,length:11))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:305,length:9))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:440,length:19))
                // Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1371,length:11))
                Question.attributedText = Mutablequest
                //
                // Changing the title of the buttons I am going to be using
                btnOne.setTitle("Probability", for: .normal)
                btnTwo.setTitle("Outcomes", for: .normal)
                btnThree.setTitle("Multiplicative Law", for: .normal)
                // btnFour.setTitle("Event Space", for: .normal)
                
            }
            
            
        } else if Choice[1] == "Monohybrid"{
            if Choice[3] == "1"{
                //
                //Makes all buttons needed visible
                unhideKeyTerms(btn1: false, btn2: false, btn3: false, btn4: false, btn5: false, btn6: false, btn7: false, btn8: false, lblbtn: false)
                //
                // This block of code is what changes the color from black to orange
                // You have to know where the specfic character is for the word you are looking for. I reccommend using some word count software online
                var Mutablequest = NSMutableAttributedString()
                Mutablequest = NSMutableAttributedString(string: self.questions[self.count])
                
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:2,length:10))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:101,length:6))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:141,length:10))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:781,length:8))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:986,length:10))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1287,length:10))
                //
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1288,length:19))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1346,length:8))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1420,length:20))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:1564,length:12))
                
                //
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:2128,length:8))
                Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:2140,length:9))
                Question.attributedText = Mutablequest
                //
                // Changing the title of the buttons I am going to be using
                btnOne.setTitle("Monohybrid", for: .normal)
                btnTwo.setTitle("Allele", for: .normal)
                btnThree.setTitle("Dominant", for: .normal)
                btnFour.setTitle("Recessive", for: .normal)
                btnFive.setTitle("Homozygous", for: .normal)
                btnSix.setTitle("Heterozygous", for: .normal)
                btnSeven.setTitle("Genotype", for: .normal)
                btnEight.setTitle("Phenotype", for: .normal)
            }
        }
        
    }
    // choice[3] means level screen or view controller
    // All of the button action below handle any click of the visible buttons a user sees
    @IBAction func ButtonOne(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1"{
            AnswerWarning(msg: "Made, done, happening, or chosen without method or conscious decision.", titl: "Random")
        }else if Choice[1] == "Probability" && Choice[3] == "2"{
            AnswerWarning(msg: "The likelihood of somethikng happening.", titl: "Probability")
        }
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "A genetic cross between individuals with different alleles for one gene.", titl: "Monohybrid")
        }
    }
    
    @IBAction func ButtonTwo(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1"{
            AnswerWarning(msg: "The probability that either event A or event B occurs is equal to the probability that event A occurs plus the probability that event B occurs. ", titl: "Additive Rule")
        } else if Choice[1] == "Probability" && Choice[3] == "2"{
            AnswerWarning(msg: "The result of an experiment. ", titl: "Outcome")
        }
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "An alternate form of a gene.", titl: "Allele")
        }
    }
    
    @IBAction func ButtonThree(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1"{
            AnswerWarning(msg: "The result of an experiment", titl: "Outcome")
        }else if Choice[1] == "Probability" && Choice[3] == "2"{
            AnswerWarning(msg: " If an experiment can be done in multiple independent stages with n1 being the number of possible outcomes  of the stage 1, n2 being the number of possible outcomes  of the stage 2, and so on. Then the total number of possible outcomes of the whole experiment is N = n1 x n2 × ⋯ "
                , titl: "Multiplicative Rule")
        }
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "The more influential allele that will be observable if the organism has it.", titl: "Dominant")
        }
    }
    
    
    @IBAction func ButtonFour(_ sender: Any) {
        if Choice[1] == "Probability" && Choice[3] == "1"{
            AnswerWarning(msg: "A finite set is a set that has a limited (finite) amount of elements.\nEx: How many oceans touch the U.S.A? ", titl: "Finite")
        }else if Choice[1] == "Probability" && Choice[3] == "2"{
            AnswerWarning(msg: "Event Space Definition", titl: "Event Space")
        }
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "A trait that is only expressed if the individual has two copies of the recessive allele.", titl: "Recessive")
        }
    }
    
    @IBAction func ButtonFive(_ sender: Any) {
        if Choice[1] == "Probability"{
            AnswerWarning(msg: "An infinite set has an unlimited amount of elements.\n Ex: How many stars surround Earth? An Infinite amount.", titl: "Infinite")
        }
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "When an individual has two identical alleles for one gene.", titl: "Homozygous")
        }
    }
    
    @IBAction func ButtonSix(_ sender: Any) {
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "When an individual has two different alleles for one gene.", titl: "Heterozygous")
        }
    }
    
    @IBAction func ButtonSeven(_ sender: Any) {
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "The genetic makeup of an organism.", titl: "Genotype")
        }
    }
    
    @IBAction func ButtonEight(_ sender: Any) {
        if Choice[1] == "Monohybrid"{
            AnswerWarning(msg: "Observable characteristics that can be seen or measured.", titl: "Phenotype")
        }
    }
    
    
    
}
//Creates the IMAGE for ViewController
/*imgView = UIImageView(frame: CGRect(x:20,y:333,width:343,height:80))
 
 imgView.image = image
 
 //imgView.translatesAutoresizingMaskIntoConstraints = false
 let bottonHeight = imgView.heightAnchor.constraint(equalToConstant: 80)
 let bottonWidth = imgView.widthAnchor.constraint(equalToConstant: 343)
 let topContraint = imgView.topAnchor.constraint(equalTo: self.Question.bottomAnchor)
 let leftContraint = imgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
 let rightContraint = imgView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
 
 imgCons = [topContraint,leftContraint,rightContraint,bottonWidth,bottonHeight]
 NSLayoutConstraint.activate(imgCons)
 view.addSubview(imgView)
 Question.font = UIFont.systemFont(ofSize: 20)
 
 //Changes the font color of a label
 //LabelButton.attributedTitle(for: Mutablequest)
 //LabelButton = UIButton(type: UIButtonType.system)
 //LabelButton.setTitle(quest, for: UIControlState.normal)
 
 //Creates the Second Label for ViewController
 let label2: UILabel = UILabel()
 label2.frame = CGRect(x:16 , y: 418, width: 343, height: 106)
 label2.font = UIFont.systemFont(ofSize: 17)
 label2.numberOfLines = 0
 label2.lineBreakMode = .byWordWrapping
 label2.text = "An event consists of all possible outcomes of interest. The probability of an event is the sum of the probabilities of all the members of event."
 self.view.addSubview(label2)
 
 
 var Mutablequest = NSMutableAttributedString()
 Mutablequest = NSMutableAttributedString(string: quest)
 Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:82,length:8))
 Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:497,length:6))
 Mutablequest.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: NSRange(location:511,length:8))
 Question.attributedText = Mutablequest
 Question.text = quest
 Question.sizeToFit()
 
 ImageView.contentMode = .scaleToFill
 ImageView.image = image
 ImageView.isHidden = false
 var Mutablequest2 = NSMutableAttributedString()
 Mutablequest2 = NSMutableAttributedString(string: quest2)
 Mutablequest2.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.orange, range: NSRange(location:3,length:5))
 Question2.attributedText = Mutablequest2
 Question2.text = quest2
 
 Question2.sizeToFit()
 
 self.isUserDone = true
 self.Next.setTitle("Done", for: .normal)
 */
