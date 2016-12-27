//
//  SessionDataManager.swift
//  swift-base
//
//  Created by Juan Pablo Mazza on 11/8/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit

class SessionDataManager: NSObject {

  class func storeSessionObject(session: Session) {
    let defaults = UserDefaults.standard
    defaults.set(NSKeyedArchiver.archivedData(withRootObject: session), forKey: "toptier-session")
    defaults.synchronize()
  }

  class func getSessionObject() -> Session? {
    let defaults = UserDefaults.standard

    if let data = defaults.object(forKey: "toptier-session") as? NSData {
      let unarc = NSKeyedUnarchiver(forReadingWith: data as Data)
      return unarc.decodeObject(forKey: "root") as? Session
    }

    return nil
  }
}
