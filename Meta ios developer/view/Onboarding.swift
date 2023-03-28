//
//  Onboarding.swift
//  Meta ios developer
//
//  Created by Cristian Duciuc on 28/03/23.
//
import SwiftUI

let firstNameKey = "firstName"
let lastNameKey = "lastName"
let emailKey = "email"
let isLoggedInKey = "isLoggedIn"

struct Onboarding: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            
            VStack{
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                Button("Register") {
                    if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
                        return
                    }
                    UserDefaults.standard.set(firstName, forKey: firstNameKey)
                    UserDefaults.standard.set(lastName, forKey: lastNameKey)
                    UserDefaults.standard.set(email, forKey: email)
                    UserDefaults.standard.set(true, forKey: isLoggedInKey)
                    isLoggedIn = true
                }
            }.onAppear{
                if UserDefaults.standard.bool(forKey: isLoggedInKey) {
                    isLoggedIn = true
                }
            }
        }
    }
    
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
