//
//  MeasureViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift

class MeasureViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate {
    
/*    @IBOutlet weak var testConstraint: NSLayoutConstraint!        //1029
    var allY:CGFloat = 0.0         //1029
*/
//    @IBOutlet weak var WVolume: UITextField!
    // keyboard出現時スクロールするための設定↓
    @IBOutlet weak var WCondition: UITextField! {
        didSet {
            WCondition.delegate = self as? UITextFieldDelegate //デリゲートをset
        }
    }
    // keyboard出現時スクロールするための設定↑
    @IBOutlet weak var WeightField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var outletPicker: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var densityField: UITextField!
    @IBOutlet weak var pouringVField: UITextField!
    @IBOutlet weak var BTimer: UIButton!
    @IBOutlet weak var ATimer: UIButton!
    @IBOutlet weak var BfrTimer: UILabel!
    @IBOutlet weak var AftTimer: UILabel!
    @IBOutlet weak var PStart: UIButton!
    @IBOutlet weak var PStop: UIButton!
    @IBOutlet weak var WStart: UIButton!
    @IBOutlet weak var WStop: UIButton!
    
    let realm = try! Realm()
    var postdata: PostData!
    var data: Data!
    var rlmArray: [Data] = []
    var dataArray: [PostData] = []
    var PStartText = ""
    var PStopText = ""
    var WStartTex = ""
    var WStopText = ""
    
    var PStartT = Date()
    var PStopT = Date()
    var WStartT = Date()
    var WStopT = Date()
    var P1 = 0
    var P2 = 0
    var W1 = 0
    var W2 = 0
    
    var PTime = ""
    var WTime = ""
    
    var pickerView: UIPickerView = UIPickerView()
    var pickerViewD: UIPickerView = UIPickerView()
    var pickerViewV: UIPickerView = UIPickerView()
    var pickerViewW: UIPickerView = UIPickerView()
    
    let outletList = ["", "正常", "赤み", "痛み", "はれ", "かさぶた"]
    let densityList = ["廃液", "1.5ダイアニール", "エクストラニール"]
    let volumeList = ["0", "1500"]
    let wasteList = ["", "正常", "フィブリン", "混濁", "その他"]
    
    // 時間を図るためのタイマー
    var timer: Timer!
    var timer_sec: Int = 0
    
    // 注液時間の経過を表示
    @IBAction func beforeTimer(_ sender: Any) {
        passedTime()
    }

    // 廃液時間の経過を表示
    @IBAction func afterTimer(_ sender: Any) {
        self.timer.invalidate()  // タイマーstop
        self.timer = nil
    }
    
    // 注液開始時間をタップで時間表示させる　入力済＞P1=1
    @IBAction func PStartTime(_ sender: Any) {
        PStart.setTitle(setTime(), for: UIControlState.normal)
        PStartText = setTime()
        PStartT = Date()
        P1 = 1
        
        // 経過時間を表示
        passedTime()
        print("PStartTime = \(PStartText)  setTime = \(setTime())")
        
        // 経過時間用のボタンを使用可能にする
        BTimer.isEnabled = true
        ATimer.isEnabled = true
    }
    
    // 注液終了時間をタップで時間表示させる　入力済＞P2=1
    @IBAction func PStopTime(_ sender: Any) {
        PStop.setTitle(setTime(), for: UIControlState.normal)
        PStopText = setTime()
        PStopT = Date()
        P2 = 1
        
        // タイマーstop
        self.timer.invalidate()
        self.timer = nil
        print("PStopTime = \(PStopText)")
        
        // 経過時間用のボタンを使用不可にする
        BTimer.isEnabled = false
        ATimer.isEnabled = false
    }

    @IBAction func WStartTime(_ sender: Any) {
        WStart.setTitle(setTime(), for: UIControlState.normal)
        WStartTex = setTime()
        WStartT = Date()
        W1 = 1
        passedTime()    // 経過時間表示
        print("WStartTime = \(WStartTex)")
        BTimer.isEnabled = true   // 経過用ボタン使用可
        ATimer.isEnabled = true
    }
    
    @IBAction func WStopTime(_ sender: Any) {
        WStop.setTitle(setTime(), for: UIControlState.normal)
        WStopText = setTime()
        WStopT = Date()
        W2 = 1
        self.timer.invalidate()  // タイマーstop
        self.timer = nil
        print("WStopTime = \(WStopText)")
        BTimer.isEnabled = false   // 経過用ボタン使用不可
        ATimer.isEnabled = false
    }
    
    // 注液開始時間を削除
    @IBAction func D1(_ sender: Any) {
        PStart.setTitle("注液開始", for: UIControlState.normal)
        PStartText = "注液開始"
        PStartT = Date()
        P1 = 0
    }


