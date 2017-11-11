//
//  addListViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/11/10.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
class addListViewController: UIViewController {

    
    @IBOutlet weak var densityText: UITextField!
    @IBOutlet weak var volumeText: UITextField!
    
    let realm = try! Realm()
    
    var listD: ListD!
    var listV: ListV!
    
    var listDArray = try! Realm().objects(ListD.self)
    var listVArray = try! Realm().objects(ListV.self)
    
    
    @IBAction func addDensity(_ sender: Any) {
        listD = ListD()
        if listDArray.count != 0 {
            listD.id = listDArray.max(ofProperty: "id")! + 1
        }
        print("listD.id = \(listD.id)")
        print("densityText = \(densityText.text!)")
        try! realm.write {
            if self.densityText.text != nil {
              self.listD.listDensity = self.densityText.text!
            }
            self.realm.add(self.listD, update: true)
        }
        print("listDArray: \(listDArray)")
        self.densityText.text = ""
    }
    
    @IBAction func addVolume(_ sender: Any) {
        listV = ListV()
        if listVArray.count != 0 {
            listV.id = listVArray.max(ofProperty: "id")! + 1
        }
        try! realm.write {
            if Int(self.volumeText.text!) != nil {
            self.listV.listVolume = Int(self.volumeText.text!)!
            }
            self.realm.add(self.listV, update: true)
        }
        print("listVArray: \(listVArray)")
        self.volumeText.text = ""
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    // キーボードを閉じる
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
