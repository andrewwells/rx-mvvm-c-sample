//
//  SessionManager.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/24/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import Foundation

final class SessionManager {
    
    private init() {
        
        if let savedSesson = UserDefaults.standard.object(forKey: "current_session") as? Data {
            let decoder = JSONDecoder()
            if let session = try? decoder.decode(Session.self, from: savedSesson) {
                 self.currentSession = session
            }
        }
        
    }
    
    static let shared: SessionManager = {
       return SessionManager()
    }()
    
    var currentSession: Session? {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(currentSession) {
                UserDefaults.standard.set(data, forKey: "current_session")
            }
            else {
                UserDefaults.standard.set(nil, forKey: "current_session")
            }
        }
    }
    
    var isLoggedIn: Bool {
        return currentSession?.isValid ?? false
    }
}

struct Session: Codable {
    
    let id: String
    let token: String
    
    let name: String
    
    var isValid: Bool {
        return token.count > 0
    }
}

