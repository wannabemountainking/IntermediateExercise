//
//  GoodMovie.swift
//  IntermediateExercise
//
//  Created by YoonieMac on 1/18/26.
//

import SwiftUI
import Combine


struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let year: Int
    var rating: Double?
    var genre: [String]
    var director: String?
}

class MovieDataViewModel: ObservableObject {
    
    let movies: [Movie] = [
        // 평점이나 감독 정보가 없는 경우들 추가
        Movie(title: "Dune", year: 2021, rating: 8.0, genre: ["SF", "Adventure"], director: "Denis Villeneuve"),
        Movie(title: "Everything Everywhere All at Once", year: 2022, rating: 8.9, genre: ["SF", "Comedy"], director: "Daniel Kwan"),
        Movie(title: "The Batman", year: 2022, rating: nil, genre: ["Action", "Crime"], director: "Matt Reeves"),  // 평점 없음
        Movie(title: "Top Gun: Maverick", year: 2022, rating: 8.3, genre: ["Action", "Drama"], director: nil),  // 감독 정보 없음
        Movie(title: "Avatar: The Way of Water", year: 2022, rating: 7.6, genre: ["SF", "Adventure"], director: "James Cameron"),
        Movie(title: "Oppenheimer", year: 2023, rating: nil, genre: ["Biography", "Drama"], director: "Christopher Nolan"),  // 평점 없음
        Movie(title: "Barbie", year: 2023, rating: 7.0, genre: ["Comedy", "Fantasy"], director: nil),  // 감독 정보 없음
        Movie(title: "The Whale", year: 2022, rating: 7.7, genre: ["Drama"], director: "Darren Aronofsky"),
        Movie(title: "Spider-Man: No Way Home", year: 2021, rating: nil, genre: ["Action", "SF"], director: nil),  // 둘 다 없음
        Movie(title: "Parasite", year: 2019, rating: 8.5, genre: ["Thriller", "Drama"], director: "Bong Joon-ho"),
        
        Movie(title: "Interstellar", year: 2014, rating: 8.7, genre: ["SF", "Drama"], director: "Christopher Nolan"),
        Movie(title: "Inception", year: 2010, rating: 8.8, genre: ["SF", "Thriller"], director: nil),
        Movie(title: "Mad Max: Fury Road", year: 2015, rating: nil, genre: ["Action", "Adventure"], director: "George Miller"),
        Movie(title: "La La Land", year: 2016, rating: 8.0, genre: ["Musical", "Romance"], director: "Damien Chazelle"),
        Movie(title: "Arrival", year: 2016, rating: nil, genre: ["SF", "Drama"], director: "Denis Villeneuve"),
        Movie(title: "Whiplash", year: 2014, rating: 8.5, genre: ["Drama", "Music"], director: nil),
        Movie(title: "The Grand Budapest Hotel", year: 2014, rating: 8.1, genre: ["Comedy", "Drama"], director: "Wes Anderson"),
        Movie(title: "Get Out", year: 2017, rating: nil, genre: ["Horror", "Thriller"], director: "Jordan Peele"),
        Movie(title: "Dunkirk", year: 2017, rating: 7.8, genre: ["War", "Drama"], director: nil),
        Movie(title: "1917", year: 2019, rating: 8.2, genre: ["War", "Drama"], director: "Sam Mendes"),
        Movie(title: "Joker", year: 2019, rating: nil, genre: ["Crime", "Drama"], director: "Todd Phillips"),
        Movie(title: "Blade Runner 2049", year: 2017, rating: 8.0, genre: ["SF", "Thriller"], director: nil),
        Movie(title: "Django Unchained", year: 2012, rating: 8.4, genre: ["Western", "Drama"], director: "Quentin Tarantino"),
        Movie(title: "The Wolf of Wall Street", year: 2013, rating: nil, genre: ["Biography", "Comedy"], director: "Martin Scorsese"),
        Movie(title: "Her", year: 2013, rating: 8.0, genre: ["Romance", "SF"], director: nil),
        
        Movie(title: "The Dark Knight", year: 2008, rating: 9.0, genre: ["Action", "Crime"], director: "Christopher Nolan"),
        Movie(title: "The Departed", year: 2006, rating: nil, genre: ["Crime", "Thriller"], director: "Martin Scorsese"),
        Movie(title: "There Will Be Blood", year: 2007, rating: 8.2, genre: ["Drama"], director: nil),
        Movie(title: "No Country for Old Men", year: 2007, rating: nil, genre: ["Crime", "Thriller"], director: "Coen Brothers"),
        Movie(title: "The Prestige", year: 2006, rating: 8.5, genre: ["Drama", "Mystery"], director: nil),
        Movie(title: "Gladiator", year: 2000, rating: 8.5, genre: ["Action", "Drama"], director: "Ridley Scott"),
        Movie(title: "Memento", year: 2000, rating: nil, genre: ["Mystery", "Thriller"], director: "Christopher Nolan"),
        Movie(title: "Pan's Labyrinth", year: 2006, rating: 8.2, genre: ["Fantasy", "Drama"], director: nil),
        Movie(title: "Eternal Sunshine", year: 2004, rating: nil, genre: ["Romance", "SF"], director: "Michel Gondry"),
        Movie(title: "Finding Nemo", year: 2003, rating: 8.1, genre: ["Animation", "Adventure"], director: nil),
        
        Movie(title: "The Shawshank Redemption", year: 1994, rating: 9.3, genre: ["Drama"], director: "Frank Darabont"),
        Movie(title: "Pulp Fiction", year: 1994, rating: nil, genre: ["Crime", "Drama"], director: "Quentin Tarantino"),
        Movie(title: "The Matrix", year: 1999, rating: 8.7, genre: ["SF", "Action"], director: nil),
        Movie(title: "Fight Club", year: 1999, rating: nil, genre: ["Drama"], director: "David Fincher"),
        Movie(title: "Forrest Gump", year: 1994, rating: 8.8, genre: ["Drama", "Romance"], director: nil),
        Movie(title: "The Silence of the Lambs", year: 1991, rating: 8.6, genre: ["Crime", "Thriller"], director: "Jonathan Demme"),
        Movie(title: "Schindler's List", year: 1993, rating: nil, genre: ["Biography", "Drama"], director: "Steven Spielberg"),
        Movie(title: "Saving Private Ryan", year: 1998, rating: 8.6, genre: ["War", "Drama"], director: nil),
        Movie(title: "The Sixth Sense", year: 1999, rating: nil, genre: ["Drama", "Mystery"], director: "M. Night Shyamalan"),
        Movie(title: "Goodfellas", year: 1990, rating: 8.7, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "The Truman Show", year: 1998, rating: 8.1, genre: ["Comedy", "Drama"], director: "Peter Weir"),
        Movie(title: "Toy Story", year: 1995, rating: nil, genre: ["Animation", "Family"], director: "John Lasseter"),
        
        Movie(title: "The Shining", year: 1980, rating: 8.4, genre: ["Horror", "Drama"], director: nil),
        Movie(title: "Back to the Future", year: 1985, rating: nil, genre: ["SF", "Comedy"], director: "Robert Zemeckis"),
        Movie(title: "Raiders of the Lost Ark", year: 1981, rating: 8.4, genre: ["Action", "Adventure"], director: nil),
        Movie(title: "E.T.", year: 1982, rating: nil, genre: ["SF", "Family"], director: "Steven Spielberg"),
        Movie(title: "The Empire Strikes Back", year: 1980, rating: 8.7, genre: ["SF", "Adventure"], director: nil),
        Movie(title: "Blade Runner", year: 1982, rating: nil, genre: ["SF", "Thriller"], director: "Ridley Scott"),
        Movie(title: "Scarface", year: 1983, rating: 8.3, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "The Breakfast Club", year: 1985, rating: nil, genre: ["Comedy", "Drama"], director: "John Hughes"),
        Movie(title: "Die Hard", year: 1988, rating: 8.2, genre: ["Action", "Thriller"], director: nil),
        Movie(title: "Ghostbusters", year: 1984, rating: nil, genre: ["Comedy", "Fantasy"], director: "Ivan Reitman"),
        
        Movie(title: "The Godfather", year: 1972, rating: 9.2, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "The Godfather Part II", year: 1974, rating: nil, genre: ["Crime", "Drama"], director: "Francis Ford Coppola"),
        Movie(title: "Star Wars", year: 1977, rating: 8.6, genre: ["SF", "Adventure"], director: nil),
        Movie(title: "One Flew Over the Cuckoo's Nest", year: 1975, rating: nil, genre: ["Drama"], director: "Milos Forman"),
        Movie(title: "Apocalypse Now", year: 1979, rating: 8.4, genre: ["War", "Drama"], director: nil),
        Movie(title: "Taxi Driver", year: 1976, rating: nil, genre: ["Crime", "Drama"], director: "Martin Scorsese"),
        Movie(title: "Alien", year: 1979, rating: 8.5, genre: ["Horror", "SF"], director: nil),
        Movie(title: "Rocky", year: 1976, rating: nil, genre: ["Drama", "Sport"], director: "John G. Avildsen"),
        Movie(title: "Jaws", year: 1975, rating: 8.1, genre: ["Thriller", "Adventure"], director: nil),
        Movie(title: "A Clockwork Orange", year: 1971, rating: nil, genre: ["Crime", "SF"], director: "Stanley Kubrick"),
        
        Movie(title: "The Lion King", year: 1994, rating: 8.5, genre: ["Animation", "Drama"], director: nil),
        Movie(title: "Spirited Away", year: 2001, rating: nil, genre: ["Animation", "Fantasy"], director: "Hayao Miyazaki"),
        Movie(title: "WALL-E", year: 2008, rating: 8.4, genre: ["Animation", "SF"], director: nil),
        Movie(title: "Up", year: 2009, rating: nil, genre: ["Animation", "Adventure"], director: "Pete Docter"),
        Movie(title: "Inside Out", year: 2015, rating: 8.1, genre: ["Animation", "Drama"], director: nil),
        Movie(title: "Coco", year: 2017, rating: nil, genre: ["Animation", "Family"], director: "Lee Unkrich"),
        Movie(title: "The Avengers", year: 2012, rating: 8.0, genre: ["Action", "SF"], director: nil),
        Movie(title: "The Social Network", year: 2010, rating: nil, genre: ["Biography", "Drama"], director: "David Fincher"),
        Movie(title: "Birdman", year: 2014, rating: 7.7, genre: ["Comedy", "Drama"], director: nil),
        Movie(title: "Moonlight", year: 2016, rating: nil, genre: ["Drama"], director: "Barry Jenkins"),
        Movie(title: "Shape of Water", year: 2017, rating: nil, genre: ["Fantasy", "Romance"], director: "Guillermo del Toro"),
        Movie(title: "Gravity", year: 2013, rating: 7.7, genre: ["SF", "Thriller"], director: nil),
        Movie(title: "Gone Girl", year: 2014, rating: nil, genre: ["Mystery", "Thriller"], director: "David Fincher"),
        Movie(title: "Prisoners", year: 2013, rating: 8.1, genre: ["Crime", "Thriller"], director: nil),
        Movie(title: "Sicario", year: 2015, rating: nil, genre: ["Action", "Crime"], director: "Denis Villeneuve"),
        Movie(title: "Manchester by the Sea", year: 2016, rating: 7.8, genre: ["Drama"], director: nil),
        Movie(title: "Room", year: 2015, rating: nil, genre: ["Drama", "Thriller"], director: "Lenny Abrahamson"),
        Movie(title: "Three Billboards", year: 2017, rating: 8.1, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "Knives Out", year: 2019, rating: nil, genre: ["Comedy", "Mystery"], director: "Rian Johnson"),
        Movie(title: "Ford v Ferrari", year: 2019, rating: 8.1, genre: ["Biography", "Drama"], director: nil),
        Movie(title: "Once Upon a Time in Hollywood", year: 2019, rating: nil, genre: ["Comedy", "Drama"], director: "Quentin Tarantino"),
        Movie(title: "The Irishman", year: 2019, rating: 7.8, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "A Beautiful Mind", year: 2001, rating: nil, genre: ["Biography", "Drama"], director: "Ron Howard"),
        Movie(title: "The Green Mile", year: 1999, rating: 8.6, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "American Beauty", year: 1999, rating: nil, genre: ["Drama"], director: "Sam Mendes"),
        Movie(title: "The Usual Suspects", year: 1995, rating: 8.5, genre: ["Crime", "Mystery"], director: nil),
        Movie(title: "Se7en", year: 1995, rating: nil, genre: ["Crime", "Thriller"], director: "David Fincher"),
        Movie(title: "The Big Lebowski", year: 1998, rating: 8.1, genre: ["Comedy", "Crime"], director: nil),
        Movie(title: "Fargo", year: 1996, rating: nil, genre: ["Crime", "Thriller"], director: "Coen Brothers"),
        Movie(title: "Casino", year: 1995, rating: 8.2, genre: ["Crime", "Drama"], director: nil),
        Movie(title: "Heat", year: 1995, rating: nil, genre: ["Action", "Crime"], director: "Michael Mann"),
        Movie(title: "The Terminator", year: 1984, rating: 8.1, genre: ["SF", "Action"], director: nil),
        Movie(title: "Terminator 2", year: 1991, rating: nil, genre: ["SF", "Action"], director: "James Cameron"),
        Movie(title: "Aliens", year: 1986, rating: 8.4, genre: ["Action", "SF"], director: nil),
        Movie(title: "RoboCop", year: 1987, rating: nil, genre: ["SF", "Action"], director: "Paul Verhoeven"),
        Movie(title: "Predator", year: 1987, rating: 7.8, genre: ["SF", "Action"], director: nil)
    ]
    
