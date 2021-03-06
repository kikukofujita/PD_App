//
//  SettingViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/17.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    
    var listD = ListD()
    var listV = ListV()

    // Tableで使用する配列を定義
 //   let densityList: Array = ["0", "廃液", "1.5ダイアニール", "エクストラニール"]
 //   let volumeList: Array = ["0", "1500"]
    var volArray = try! Realm().objects(ListV.self).sorted(byKeyPath: "listVolume", ascending: true)
    var denArray = try! Realm().objects(ListD.self).sorted(byKeyPath: "id", ascending: true)
    
    
    // Sectionで使用する配列を定義
    let sectionList: Array = ["濃度", "容量"]
    
    
    // リスト入力画面から戻る
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        
    }
    
    
    // ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        print("DEBUG: ログアウトボタンをタップ")
        // ログアウトする
        try! Auth.auth().signOut()
        print("DEBUG: ログアウトしました。")
        
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきたときのためにホーム画面（index= 0)を選択している状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Cell名の登録
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibD = UINib(nibName: "densityTableViewCell", bundle: nil)
        tableView.register(nibD, forCellReuseIdentifier: "CellD")
        let nibV = UINib(nibName: "volumeTableViewCell", bundle: nil)
        tableView.register(nibV, forCellReuseIdentifier: "CellV")
        
        tableView.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sectionの数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionList.count
    }
    
    // Sectionのタイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionList[section]
    }
    
    // Cellが選択された際に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
        //    let cell = tableView.dequeueReusableCell(withIdentifier: "CellD", for: indexPath as IndexPath) as! densityTableViewCell
         //   print("Value: \(cell.densityLabel))")
        } else if indexPath.section == 1 {
        //    let cell = tableView.dequeueReusableCell(withIdentifier: "CellV", for: indexPath as IndexPath) as! volumeTableViewCell
        //        print("Value: \(cell.volumeLabel)")
        }
    }
    
    // テーブルに表示する配列の総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // density
        if section == 0 {
            return denArray.count
        }
        // volume
        else {
            return volArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    // Cellに値を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // density
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellD", for: indexPath as IndexPath) as! densityTableViewCell
            let listD = denArray[indexPath.row]
            
            cell.densityLabel.text = listD.listDensity
            return cell
        }
        // volumeList 
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellV", for: indexPath as IndexPath) as! volumeTableViewCell
            let listV = volArray[indexPath.row]
            if listV.listVolume == listV.listVolume {
                cell.volumeLabel.text = String(listV.listVolume)
            }
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   print("denArray: \(denArray)")
     //   print("volArray: \(volArray)")
        tableView.reloadData()
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
