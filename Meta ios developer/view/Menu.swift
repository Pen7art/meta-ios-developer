//
//  Menu.swift
//  Meta ios developer
//
//  Created by Cristian Duciuc on 28/03/23.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText = ""
    @State var categories: Set<String> = []
    @State var selectedCategories: Set<String> = []
    
    func buildPredicate() -> NSPredicate{
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    
    func getMenuData()  {
        PersistenceController.shared.clear()
        let urlString: String = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession.shared.dataTask(with: urlRequest) { data, URLResponse, error in
            if data != nil {
                let decoded = try? JSONDecoder().decode(MenuList.self, from: data!)
                decoded?.menu.forEach({ menuItem in
                    let dish = Dish(context: viewContext)
                    dish.title = menuItem.title
                    dish.price = menuItem.price
                    dish.image = menuItem.image
                    dish.category = menuItem.category
                    
                    categories.insert(menuItem.category)
                })
                try? viewContext.save()
            }
            
        }
        urlSession.resume()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("little-lemon-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text("Little Lemon")
                Spacer()
                Image("profile-image-placeholder")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
            }.padding(.bottom)
            VStack(alignment: .leading){
                Text("Litte Lemon")
                    .foregroundColor(.yellow)
                    .padding(.top)
                Text("Chicago")
                    .padding(.bottom)
                HStack {
                    Text("We are a family owned Mediterranean restaurant focused on traditional recipes served with a modern twist.")
                        .padding(.bottom)
                    Image("lasagna")
                        .resizable()
                        .scaledToFit()
                }
                TextField("Search menu", text: $searchText)
            }.padding()
            .background(Color.green)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(categories.sorted(by: <), id: \.self) { category in
                        Button(category) {
                            if selectedCategories.contains(category){
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                        .padding()
                        .border(.gray, width: 1)
                        .background(selectedCategories.contains(category) ? Color.green: Color.white)
                        
                    }
                }
            }
            
            FetchedObjects(predicate: buildPredicate() ,sortDescriptors: buildSortDescriptors()){(dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            Text("\(dish.title ?? "") \(dish.price ?? "")")
                            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
                
            }
            Spacer()
        }.onAppear{
            getMenuData()
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