    var moviesHavingRating: [Movie] {
        movies.compactMap {
            guard let _ = $0.rating else {return nil}
            return $0
        }
    }
    
    var latestMoviesOverEight: [Movie] {
        movies.filter { $0.year >= 2020 }
            .filter { ($0.rating ?? 0.0) >= 8.0 }
    }
    
    var allGenre: [String] {
        movies.flatMap { $0.genre }
    }
    
    var moviesHavingTitleWithYear: [String] {
        movies.map { "제목  \($0.title) (\($0.year)년도)" }
    }
    
    var ActionMasterpieces: [String] {
        movies.filter {
            $0.genre.contains("Action")
            && (($0.rating ?? 0.0) >= 7.5)
            && ($0.director != nil)
        }
        .sorted(by: { $0.year > $1.year })
        .prefix(5)
        .map { $0.title }
    }
}


struct GoodMovie: View {
    @State private var showMoviesHavingRating: Bool = false
    @State private var showLatestMoviesOverEight: Bool = false
    @State private var showAllGenre: Bool = false
    @State private var showMovieTitleAndYear: Bool = false
    @State private var showActionMasterpieces: Bool = false
    
    let vm: MovieDataViewModel = MovieDataViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Button("평점이 있는 영화") {
                    withAnimation(.spring) {
                        showMoviesHavingRating = true
                        allConditionFalseExceptNow(nowCondition: "showMoviesHavingRating")
                    }
                }
                .frame(width: .infinity, height: .infinity)
                
