//
//  MeasureViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift

class MeasureViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    var postdata: PostData!
    var data: Data!
    var rlmArryay: [Data] = []
    var dataArray: [PostData] = []
    

    
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var densityField: UITextField!
    @IBOutlet weak var pouringVField: UITextField!
    @IBAction func beforeTimer(_ sender: Any) {
    }
    @IBAction func afterTimer(_ sender: Any) {
    }

    @IBAction func PStartTime(_ sender: Any) {
    }
    
    @IBAction func PStopTime(_ sender: Any) {
    }

    @IBAction func WStartTime(_ sender: Any) {
    }
    
    @IBAction func WStopTime(_ sender: Any) {
    }
    
    @IBOutlet weak var WVolume: UITextField!
    @IBOutlet weak var WCondition: UITextField!
    @IBOutlet weak var WeightField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var outletPicker: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    var pickerViewD: UIPickerView = UIPickerView()
    var pickerViewV: UIPickerView = UIPickerView()
    var pickerViewW: UIPickerView = UIPickerView()

    let outletList = ["", "正常", "赤み", "痛み", "はれ", "かさぶた"]
    let densityList = ["廃液", "1.5ダイアニール", "エクストラニール"]
    let volumeList = ["0", "1500"]
    let wasteList = ["", "正常", "フィブリン", "混濁", "その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // pickerViewを設定
        pickerView.dataSource = self
        pickerView.delegate = self
        outletPicker.inputView = pickerView
        pickerView.showsSelectionIndicator = true
        pickerView.tag = 0
        
        pickerViewD.dataSource = self
        pickerViewD.delegate = self
        densityField.inputView = pickerViewD
        pickerViewD.showsSelectionIndicator = true
        pickerViewD.tag = 1
        
        pickerViewV.dataSource = self
        pickerViewV.delegate = self
        pouringVField.inputView = pickerViewV
        pickerViewV.showsSelectionIndicator = true
        pickerViewV.tag = 2
        
        pickerViewW.dataSource = self
        pickerViewW.delegate = self
        WCondition.inputView = pickerViewW
        pickerViewW.showsSelectionIndicator = true
        pickerViewW.tag = 3
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return outletList[row]
        } else if pickerView.tag == 1 {
            return densityList[row]
        } else if pickerView.tag == 2 {
            return volumeList[row]
        } else {
            return wasteList[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return outletList.count
        } else if pickerView.tag == 1 {
            return densityList.count
        } else if pickerView.tag == 2 {
            return volumeList.count
        } else {
            return wasteList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.outletPicker.text = outletList[row]
            outletPicker.endEditing(true)
        } else if pickerView.tag == 1 {
            self.densityField.text = densityList[row]
            densityField.endEditing(true)
        } else if pickerView.tag == 2 {
            self.pouringVField.text = volumeList[row]
            pouringVField.endEditing(true)
        } else {
            self.WCondition.text = wasteList[row]
            WCondition.endEditing(true)
        }
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
