//
//  DynamicList.swift
//  Movie List
//
//  Created by Pavel Bohomolnyi on 02/09/2022.
//

import SwiftUI

struct Movie: Identifiable {
    var id = UUID()
    let title: String
    let year: String
}

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
}

struct DynamicList: View {
    
    @State var boolValue = false
    @StateObject var viewModel = MoviesViewModel()
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
                // Show the data in list form
                List {
                    ForEach(viewModel.movies) { movie in
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
        
        
        // Condition to check whether the data is already exit or not
        boolValue = false
        let newMovie = Movie(title: text, year: year)
        for movie in viewModel.movies{
            if ((movie.title.contains(text)) && (movie.year.contains(year))){
                boolValue = true
            }
        }
        // check if boolValue is false so the data will store into the array.
        if boolValue == false{
            viewModel.movies.append(newMovie)
            text = ""
            year = ""
        }
    }
    
}

struct MovieRow: View {
    let title: String
    let year: String
    
    var body: some View {
        // Show the data insert into the textfield
        HStack{
            Label (
                title: { Text(title)},
                icon: { Image(systemName: "film") }
            )
            Spacer()
            Label (
                title: { Text(year)},
                icon: { Image(systemName: "calendar") }
            )
        }
    }
}

struct DynamicList_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
