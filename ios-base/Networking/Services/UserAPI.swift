//
//  UserServiceManager.swift
//  ios-base
//
//  Created by Rootstrap on 16/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserAPI {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"

  class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    APIClient.sendPostRequest(url, params: parameters as [String : AnyObject]?, success: { response, headers in
      let json = JSON(response)
      UserDataManager.currentUser = User.parse(fromJSON: json)
      if let headers = headers as? [String: Any] {
        SessionManager.storeSessionObject(Session.parse(from: headers))
      }
      success()
    }, failure: { error in
      failure(error)
    })
  }

  //Example method that uploads an image using multipart-form.
  class func signup(_ email: String, password: String, avatar: UIImage, success: @escaping (_ responseObject: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password
      ]
    ]
    
    let picData = UIImageJPEGRepresentation(avatar, 0.75)!
    let image = MultipartMedia(key: "user[avatar]", data: picData)
    //Mixed base64 encoded and multipart images are supported in [MultipartMedia] param:
    //Example: let image2 = Base64Media(key: "user[image]", data: picData) Then: media [image, image2]
    APIClient.sendMultipartRequest(url: usersUrl, params: parameters, paramsRootKey: "", media: [image], success: { response, headers in
      let responseJson = JSON(response)
      UserDataManager.currentUser = User.parse(fromJSON: responseJson)
      if let headers = headers as? [String: Any] {
        SessionManager.storeSessionObject(Session.parse(from: headers))
      }
      success(response)
    }, failure: { (error) in
      failure(error)
    })
  }

  //Example method that uploads base64 encoded image.
  class func signup(_ email: String, password: String, avatar64: UIImage, success: @escaping (_ responseObject: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let picData = UIImageJPEGRepresentation(avatar64, 0.75)
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "image": picData!.asBase64Param()
      ]
    ]
    
    APIClient.sendPostRequest(usersUrl, params: parameters as [String : AnyObject]?, success: { response, headers in
      let responseJson = JSON(response)
      UserDataManager.currentUser = User.parse(fromJSON: responseJson)
      if let headers = headers as? [String: Any] {
        SessionManager.storeSessionObject(Session.parse(from: headers))
      }
      success(response)
    }, failure: { error in
      failure(error)
    })
  }

  class func getMyProfile(_ success: @escaping (_ json: JSON) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "profile"
    APIClient.sendGetRequest(url, success: { (responseObject) in
      let json = JSON(responseObject)
      success(json)
    }, failure: { error in
      failure(error)
    })
  }

  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = currentUserUrl + "facebook"
    let parameters = [
      "access_token": token
      ] as [String : Any]
    APIClient.sendPostRequest(url, params: parameters as [String : AnyObject]?, success: { responseObject, headers in
      let json = JSON(responseObject)
      UserDataManager.currentUser = User.parse(fromJSON: json)
      if let headers = headers as? [String: Any] {
        SessionManager.storeSessionObject(Session.parse(from: headers))
      }
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_out"
    APIClient.sendDeleteRequest(url, success: { _ in
      SessionManager.deleteSessionObject()
      success()
    }, failure: { error in
      failure(error)
    })
  }
}
