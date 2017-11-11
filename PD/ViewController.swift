//
//  ViewController.swift
//  PD
//
//  Created by 藤田貴久子 on 2017/10/16.
//  Copyright © 2017年 kiki.fuji. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseAuth
import ESTabBarController

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var rlmArray = try! Realm().objects(Data.self).sorted(byKeyPath: "date", ascending: false)
    var data = Data()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DBUG: viewDidLoad")
        setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

/*   ログイン画面を表示しない　ー＞　realmで作成するため
        // currentUserがnilならログインしてない
        if Auth.auth().currentUser == nil {
            // ログインしてない時の処理
            // viewDidAppear内でpresent()を呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(loginViewController!, animated: true, completion: nil)
            }
        }*/
    }
    
    func setupTab() {
        
        print("DBUG: setupTab")
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "measure", "stock", "setting", "measure"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 1.0, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // 作成したESTabBarControllerを親のViewController(=self)に追加する
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMove(toParentViewController: self)
        
        // タブをタップしたときに表示するViewControllerを設定する
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        let measureViewController = storyboard?.instantiateViewController(withIdentifier: "Measure")
        let stockViewController = storyboard?.instantiateViewController(withIdentifier: "Stock")
        let scrollViewController = storyboard?.instantiateViewController(withIdentifier: "Scroll")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(measureViewController, at: 1)
        tabBarController.setView(settingViewController, at: 3)
        tabBarController.setView(stockViewController, at: 2)
        tabBarController.setView(scrollViewController, at: 4)
        
       // ハイライトタブ
        tabBarController.highlightButton(at: 1)
         // ボタン設定の場合
        tabBarController.setAction({
            print("tab 4 tapped")
            guard let homeVC = homeViewController as? HomeViewController,
                let scrollVC = scrollViewController as? ScrollViewController else {
            return
            }   // 上記はそれぞれ変数を代入し、nilでないことを確認している
                // もしnilなら、returnで処理を強制的に終了してエラーを防止
            
            let data = Data()
            data.findDate = homeVC.textField.text!
            scrollVC.x = homeVC.textField.text ?? ""
            
            print("ViewC_tab4tapped x = \(scrollVC.x)")
            print("ViewC_tab4tapped count = \(self.rlmArray.count)")
            scrollVC.data = self.data
            if self.rlmArray.count != 0 {
                self.data.id = self.rlmArray.max(ofProperty: "id")! + 1
            }
            scrollVC.idText.text = String(scrollVC.data.id)
            print("ViewC_tab4tapped id = \(self.data.id)")
        }, at: 4)
    }
    
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scrollViewController: ScrollViewController = segue.destination as! ScrollViewController
    } */
    
/* code       let measureViewController = self.storyboard?.instantiateViewController(withIdentifier: "Measure")
        self.present(measureViewController!, animated: true, completion:  nil)
        }
 */
        

    }
/*let task = Task()
task.date = NSDate()

if taskArray.count != 0 {
    task.id = taskArray.max(ofProperty: "id")! + 1
}

inputViewController.task = task
*/

    // StopWaste StartWaste StopPouring StartPouring
    // concentration ml



