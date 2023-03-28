//
//  Menu.swift
//  Meta ios developer
//
//  Created by Cristian Duciuc on 28/03/23.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack {
            Text("Title")
            Text("Restaurant")
            Text("Description")
            List {
            }
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
