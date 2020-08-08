//
//  ViewController.swift
//  Kiculator
//
//  Created by 이승기 on 2020/07/31.
//  Copyright © 2020 이승기. All rights reserved.
//

import UIKit
import SQLite3
import RealmSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var savedItemButton: UIButton!
    
    @IBOutlet weak var baseFeeTF: UITextField!
    @IBOutlet weak var feePerMinTF: UITextField!
    @IBOutlet weak var rideTimeTF: UITextField!
    @IBOutlet weak var baseTimeTF: UITextField!
    
    @IBOutlet weak var finalFeeLabel: UILabel!
    @IBOutlet weak var llamaImageview: UIImageView!
    
    
    var savedInstanceItems: Results<SavedInstanceCls>?
    var realm: Realm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotificationCenter()
        
        setSavedItemButton()
        
        setFinalFeeLabel()
        setLlamaImageView()
        
        setBaseFeeTF()
        setFeePerMinTF()
        setRideTimeTF()
        setBaseTimeTF()
        setTextFieldListener()
        
        setCalcButton()
        
        setScrollViewDismissMode()
    }

    func setSavedItemButton(){
        savedItemButton.layer.cornerRadius = 10
        savedItemButton.layer.shadowOpacity = 0.5
        savedItemButton.layer.shadowRadius = 6
        savedItemButton.layer.shadowColor = UIColor.gray.cgColor
        savedItemButton.layer.shadowOffset = .zero
    }
    
    
    func setFinalFeeLabel(){
        finalFeeLabel.layer.masksToBounds = true
        finalFeeLabel.layer.shadowColor = UIColor.gray.cgColor
        finalFeeLabel.layer.shadowOffset = .zero
        finalFeeLabel.layer.shadowRadius = 3
        finalFeeLabel.layer.shadowOpacity = 0.5
    }
    
    func setBaseFeeTF(){
        baseFeeTF.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
        baseFeeTF.layer.cornerRadius = 20
        setTextFieldPadding(baseFeeTF)
        baseFeeTF.keyboardType = .numberPad
        
        baseFeeTF.delegate = self
    }
    
    func setFeePerMinTF(){
        feePerMinTF.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
        feePerMinTF.layer.cornerRadius = 20
        setTextFieldPadding(feePerMinTF)
        feePerMinTF.keyboardType = .numberPad
        
        feePerMinTF.delegate = self
    }
    
    func setRideTimeTF(){
        rideTimeTF.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
        rideTimeTF.layer.cornerRadius = 20
        setTextFieldPadding(rideTimeTF)
        rideTimeTF.keyboardType = .numberPad
        
        rideTimeTF.delegate = self
    }
    
    func setBaseTimeTF(){
        baseTimeTF.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
        baseTimeTF.layer.cornerRadius = 20
        setTextFieldPadding(baseTimeTF)
        baseTimeTF.keyboardType = .numberPad
        
        baseTimeTF.delegate = self
    }
    
    func setCalcButton(){
        calcButton.layer.shadowColor = UIColor.gray.cgColor
        calcButton.layer.shadowOffset = .zero
        calcButton.layer.shadowRadius = 10
        calcButton.layer.shadowOpacity = 0.5
        
        calcButton.layer.cornerRadius = 20
    }
    
    func setTextFieldPadding(_ textfield: UITextField){
        let paddingview: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textfield.frame.height))
        textfield.leftView = paddingview
        textfield.leftViewMode = .always
    }
    
    
    func setNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("savedInstance"), object: nil)
    }
    
    func setTextFieldListener(){
        self.baseFeeTF.addTarget(self, action: #selector(startTextFieldChanged), for: .editingChanged)
        self.feePerMinTF.addTarget(self, action: #selector(startTextFieldChanged), for: .editingChanged)
        self.baseTimeTF.addTarget(self, action: #selector(startTextFieldChanged), for: .editingChanged)
    }
    
    func setLlamaImageView(){
        llamaImageview.layer.shadowOpacity = 0.5
        llamaImageview.layer.shadowRadius = 3
        llamaImageview.layer.shadowOffset = .zero
        llamaImageview.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setScrollViewDismissMode(){
        self.mainScrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func startTextFieldChanged(_ textfield: UITextField){
        self.appNameLabel.isHidden = true
        print("startChanging")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @objc func didGetNotification(_ notification: Notification){
        let resultCls = notification.object as! SavedInstanceCls
        
        self.appNameLabel.isHidden = false
        
        self.appNameLabel.text = resultCls.appName as! String ?? ""
        self.baseFeeTF.text = resultCls.baseFee as! String ?? ""
        self.feePerMinTF.text = resultCls.feePerMin as! String ?? ""
        self.baseTimeTF.text = resultCls.baseMin as! String ?? ""
    }
    
    @IBAction func calcButtonAction(_ sender: Any) {
        if let baseFee =  Int(baseFeeTF.text ?? "0"){
            if let feePerMin = Int(feePerMinTF.text ?? "0"){
                if let rideTime = Int(rideTimeTF.text ?? "0"){
                    if let baseTime = Int(baseTimeTF.text ?? "0"){
                        if baseTime < rideTime{
                            let finalFee = (rideTime - baseTime) * feePerMin + baseFee
                            self.finalFeeLabel.text = String(finalFee)
                            
                            
                            self.savedInstanceItems = realm?.objects(SavedInstanceCls.self)

                            print(baseFee, feePerMin, rideTime, baseTime)
                        }else{
                            self.finalFeeLabel.text = baseFee as? String
                            
                        }
                    }
                }
            }
        }else{
            print("3")
        }
        
    }
    
    @IBAction func showSavedInstanceView(){
        let vc = storyboard?.instantiateViewController(identifier: "SavedInstanceView") as! SavedInstanceviewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showCreditsView(){
        let vc = storyboard?.instantiateViewController(identifier: "CreditsView") as! CreditsViewController
        present(vc, animated: true, completion: nil)
    }
}



extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        baseFeeTF.resignFirstResponder()
        feePerMinTF.resignFirstResponder()
        rideTimeTF.resignFirstResponder()
        baseTimeTF.resignFirstResponder()
        
        return true
    }
}
