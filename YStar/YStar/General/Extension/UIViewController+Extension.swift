//
//  UIViewController+Extension.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
//import XCGLogger
import SVProgressHUD
import Qiniu
extension UIViewController {
    
//     func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        MobClick.beginLogPageView(NSStringFromClass(self.classForCoder))
//        
//    }
    
    
    
    static func storyboardViewController<T:UIViewController>(_ storyboard:UIStoryboard) ->T {
        return storyboard.instantiateViewController(withIdentifier: T.className()) as! T;
    }
    
    func storyboardViewController<T:UIViewController>() ->T {
        
        return storyboard!.instantiateViewController(withIdentifier: T.className()) as! T;
    }
    
    
    func errorBlockFunc()->ErrorBlock {
        return { [weak self] (error) in
//            XCGLogger.error("\(error) \(self)")
            self?.didRequestError(error)
        }
    }
    
    func didRequestError(_ error:NSError) {
        self.showErrorWithStatus(error.localizedDescription)
    }
   
    func showErrorWithStatus(_ status: String!) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    func showWithStatus(_ status: String!) {
        SVProgressHUD.show(withStatus: status)
    }
    
    func checkLogin(){
        if AppDataHelper.instance().checkLogin(){
            return
        }
        if let vc  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginNavigationController.className()) as? LoginNavigationController {
            vc.modalPresentationStyle = .custom
            present(vc, animated: true, completion: nil)
        }
    }
    
    func isLogin() -> Bool {
        
        if UserDefaults.standard.object(forKey: AppConst.UserDefaultKey.phone.rawValue) as? String == nil {
            let loginvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginNavigationController.className()) as? LoginNavigationController
            loginvc?.modalPresentationStyle = .custom
            present(loginvc!, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    func showUpdateInfo() {
        if AppDataHelper.instance().checkUpdate() {
            let homeStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = homeStoryboard.instantiateViewController(withIdentifier: UpdateVC.className()) as! UpdateVC
            controller.modalPresentationStyle = .custom
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion:nil)
        }
    }
    
    //退出登录
    func userLogout() {
        if let tabbar = UIApplication.shared.windows[0].rootViewController as? BaseTabbarViewController{
            //为了让退回跟视图
            if let nav : UINavigationController = tabbar.selectedViewController as? UINavigationController{
                if nav.viewControllers.count > 0{
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            }
            DispatchQueue.main.async {
                tabbar.selectedIndex = 0
            }
        }
        AppDataHelper.instance().clearUserInfo()
    }
    
    //检查text是否为空
    func checkTextFieldEmpty(_ array:[UITextField]) -> Bool {
        for  textField in array {
            if NSString.isEmpty(textField.text)  {
                showErrorWithStatus(textField.placeholder);
                return false
            }
        }
        return true
    }
    
    //关闭模态视图控制器
    func dismissController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    //打电话
    func didActionTel(_ telPhone:String) {
        let alert = UIAlertController.init(title: "呼叫", message: telPhone, preferredStyle: .alert)
        let ensure = UIAlertAction.init(title: "确定", style: .default, handler: { (action: UIAlertAction) in
            UIApplication.shared.openURL(URL(string: "tel://\(telPhone)")!)
        })
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action: UIAlertAction) in
            
        })
        alert.addAction(ensure)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}

