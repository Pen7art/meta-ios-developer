//
//  UserProfile.swift
//  Meta ios developer
//
//  Created by Cristian Duciuc on 28/03/23.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    let firstName = UserDefaults.standard.string(forKey: firstNameKey)
    let lastName = UserDefaults.standard.string(forKey: lastNameKey)
    let email = UserDefaults.standard.string(forKey: emailKey)
    var body: some View {
        VStack {
            Text("Personal information")
            Image("profile-image-placeholder").resizable().frame(width: 100, height: 100)
            Text(firstName ?? "")
            Text(lastName ?? "")
            Text(email ?? "")
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: isLoggedInKey)
                self.presentation.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
