//
//  AIResponsesView.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 12/6/24.
//

import SwiftUI

struct AIResponsesView: View {
    @Binding var aiResponses: [String] // Liste des réponses stockées

    var body: some View {
        NavigationView {
            List(aiResponses, id: \.self) { response in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Réponse de l'IA")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(response)
                        .font(.body)
                        .foregroundColor(.black)
                }
                .padding()
            }
            .navigationTitle("Historique des Recherches")
        }
    }
}

