//
//  RoundedTextField.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/1/25.
//

import SwiftUI

struct RoundedTextField: View {
    var placeHolder: String
    @Binding var text: String
    var isSecure: Bool=false // hide the text or not (like entering password)
    
    var body: some View {
        Group{
            if isSecure{
                SecureField(placeHolder, text: $text)
                    .foregroundColor(.gray)
            }
            else {
                TextField(placeHolder, text: $text)
                    .foregroundColor(.gray)
            }
        }
        
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

struct RoundedTextField_Previews: PreviewProvider {
    @State static var email = "sdf"
    
    static var previews: some View {
        RoundedTextField(placeHolder: "Place Holder", text: $email)
    }
}
