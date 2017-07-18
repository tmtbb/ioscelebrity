//
//  APITestCase.swift
//  YStar
//
//  Created by mu on 2017/7/10.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import XCTest
@testable import YStar

class APITestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func ytimeTest(_ funName:String, handle: CompleteBlock) {
        let startTime = Date.nowTimestemp()
        handle(nil)
        let endTime = Date.nowTimestemp()
        let marginTime = endTime - startTime
        if let path = Bundle.main.path(forResource: "ytest", ofType: "plist"){
            if let dic = NSMutableDictionary.init(contentsOfFile: path){
                dic.setValue(marginTime, forKey: funName)
                dic.write(toFile: path, atomically: true)
            }
        }
        
    }
    
    // 登录功能
    func testLogin() {
        ytimeTest("testLogin", handle: {_ in 
            let expectOption = expectation(description: "登录测试")
            let param = LoginRequestModel()
            param.phone = "18657195470"
            param.pwd = "123456".md5()
            var idExcept = false
            var phoneExcept = false
            var tokenExcept = false
            AppAPIHelper.commen().login(model: param, complete: { (result) -> ()? in
                
                if let object = result as? StarUserModel{
                    if (object.userinfo?.id) != nil{
                        idExcept = true
                    }
                    if (object.userinfo?.phone) != nil{
                        phoneExcept = true
                    }
                    tokenExcept = object.token.length() > 0
                    expectOption.fulfill()
                }
                return nil
            }, error: nil)
            waitForExpectations(timeout: 15, handler: nil)
            
            XCTAssertTrue(idExcept, "用户id不存在")
            XCTAssertTrue(phoneExcept, "用户手机号不存在")
            XCTAssertTrue(tokenExcept, "token不存在")
            return nil
        })
        
    }
    
    //发送朋友圈
    func testSendCircle(){
        let exceptOption = expectation(description: "发布朋友圈测试")
        let param = SendCircleRequestModel()
        AppAPIHelper.commen().sendCircle(requestModel: param, complete: { (result)in
            if let resultModle = result as? SendCircleResultModel{
                if resultModle.circle_id > 0{
                   exceptOption.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    //获取朋友圈列表
    func testCircleList(){
        let exceptOption = expectation(description: "朋友圈测试")
        let model = CircleListRequestModel()
        model.pos = 0
        model.count = 10
        AppAPIHelper.commen().requestCircleList(requestModel: model, complete: { (result) in
            if let circlelist = result as? [CircleListModel]{
                if circlelist.count > 0{
                    exceptOption.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    //评论朋友圈
    func testCommentCircle()  {
        let exception = expectation(description: "评论朋友圈")
        let param = CommentCircleModel()
        AppAPIHelper.commen().commentCircle(requestModel: param, complete: { (result) in
            if let model = result as? ResultModel{
                if model.result == 1{
                   exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    //明星回复朋友圈
    func testStarReply() {
        let exception = expectation(description: "测试明星回复")
        let param = CommentCircleModel()
        AppAPIHelper.commen().starCommentCircle(requestModel: param, complete: { (result) in
            if let model = result as? ResultModel{
                if model.result == 1{
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    //点赞朋友圈
    func testApproveCircle() {
        let exception = expectation(description: "测试点赞朋友圈")
        let param  = ApproveCircleModel()
        AppAPIHelper.commen().approveCircle(requestModel: param, complete: { (result) in
            if let model = result as? ResultModel{
                if model.result == 1{
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - 首页收益列表
    func testRequestEarningInfo() {
        let exception = expectation(description: "测试首页收益列表")
        let param = EarningRequestModel()
        param.stardate = 20170601
        param.enddate = 20170630
        AppAPIHelper.commen().requestEarningInfo(model: param, complete: { (result) -> ()? in
            if let model = result as? [EarningInfoModel] {
                if model.count > 0 {
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - 今开昨收
    func testrequestYesterdayAndTodayPrice() {
        let exception = expectation(description: "测试今开昨收")
        let parma = YesterdayAndTodayPriceRequestModel()
        parma.orderdate = 20170627
        AppAPIHelper.commen().requestYesterdayAndTodayPrice(model: parma, complete: { (result) -> ()? in
            if let model = result as? YesterdayAndTodayPriceModel {
                if model.max_price > 0 {
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - 设置交易密码
    func testResetPayPwd() {
        let exception = expectation(description: "测试设置交易密码")
        let parma = ResetPayPwdRequestModel()
        parma.phone = "15557198601"
        parma.pwd = "123456".md5()
        parma.timestamp = 1
        parma.type = 0
        AppAPIHelper.commen().ResetPayPwd(requestModel: parma, complete: { (result) -> ()? in
            if let model = result as? ResultModel {
                if model.result == 0 {
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
    }
    
    // MARK: - 校验交易密码
    func testCheckPayPwd() {
        let exception = expectation(description: "测试校验密码")
        let param = CheckPayPwdModel()
//        param.uid = 185
        param.uid = UserDefaults.standard.value(forKey: AppConst.UserDefaultKey.uid.rawValue) as! Int64
        param.paypwd = "123456".md5()
    
        AppAPIHelper.commen().CheckPayPwd(requestModel: param, complete: { (result) -> ()? in
            if let model = result as? ResultModel {
                if model.result == 1 {
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    // MARK: - 提现
    func testWithdrawal() {
        let exception = expectation(description: "测试提现")
        
        let param = WithdrawalRequestModel()
        param.price = 12.22
        AppAPIHelper.commen().Withdrawal(requestModel: param, complete: { (result) -> ()? in
            if let model = result as? ResultModel {
                if model.result == 1 {
                    exception.fulfill()
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
    }
    
    // MARK: - 提现列表
    func testWithdrawalList() {
        let exception = expectation(description: "测试提现列表")
        let param = WithdrawalListRequetModel()
        // param.id = 185
        // param.token = "4245e53e85840084c7f34b1e301f553a"
        param.status = 0
        param.startPos = 100
        AppAPIHelper.commen().withDrawList(requestModel: param, complete: { (result) -> ()? in
            if let model = result as? WithdrawListModel {
                if model.withdrawList != nil {
                    if model.withdrawList.count > 0 {
                        exception.fulfill()
                    }
                }
            }
            return nil
        }, error: nil)
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    //性能测试：测试登录功能和Add方法性能表现
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
        }
    }
    
    
    
}
