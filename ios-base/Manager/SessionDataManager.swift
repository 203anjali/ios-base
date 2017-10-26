//
//  SessionDataManager.swift
//  ios-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class SessionDataManager: NSObject {

  class func storeSessionObject(_ session: Session) {
    let defaults = UserDefaults.standard
    defaults.set(NSKeyedArchiver.archivedData(withRootObject: session), forKey: "ios-base-session")
  }

  class func getSessionObject() -> Session? {
    let defaults = UserDefaults.standard
    if let data = defaults.object(forKey: "ios-base-session") as? Data {
      let unarc = NSKeyedUnarchiver(forReadingWith: data)
      return unarc.decodeObject(forKey: "root") as? Session
    }

    return nil
  }
  
  class func deleteSessionObject() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "ios-base-session")
  }
  
  class func checkSession() -> Bool {
    return self.getSessionObject() != nil
  }
}
