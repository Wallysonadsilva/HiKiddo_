//
//  Environment.swift
//  HiKiddo
//
//  Created by W on 08/01/2025.
//

import Foundation

struct Environment {
    static var supabaseKey: String {
        guard let key = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String else {
            fatalError("SUPABASE_KEY not set in plist for this environment")
        }
        return key
    }
}
