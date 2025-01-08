//
//  db.swift
//  HiKiddo
//
//  Created by W on 08/01/2025.
//

import Foundation
import Supabase

struct Database {
    static let client: SupabaseClient = {
        return SupabaseClient(
            supabaseURL: URL(string: "https://ftxfpujezbupjwxxnopp.supabase.co")!,
            supabaseKey: Environment.supabaseKey)
    }()
}
