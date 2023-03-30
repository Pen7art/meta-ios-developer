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
                })
                try? viewContext.save()
            }
            
        }
        urlSession.resume()
    }
    
    var body: some View {
        VStack {
            Text("Title")
            Text("Restaurant")
            Text("Description")
            TextField("Search menu", text: $searchText)
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