                Button("2020년 이후 개봉한 평점 8.0 이상 영화") {
                    withAnimation(.spring) {
                        showLatestMoviesOverEight = true
                        allConditionFalseExceptNow(nowCondition: "showLatestMoviesOverEight")
                    }
                }
                .frame(width: .infinity, height: .infinity)
                
                Button("모든 영화의 장르 (중복 포함)") {
                    withAnimation(.spring) {
                        showAllGenre = true
                        allConditionFalseExceptNow(nowCondition: "showAllGenre")
                    }
                }
                .frame(width: .infinity, height: .infinity)
                
                Button("모든 영화의 제목과 개봉년도") {
                    withAnimation(.spring) {
                        showMovieTitleAndYear = true
                        allConditionFalseExceptNow(nowCondition: "showMovieTitleAndYear")
                    }
                }
                .frame(width: .infinity, height: .infinity)
                
                Button("위대한 액션 영화 베스트 5") {
                    withAnimation(.spring) {
                        showActionMasterpieces = true
                        allConditionFalseExceptNow(nowCondition: "showActionMasterpieces")
                    }
                }
                .frame(width: .infinity, height: .infinity)
            }//: Form
            
            if showMoviesHavingRating {
                List
            }
            
        } //:NAVIGATION
    }
    
    private func allConditionFalseExceptNow(nowCondition: String) {

        showAllGenre = false
        showActionMasterpieces = false
        showMoviesHavingRating = false
        showMovieTitleAndYear = false
        showLatestMoviesOverEight = false
        
        switch nowCondition {
            case "showAllGenre":
                showAllGenre = true
            case "showActionMasterpieces":
                showActionMasterpieces = true
            case "showMoviesHavingRating":
                showMoviesHavingRating = true
            case "showMovieTitleAndYear":
                showMovieTitleAndYear = true
            case "showLatestMoviesOverEight":
                showLatestMoviesOverEight = true
            default: print("에러")
        }
    }
}


#Preview {
    GoodMovie()
}
