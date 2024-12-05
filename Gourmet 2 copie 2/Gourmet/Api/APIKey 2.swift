//
//  APIKey 2.swift
//  Gourmet
//
//  Created by Nawel kaabi on 2/12/2024.
//


import Foundation

enum APIKey {
    // Fetch the API key from `GenerativeAI-Info.plist`
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            fatalError("Error: Couldn't find file 'GenerativeAI-Info.plist'. Ensure the file exists and is added to your project.")
        }

        guard let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Error: Unable to read 'GenerativeAI-Info.plist'. Ensure it is properly formatted.")
        }

        guard let value = plist.object(forKey: "API_KEY") as? String else {
            fatalError("Error: Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'. Ensure the key is correctly defined.")
        }

        guard !value.starts(with: "_") else {
            fatalError("""
                Error: The API key appears to be invalid. 
                Follow the instructions at https://ai.google.dev/tutorials/setup to get a valid API key.
                """)
        }

        return value
    }
}
