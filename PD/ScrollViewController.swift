//
//  ScrollViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/30.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import AudioToolbox

class ScrollViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate {

    @IBOutlet weak var WVolume: UITextField!   //廃液量
    @IBOutlet weak var WCondition: UITextField! //廃液性状
    @IBOutlet weak var WeightField: UITextField! //体重
    @IBOutlet weak var commentField: UITextView! //血圧：
    @IBOutlet weak var outletPicker: UITextField! //出口部状態
    @IBOutlet weak var dateText: UITextField! //日付
    @IBOutlet weak var densityField: UITextField! //濃度
    @IBOutlet weak var pouringVField: UITextField! //注液量
    @IBOutlet weak var BTimer: UIButton!  //注液timerButton
    @IBOutlet weak var ATimer: UIButton!  //排液timerButton
    @IBOutlet weak var BfrTimer: UILabel! //注液timer00:00
    @IBOutlet weak var AftTimer: UILabel! //排液timer00:00
    @IBOutlet weak var PStart: UIButton!  //注液開始
    @IBOutlet weak var PStop: UIButton!   //注液終了
    @IBOutlet weak var WStart: UIButton!  //排液開始
    @IBOutlet weak var WStop: UIButton!   //排液終了
    @IBOutlet weak var BfrWV: UITextField!
    @IBOutlet weak var idText: UILabel!
    @IBOutlet weak var stockText: UILabel!
    @IBAction func selectStock(_ sender: UISegmentedControl) {
        // セグメント番号でストック場所を表示
        switch sender.selectedSegmentIndex {
        case 0:
            stockText.text = "Home"
        case 1:
            stockText.text = "Other"
        default:
            stockText.text = "Home"
        }
    }

    
    let realm = try! Realm()
    var postdata: PostData!
    var data = Data()        //←これでdataが使用可能に
//    var rlmArray: [Data] = []
    var dataArray: [PostData] = []
    var PStartText = ""      //表示用
    var PStopText = ""
    var WStartTex = ""
    var WStopText = ""
    
    var PStartT = Date()     //realm用
    var PStopT = Date()
    var WStartT = Date()
    var WStopT = Date()
    var p1Text = ""           //Firebase用
    var p2Text = ""
    var w1Text = ""
    var w2Text = ""
    
    var P1 = 0               //データ入力判定用
    var P2 = 0
    var W1 = 0
    var W2 = 0
    
    var PTime = ""           //タイマー表示用
    var WTime = ""
    
    var uInfo = Date()       //タイマーの開始時間を設定するため
    var x:String = ""
    
    func DatetoString(_ date: Date) -> String {
        let dateFormatterT: DateFormatter = DateFormatter()
        dateFormatterT.dateFormat = "HH:mm:ss"
        return dateFormatterT.string(from: date)
    }
    
    
    let myDatePicker: UIDatePicker = UIDatePicker()
    var pickerView: UIPickerView = UIPickerView()
    var pickerViewD: UIPickerView = UIPickerView()
    var pickerViewV: UIPickerView = UIPickerView()
    var pickerViewW: UIPickerView = UIPickerView()
    
    let outletList = ["", "正常", "赤み", "痛み", "はれ", "かさぶた"]
    let densityList = ["", "廃液", "1.5ダイアニール", "エクストラニール"]
    let volumeList = ["0", "1500"]
    let wasteList = ["", "正常", "フィブリン", "混濁", "その他"]
    
    // 時間を図るためのタイマー
    var timer: Timer!
    var timer_sec: Int = 0
    
    var rlmArray = try! Realm().objects(Data.self).sorted(byKeyPath: "date", ascending: false)
    
    var wv = 0
    var bwv = 0
    
    // ******************************************
    @IBAction func calcButton(_ sender: Any) {
        if Int(WVolume.text!) != nil {
             wv = Int(WVolume.text!)!
       //     print("wv = \(wv)")
        }            // 廃液量
        if Int(BfrWV.text!) != nil {
            bwv = Int(BfrWV.text!)!
        //    print("BfrWV = \(BfrWV)")
        //    print("bwv = \(bwv)")
        }
        let rslt = wv - bwv
        self.WVolume.text = rslt.description
        
    }
    // 注液時間の経過を表示
    @IBAction func beforeTimer(_ sender: Any) {
        passedTime()
    }
    
