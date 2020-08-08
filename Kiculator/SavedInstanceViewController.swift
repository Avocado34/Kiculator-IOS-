//
//  SavedInstanceViewController.swift
//  Kiculator
//
//  Created by 이승기 on 2020/08/01.
//  Copyright © 2020 이승기. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class SavedInstanceviewController: UIViewController{
    
    var realm: Realm?
    var notificationToken: NotificationToken?
    var savedInstanceItems: Results<SavedInstanceCls>?
    
    @IBOutlet weak var savedInstanceScrollView: UIScrollView!
    
    @IBOutlet weak var appNameTF: UITextField!
    @IBOutlet weak var baseMinTF: UITextField!
    @IBOutlet weak var baseFeeTF: UITextField!
    @IBOutlet weak var feePerMinTF: UITextField!
    
    @IBOutlet weak var tableContentView: UIView!
    @IBOutlet weak var tableContentLabelView: UIView!
    @IBOutlet weak var savedInstanceTV: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // INIT REALM
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
        
        savedInstanceItems = realm?.objects(SavedInstanceCls.self)
        
        //push
        notificationToken = realm?.observe({ (noti, realm) in
            self.savedInstanceTV.reloadData()
        })
        // END
        
        
        setTextFieldLayout(appNameTF)
        setTextFieldLayout(baseMinTF)
        baseMinTF.keyboardType = .numberPad
        setTextFieldLayout(baseFeeTF)
        baseFeeTF.keyboardType = .numberPad
        setTextFieldLayout(feePerMinTF)
        feePerMinTF.keyboardType = .numberPad
        
        setTableViewLayout()

        setSavedInsatnceTableView()
        
        setRoundedButtonLayout(saveButton)
        
        setScrollViewDismissMode()
    }
    
    func setTextFieldLayout(_ button: UITextField){
        button.layer.backgroundColor = UIColor(named: "TextFieldBackgroundColor")?.cgColor
        button.layer.cornerRadius = 20
        setTextFieldPadding(button)
        
        button.delegate = self
    }
    
    func setSavedInsatnceTableView(){
        savedInstanceTV.delegate = self
        savedInstanceTV.dataSource = self
    }
    
    func setRoundedButtonLayout(_ button: UIButton){
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        button.layer.cornerRadius = 20
    }
    
    func setTextFieldPadding(_ textfield: UITextField){
        let paddingview: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textfield.frame.height))
        textfield.leftView = paddingview
        textfield.leftViewMode = .always
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func setTableViewLayout(){
        savedInstanceTV.layer.cornerRadius = 20
        tableContentLabelView.layer.cornerRadius = 20
        tableContentLabelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableContentView.layer.cornerRadius = 20
        tableContentView.layer.shadowOffset = .zero
        tableContentView.layer.shadowRadius = 10
        tableContentView.layer.shadowOpacity = 0.1
    }
    
    
    // tableView Swipe ACTION EVENT
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .normal, title: "삭제") { (action, view, completion) in
            
            try! self.realm?.write{
                self.realm?.delete(self.savedInstanceItems![indexPath.row])
            }
            self.savedInstanceTV.reloadData()
            completion(true)
        }
        
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = UIColor.red
        
        return action
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let instance = SavedInstanceCls()
        instance.appName = appNameTF.text ?? ""
        instance.baseFee = baseFeeTF.text ?? ""
        instance.baseMin = baseMinTF.text ?? ""
        instance.feePerMin = feePerMinTF.text ?? ""
        
        try! realm?.write{
            realm?.add(instance)
        }
        
        self.savedInstanceTV.reloadData()
        self.savedInstanceTV.endUpdates()
    }
    //END
    
    // tableView Click Action EVENT
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("savedInstance"), object: self.savedInstanceItems?[indexPath.row], userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    // END
    
    func setScrollViewDismissMode(){
        self.savedInstanceScrollView.keyboardDismissMode = .onDrag
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
}



extension SavedInstanceviewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        appNameTF.resignFirstResponder()
        baseFeeTF.resignFirstResponder()
        feePerMinTF.resignFirstResponder()
        
        return true
    }
}


extension SavedInstanceviewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        return savedInstanceItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.savedInstanceTV.dequeueReusableCell(withIdentifier: "SavedInsatnceTable", for: indexPath) as! SavedInstanceCell
        
        cell.appName.text = savedInstanceItems![indexPath.row].appName
        cell.baseFee.text = savedInstanceItems![indexPath.row].baseFee
        cell.feePerMin.text = savedInstanceItems![indexPath.row].feePerMin
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        
        return cell
    }
}