    @IBAction func D2(_ sender: Any) {
        PStop.setTitle("注液終了", for: UIControlState.normal)
        PStopText = "注液終了"
        PStopT = Date()
        P2 = 0
    }
    
    @IBAction func D3(_ sender: Any) {
        WStart.setTitle("廃液開始", for: UIControlState.normal)
        WStartTex = "廃液開始"
        WStartT = Date()
        W1 = 0
    }
    
    @IBAction func D4(_ sender: Any) {
        WStop.setTitle("廃液終了", for: UIControlState.normal)
        WStopText = "廃液終了"
        WStopT = Date()
        W2 = 0
    }

    
    
    // 現在の時間をStringにする
    func setTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    var uInfo = Date()
    
    // 時間経過を1秒ごとにupdateTimeを動作させる
    func passedTime() {
        print("DEBUG: passedTime")
        
        // 計測開始を設定
        if W1 == 0 && P1 != 0 { // PStartあり WStartなし
                uInfo = PStartT
        } else {               // WStartあり
            uInfo = WStartT
        }
        print("uInfo = \(uInfo)")

        if self .timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } else {
            self.timer.invalidate()  // タイマーstop
            self.timer = nil
        }
    }
/*
 var PStartT = Date()!     var PStopT = Date()!
 var WStartT = Date()!      var WStopT = Date()!
 var PTime = Date()       var WTime = Date()
 */
    // 1秒毎に経過時間を表示させる
    func updateTime(timer: Timer) {
        // 現在日時
        let nowDate = Date()
        let interval = Int(nowDate.timeIntervalSince(uInfo))
                
        let min = interval / 60
        let sec = interval % 60
        let timeString = String(format: "%02d:%02d", min, sec)
        
        print("timeString = \(timeString)")
        if W1 == 0 {
            BfrTimer.text = timeString
        } else {
            AftTimer.text = timeString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
/*        //Viewを作成   1029↓
        let  testView = UIView()
        testView.frame.size.height = 60
        testView.backgroundColor = UIColor.blue
        
        // 閉じるボタンを作成
        let  closeButton = UIButton()
        closeButton.setTitle("閉じる", for:UIControlState.normal)
        closeButton.backgroundColor = UIColor.red
        closeButton.addTarget(self, action: Selector(("onClickCloseButton:")), for: .touchUpInside)
        
        //　Viewに閉じるボタンを追加
        testView.addSubview(closeButton)
        
        // Autoresizingの変換をオフにする
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // ボタンの幅の制約を追加
        testView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.0, constant: 70))
        
        // ボタンの高さの制約を追加
        testView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 50))
        // ボタンの右端とViewの右端を揃える制約を追加する
        testView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: testView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0))
        
        // ボタンの上端とViewの上端を揃える制約を追加
        testView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: testView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0))
        
        // キーボードにViewを追加
        WCondition.inputAccessoryView = testView
        
        // テキストビューのデリゲート先にこのインスタンスを設定
        WCondition.delegate = self as? UITextFieldDelegate
        
        // キーボードが現れる時に通知するメソッドを登録
        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillBeShown")), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // 1029↑
*/
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
        
        // datePickerViewを設定
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: #selector(changedDateEvent(sender: )), for: .valueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.date
        dateText.inputView = myDatePicker
        
        // Do any additional setup after loading the view.
    }
    
/*    // 1029↓
    // 閉じるボタンで呼び出されるメソッド
    func onClickCloseButton(sender: UIButton) {
        WCondition.resignFirstResponder()
        
        // テキストビューの位置を元に戻す
        if (allY > 0) {
            testConstraint.constant -= allY
            UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded()})
        }
        allY = 0.0
    }
    
    // キーボードが開くときの呼び出しメソッド
    func keyboardWillBeShown(notification: NSNotification) {
        
        // キーボードのフレームを取得
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            // テキストビューの最大Y座標と、キーボードの最小Y座標の差を計算する
            let zureY = WCondition.frame.maxY - keyboardFrame.minY
            
            if (zureY > 0) {
                // テキストビューの垂直方向の位置の制約に差分をプラス
                testConstraint.constant += zureY
                allY += zureY
                
                // アニメーションさせる
                UIView.animate(withDuration: 0.5, animations:{ self.view.layoutIfNeeded()})
            }
        }
    }
*/
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    func changedDateEvent(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectDate: String = dateFormatter.string(from: sender.date)
        print("DEBUG: dateText = \(selectDate)")
        dateText.text = selectDate as String
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
    
    // keyboard出現時スクロールするための設定↓
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()  // Notificationを画面が消える時に削除
    }
    
    // Notificationを設定
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす
    func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let tranform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = tranform
        })
    }
    
    // キーボードが消えた時に、画面を戻す
    func  keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Returnキーを押した時にキーボードを下げる
        return true
    }
    // keyboard出現時スクロールするための設定↑

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