    // 廃液時間の経過を表示
    @IBAction func afterTimer(_ sender: Any) {
        self.timer.invalidate()  // タイマーstop
        self.timer = nil
    }
    // ******************************************
    // 注液開始時間をタップで時間表示させる　入力済＞P1=1
    @IBAction func PStartTime(_ sender: Any) {
        PStart.setTitle(setTime(), for: UIControlState.normal)
        PStartText = self.PStart.currentTitle!
        PStartT = Date()
        P1 = 1
        PStart.isEnabled = false
        PStart.setTitleColor(UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1), for: .normal)
        
        //print("PStart = \(PStartText)")
        //print("PStatT = \(PStartT)")
        AudioServicesPlayAlertSound(1000)
        
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
        PStopText = self.PStop.currentTitle!
//        p2Text = setTime()
        PStopT = Date()
        P2 = 1
        PStop.isEnabled = false
        PStop.setTitleColor(UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1), for: .normal)
        // タイマーstop
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
          //  print("PStopTime = \(PStopText)")
        }
        
        // 経過時間用のボタンを使用不可にする
        BTimer.isEnabled = false
        ATimer.isEnabled = false
    }
    
    @IBAction func WStartTime(_ sender: Any) {
        WStart.setTitle(setTime(), for: UIControlState.normal)
        WStartTex = setTime()
        WStartT = Date()
//        w1Text = setTime()
        W1 = 1
        passedTime()    // 経過時間表示
        WStart.isEnabled = false
        WStart.setTitleColor(UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1), for: .normal)
       // print("WStartTime = \(WStartTex)")
        BTimer.isEnabled = true   // 経過用ボタン使用可
        ATimer.isEnabled = true
    }
    
    @IBAction func WStopTime(_ sender: Any) {
        WStop.setTitle(setTime(), for: UIControlState.normal)
        WStopText = setTime()
//        w2Text = setTime()
        WStopT = Date()
        W2 = 1
        if self.timer != nil {
            self.timer.invalidate()  // タイマーstop
            self.timer = nil
        //    print("WStopTime = \(WStopText)")
            WStop.isEnabled = false
            WStop.setTitleColor(UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1), for: .normal)
        }
        
        BTimer.isEnabled = false   // 経過用ボタン使用不可
        ATimer.isEnabled = false
    }
    // ******************************************
    // 注液開始時間を削除
    @IBAction func D1(_ sender: Any) {
        PStart.setTitle("注液開始", for: UIControlState.normal)
        PStartText = "注液開始"
//        p1Text = ""
        PStartT = Date()
        P1 = 0
        passedTime()
        PStart.isEnabled = true
    }
    
    // 注液終了時間を削除
    @IBAction func D2(_ sender: Any) {
        PStop.setTitle("注液終了", for: UIControlState.normal)
        PStopText = "注液終了"
//        p2Text = ""
        PStopT = Date()
        P2 = 0
        passedTime()
        PStop.isEnabled = true
    }
    
    // 排液開始時間を削除
    @IBAction func D3(_ sender: Any) {
        WStart.setTitle("廃液開始", for: UIControlState.normal)
        WStartTex = "廃液開始"
//        w1Text = ""
        WStartT = Date()
        W1 = 0
        passedTime()
        WStart.isEnabled = true
    }
    
    // 排液終了時間を削除
    @IBAction func D4(_ sender: Any) {
        WStop.setTitle("廃液終了", for: UIControlState.normal)
        WStopText = "廃液終了"
 //       w2Text = ""
        WStopT = Date()
        W2 = 0
        passedTime()
        WStop.isEnabled = true
    }
    // ******************************************
    // 現在の時間をStringにする
    func setTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    // ******************************************
    // 時間経過を1秒ごとにupdateTimeを動作させる
    func passedTime() {
     //   print("DEBUG: passedTime")
        
        // 計測開始を設定
        if W1 == 0 && P1 != 0 { // PStartあり WStartなし
            uInfo = PStartT
        } else {               // WStartあり
            uInfo = WStartT
        }
       // print("uInfo = \(uInfo)")
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        } else {
            self.timer.invalidate()  // タイマーstop
            self.timer = nil
        }
    }

    // ******************************************
    // 1秒毎に経過時間を表示させる
    func updateTime(timer: Timer) {
        // 現在日時
        let nowDate = Date()
        let interval = Int(nowDate.timeIntervalSince(uInfo))
        
        let min = interval / 60
        let sec = interval % 60
        let timeString = String(format: "%02d:%02d", min, sec)
        
        if W1 == 0 {
            BfrTimer.text = timeString
        } else {
            AftTimer.text = timeString
        }
        if interval % 300 == 60 {
            AudioServicesPlayAlertSound(1008)
        }
    }
    
    // ******************************************
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Scroll viewDidLoad data = \(data)")

        //dateText: UITextField! //日付
        //densityField: UITextField! //濃度
        //pouringVField: UITextField! //注液量
        //PStart: UIButton!  //注液開始
        //PStop: UIButton!   //注液終了
        //WStart: UIButton!  //排液開始
        //WStop: UIButton!   //排液終了
        //WVolume: UITextField!   //廃液量
        //WCondition: UITextField! //廃液性状
        //WeightField: UITextField! //体重
        //commentField: UITextView! //血圧：
        //BfrTimer: UILabel! //注液timer00:00
        //AftTimer: UILabel! //排液timer00:00
        
        PStartT = data.startPouring
        PStopT = data.stopPouring
        WStartT = data.startWaste
        WStopT = data.stopWaste

        if navigationController != nil {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
            navigationItem.rightBarButtonItem = doneButton
        }
        
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
//  let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: #selector(changedDateEvent(sender: )), for: .valueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.date
        dateText.inputView = myDatePicker
        
        // ナビゲータで遷移した場合
        if navigationController != nil {
            
            print("nav で遷移")
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let y: String = dateFormatter.string(from: data.date)
            
            print("dataText_y = \(y)")
            dateText.text = y as String

            densityField.text = data.density
            pouringVField.text = String(data.pouringVolume)
            idText.text = String(data.id)
            
            let dateFormatter2: DateFormatter = DateFormatter()
            dateFormatter2.dateFormat = "HH:mm:ss"
        
            let startPS: String = dateFormatter2.string(from: data.startPouring)
            PStart.setTitle(startPS, for: .normal)
        
            let stopPS: String = dateFormatter2.string(from: data.stopPouring)
            PStop.setTitle(stopPS, for: .normal)
            
            let startWS: String = dateFormatter2.string(from: data.startWaste)
            WStart.setTitle(startWS, for: .normal)
            
            let stopWS: String = dateFormatter2.string(from: data.stopWaste)
            WStop.setTitle(stopWS, for: .normal)
        
            WVolume.text = String(data.wasteVolume)
            WCondition.text = data.liquidWaste
            WeightField.text = String(data.weight)
            commentField.text = data.bloodPressure
        
            let interval1 = Int(data.stopPouring.timeIntervalSince(data.startPouring))
        
            let min1 = interval1 / 60
            let sec1 = interval1 % 60
            let timeString1 = String(format: "%02d:%02d", min1, sec1)
            BfrTimer.text = timeString1
            
            print("BfrTimer = \(timeString1)")
        
            let interval2 = Int(data.stopWaste.timeIntervalSince(data.startWaste))
        
            let min2 = interval2 / 60
            let sec2 = interval2 % 60
            let timeString2 = String(format: "%02d:%02d", min2, sec2)
            AftTimer.text = timeString2
            print("AftTimer = \(timeString2)")
        
        } else {
            dateText.text = data.findDate
            idText.text = String(data.id)
            print("nav 以外で遷移　scrollVC_dataText_x = \(x)")
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    // ******************************************
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // ******************************************
    // Doneボタンが押されたら呼ばれるメソッド
    func doneTapped(_ sender: UINavigationController) {
        // ToDo: 閉じる前に必要な処理があればここに記載
        //if P2 == 1 || W2 == 1 {
            print("realm add doneTapped")
            try! realm.write {
                _ = Data()
                /*if rlmArray.count != 0 {
                 self.data.id = rlmArray.max(ofProperty: "id")! + 1
                 } */
        //        print("data.id = \(self.data.id)")
       //         self.data.date = Date()
                self.data.findDate = dateText.text!  //日付
                if let pVol = Int(pouringVField.text!) {
                    self.data.pouringVolume = pVol
                } else {
                    self.data.pouringVolume = 0         //注液量
                }
                self.data.density = self.densityField.text!  // 透析液濃度
                self.data.liquidWaste = self.WCondition.text! // 廃液の状態
                self.data.bloodPressure = self.commentField.text // 血圧
                if let wt = Double(WeightField.text!) {
                    self.data.weight = wt                  // 体重
                }
                if let wVol = Int(WVolume.text!) {
                    self.data.wasteVolume = wVol          // 廃液量
                }

                self.data.startPouring = PStartT as Date
                self.data.stopPouring = PStopT as Date
                self.data.startWaste = WStartT as Date
                self.data.stopWaste = WStopT as Date
                self.data.outletCondition = self.outletPicker.text!
                self.data.difference = self.data.wasteVolume - self.data.pouringVolume
                self.data.pouringTime = self.BfrTimer.text!
                self.data.wasteTime = self.AftTimer.text!
                self.data.pouringTime = self.BfrTimer.text!
                self.data.wasteTime = self.AftTimer.text!
                self.data.startPText = PStartText
                self.data.stopPText = PStopText
                self.data.startWText = w1Text
                self.data.stopWText = w2Text
 
                self.realm.add(self.data, update: true)
                
                //print(rlmArray)
            //}
        }
        
        
        // 閉じる
        dismiss(animated: true, completion: nil)
    }
    
    // ******************************************
    func changedDateEvent(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let selectDate: String = dateFormatter.string(from: sender.date)
        //print("DEBUG: dateText = \(selectDate)")
        dateText.text = selectDate as String
    }
    
    // ******************************************
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
    
    // ******************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*    // keyboard出現時スクロールするための設定↓
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureObserver()
    }
