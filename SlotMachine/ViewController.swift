//
//  ViewController.swift
//  SlotMachine
//
//  Created by Marko Budal on 30/12/14.
//  Copyright (c) 2014 Marko Budal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    var titleLabel:UILabel!
    
    //InformationLabels
    var creditsLabel:UILabel!
    var betLabel:UILabel!
    var winnerPaidLabel:UILabel!
    var creditsTitleLabel:UILabel!
    var betTitleLabel:UILabel!
    var winnerPAidTitleLabel:UILabel!
    
    // Buttons
    var resetButton:UIButton!
    var betOneButton:UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    var slots:[[Slot]] = []
    
    //Stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    let kMarginForView:CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0
    
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    
    let kSixth:CGFloat = 1.0/6.0
    let kThird:CGFloat = 1.0/3.0
    
    let kHalf:CGFloat = 1.0/2.0
    let kEight:CGFloat = 1.0/8.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        
        setupFirstContainer(firstContainer)
        //setupSecondContainer(secondContainer)
        setupThirdContainer(thirdContainer)
        setupFourtContainer(fourthContainer)
        
        hardReset()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBAction
    func resetButtonPressed(button:UIButton){
        //        println("Reset button pressed");
        hardReset()
    }
    
    func betOneButtonPressed(button: UIButton){
        if credits <= 0 {
            showAlertWithText(header: "No more Credits", message: "Reset Game")
        }else {
            if currentBet <= 5 {
                currentBet += 1
                credits -= 1
                updateMainView()
            }else{
                showAlertWithText(message: "You can only bet 5 credits at a time")
            }
        }
    }
    
    func betMaxButtonPressed(button: UIButton){
        if credits <= 5 {
            showAlertWithText(header: "Not Enought Credits", message: "Bet Less")
        }else{
            if currentBet < 5 {
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateMainView()
            }else{
                showAlertWithText(message: "You can only bet 5 credits at the time!")
            }
        }
    }
    
    func spinButtonPressed(button: UIButton){
        removeSlotImageViews()
        slots = Factory.createSlots()
        setupSecondContainer(secondContainer)
        
        var winningsMultiplier = SlotBrain.computeWinnings(slots)
        
        
        winnings = winningsMultiplier[0] * currentBet
        if winningsMultiplier[1] != 0 || winningsMultiplier[1] != 0 || winningsMultiplier[1] != 0 {
            alertWinnings(winningsMultiplier[1], threeOfAKindWinCount: winningsMultiplier[2], straighWinCount: winningsMultiplier[3])
        }
        credits += winnings
        currentBet = 0
        
        
        updateMainView()
    }
    
    
    //setUP functions
    func  setupContainerView(){
        
        self.firstContainer = UIView(frame: CGRect(
            x: self.view.bounds.origin.x + kMarginForView,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width - (kMarginForView * 2),
            height: self.view.bounds.height * kSixth)
        )
        self.firstContainer.backgroundColor = UIColor.redColor();
        view.addSubview(firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height, width: self.view.bounds.width - (2 * kMarginForView), height: self.view.bounds.height * (3 * kSixth)))
        secondContainer.backgroundColor = UIColor.blackColor()
        view.addSubview(secondContainer)
        
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height, width: self.view.bounds.width - (2 * kMarginForView), height: self.view.bounds.height * kSixth))
        thirdContainer.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        fourthContainer.backgroundColor = UIColor.blackColor()
        view.addSubview(fourthContainer)
    }
    
    func setupFirstContainer(containerView: UIView){
        self.titleLabel = UILabel()
        titleLabel.text = "Super Slots"
        titleLabel.textColor = UIColor.yellowColor()
        titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        titleLabel.sizeToFit()  // koliko velik more bit prostor
        titleLabel.center = containerView.center
        containerView.addSubview(titleLabel)
    }
    
    func setupSecondContainer(containerView: UIView){
        
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber {
            for var slotNumbar = 0; slotNumbar < kNumberOfSlots; ++slotNumbar{

                var slot:Slot
                var slotImageView = UIImageView()
                
                if slots.count != 0{
                    let slotContainer = slots[containerNumber]
                    slot = slotContainer[slotNumbar]
                    slotImageView.image = slot.image
                }else{
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumbar) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setupThirdContainer(containerView:UIView){
        
        self.creditsLabel = UILabel()
        creditsLabel.text = "000000"
        creditsLabel.textColor = UIColor.redColor()
        creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        creditsLabel.sizeToFit()
        creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        creditsLabel.textAlignment = NSTextAlignment.Center //samo za postavitev teksta
        creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(creditsLabel)
        
        self.betLabel = UILabel()
        betLabel.text = "0000"
        betLabel.textColor = UIColor.redColor()
        betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        betLabel.sizeToFit()
        betLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird)
        betLabel.textAlignment = NSTextAlignment.Center
        betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(betLabel)
        
        self.winnerPaidLabel = UILabel()
        winnerPaidLabel.text = "000000"
        winnerPaidLabel.textColor = UIColor.redColor()
        winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        winnerPaidLabel.sizeToFit()
        winnerPaidLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird)
        winnerPaidLabel.textAlignment = NSTextAlignment.Center
        winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        creditsTitleLabel.text = "Credits"
        creditsTitleLabel.textColor = UIColor.blackColor()
        creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        creditsTitleLabel.sizeToFit()
        creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird * 2)
        creditsTitleLabel.textAlignment = NSTextAlignment.Center
        containerView.addSubview(creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        betTitleLabel.text = "Bet"
        betTitleLabel.textColor = UIColor.blackColor()
        betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        betTitleLabel.sizeToFit()
        betTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(betTitleLabel)
        
        self.winnerPAidTitleLabel = UILabel()
        winnerPAidTitleLabel.text = "Winner paid"
        winnerPAidTitleLabel.textColor = UIColor.blackColor()
        winnerPAidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        winnerPAidTitleLabel.sizeToFit()
        winnerPAidTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(winnerPAidTitleLabel)
    }
    
    func setupFourtContainer(containerView:UIView){
        
        self.resetButton = UIButton()
        resetButton.setTitle("Reset", forState: UIControlState.Normal)  //State ker lahko imamo različne naslove glede na stanje gumba
        resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal) //razlicne barve za razlicna stanja
        resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)  //? uporabimo zato, ker lahko se zgodi da nebi imeli Title, in pol ne moremo nastavit fonta ce ne obstaja
        resetButton.backgroundColor = UIColor.lightGrayColor()
        resetButton.sizeToFit()
        resetButton.center = CGPoint(x: containerView.frame.width * kEight, y: containerView.frame.height * kHalf)
        resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        //ko uporabnik klikne gumb poclje podatek sebi, ki pol poslje akcijo resetButtonPressed:
        containerView.addSubview(resetButton)
        
        self.betOneButton = UIButton()
        betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        betOneButton.backgroundColor = UIColor.greenColor()
        betOneButton.sizeToFit()
        betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEight, y:  containerView.frame.height * kHalf)
        betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betOneButton)
        
        self.betMaxButton = UIButton()
        betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        betMaxButton.backgroundColor = UIColor.redColor()
        betMaxButton.sizeToFit()
        betMaxButton.center = CGPoint(x: firstContainer.frame.width * kEight * 5, y: containerView.frame.height * kHalf)
        betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(betMaxButton)
        
        self.spinButton = UIButton()
        spinButton.setTitle("Spin", forState: UIControlState.Normal)
        spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        spinButton.backgroundColor = UIColor.greenColor()
        spinButton.sizeToFit()
        spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEight, y: containerView.frame.height * kHalf)
        spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(spinButton)
        
    }
    
    func removeSlotImageViews () {
    
        if self.secondContainer != nil{
            let container : UIView? = self.secondContainer!
            let subViews:Array? = container!.subviews
            for view in subViews! {
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset(){
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        setupSecondContainer(secondContainer)
        
        credits = 50
        winnings = 0
        currentBet = 0
        
        updateMainView()
    }
    
    func updateMainView(){
        creditsLabel.text = "\(credits)"
        betLabel.text = "\(currentBet)"
        winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertWithText(header:String = "Worning", message:String){
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)  // tukaj pripravimo kako bo alert zgledal
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        //tu mu dodamo akcijo, da lahko alert odstrani
        self.presentViewController(alert, animated: true, completion: nil)
        //to pa zato da se dejansko predstavi
        
    }
    
    //Helper Function
    func alertWinnings(flushCount: Int, threeOfAKindWinCount: Int, straighWinCount: Int) {
        
        let message = "Flush: \(flushCount), Three in a row: \(threeOfAKindWinCount), Three of a Kind: \(straighWinCount)"
        let alertController = UIAlertController(title: "Winnings", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

