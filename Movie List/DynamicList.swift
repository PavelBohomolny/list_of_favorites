//
//  DynamicList.swift
//  Movie List
//
//  Created by Pavel Bohomolnyi on 02/09/2022.
//

import SwiftUI

struct Movie: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var year: String
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

class Model: ObservableObject {
    @Published var movies: [Movie] = []
}

struct DynamicList: View {
    
    @StateObject var model = Model()
    @State var text = ""
    @State var year = ""
    
    var body: some View {
        VStack {
            Section() {
                TextField("Title", text: $text)
                    .padding()
                    .border(.gray)
                TextField("Year", text: $year)
                    .padding()
                    .border(.gray)
                    .keyboardType(.numberPad)
                Button(action: {
                    self.addToList()
                }, label: {
                    Text("Add")
                        .frame(width: 80, height: 40, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                })
                .padding()
            }
            List {
                ForEach(model.movies.uniqued()) { movie in
                    MovieRow(title: movie.title, year: movie.year)
                }
            }
        }
        .padding()
    }
    
    func addToList() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard !year.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let newMovie = Movie(title: text, year: year)
        model.movies.append(newMovie)
        text = ""
        year = ""
    }
}

struct MovieRow: View {
    let title: String
    let year: String
    
    var body: some View {
        Label (
            title: { Text(title + " " + year)},
            icon: { Image(systemName: "film") }
        )
    }
}

struct DynamicList_Previews: PreviewProvider {
    static var previews: some View {
        DynamicList()
    }
}