*/
// var data: Data!
// var rlmArray: [Data] = []
/*   dateText: UITextField! //日付
     WVolume: UITextField!   //廃液量
     WCondition: UITextField! //廃液性状
     WeightField: UITextField! //体重
     commentField: UITextView! //血圧：
     outletPicker: UITextField! //出口部状態
     densityField: UITextField! //濃度
     pouringVField: UITextField! //注液量
     var PStartT = Date()     //realm用
     var PStopT = Date()
     var WStartT = Date()
     var WStopT = Date()
*/
    // ******************************************    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        idText.text = String(data.id)
        
    }
    
    
    // ******************************************
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // print("Scroll viewDidAppear x: \(x)")
       // print("scrollVC_data.id = \(data.id)")
       // print("scrollVC_count = \(rlmArray.count)")
        if navigationController == nil {
            self.dateText.text = x
        }
    
    }
    
    // ******************************************
    override func viewDidDisappear(_ animated: Bool) {
        //print("scroll_viewDidDisapper")
        //print("PStart = \(String(describing: PStart.titleLabel))")
        if P2 == 1 || W2 == 1 {
          //  print("realm add")
        try! realm.write {
            _ = Data()
            /*if rlmArray.count != 0 {
                self.data.id = rlmArray.max(ofProperty: "id")! + 1
            } */
            //print("data.id = \(self.data.id)")
//            self.data.date = Date()
            self.data.findDate = dateText.text!  //日付
            if let pVol = Int(pouringVField.text!) {
                self.data.pouringVolume = pVol
            } else {
            self.data.pouringVolume = 0         //注液量
            }
            self.data.density = self.densityField.text!  // 透析液濃度
            self.data.liquidWaste = self.WCondition.text! // 廃液の状態
            self.data.bloodPressure = self.commentField.text // 血圧
            if let wt = Double(WeightField.text!) {
                self.data.weight = wt                  // 体重
            } 
            if let wVol = Int(WVolume.text!) {
                self.data.wasteVolume = wVol          // 廃液量
            }
            self.data.startPouring = PStartT as Date
            
            self.data.stopPouring = PStopT as Date
            
            self.data.startWaste = WStartT as Date
            
            self.data.stopWaste = WStopT as Date
            
            self.data.outletCondition = self.outletPicker.text!
            self.data.difference = self.data.wasteVolume - self.data.pouringVolume
            self.data.pouringTime = self.BfrTimer.text!
            self.data.wasteTime = self.AftTimer.text!
            self.data.startPText = PStartText
            self.data.stopPText = PStopText
            self.data.startWText = w1Text
            self.data.stopWText = w2Text

            self.realm.add(self.data, update: true)
            
            //print(rlmArray)
            }

        super.viewWillDisappear(animated)            
    }
//        self.removeObserver()  // Notificationを画面が消える時に削除
    }
    
/*    // Notificationを設定
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
    // keyboard出現時スクロールするための設定↑ */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

