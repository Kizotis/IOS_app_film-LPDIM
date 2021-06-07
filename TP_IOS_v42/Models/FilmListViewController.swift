//
//  FilmListViewController.swift
//  TP_IOS_v42
//
//  Created by Bouvard Antoine on 02/06/2021.
//

import UIKit

struct Movie {
    let title: String
    let subTitle: String
}

struct ReturnFilm: Codable {
    let results: [filmDetail]
    let page: Int
    let total_pages: Int
    let total_results: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case total_pages
        case total_results
    }
}

struct MovieGenres : Codable{
    var id : Int
    var name : String
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
    }
}


struct filmDetail: Codable {
    let adult: Bool?
    let backdrop_path: String?
    //let genre_ids: [Int]
    let genres: [MovieGenres]?
    let id: Int
    let original_language: String?
    let original_title: String?
    let popularity: Float?
    let title: String
    let overview: String
    let releaseDate: String
    let poster_path: String?
    let video: Bool?
    let vote_average: Float?
    let vote_count: Int?
    let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdrop_path
        case genres, id
        case original_language
        case original_title
        case overview, popularity
        case poster_path
        case releaseDate = "release_date"
        case runtime
        case title, video
        case vote_average
        case vote_count
    }
}

class FilmListViewController: UITableViewController {
    var movies: ReturnFilm = ReturnFilm(results: [], page: 1, total_pages: 1, total_results: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        resolveURL(completion: { (movies) in
            self.setupViews()
            self.movies = movies
        })
    }
    
    func resolveURL(completion: @escaping (_ films: ReturnFilm) -> Void )  {
        let session = URLSession.shared
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=56e27ac0065ffe89afc74212f903065c")!
        let task: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
        
            // Init JSON Decode object and decode json data into Category object
            do {
                let filmsResults: ReturnFilm = try JSONDecoder().decode(ReturnFilm.self, from: data)
                
                for film in filmsResults.results {
                    //self.movies.append(film)
                    let urlDetail = URL(string:"https://api.themoviedb.org/3/movie/\(film.id)api_key=56e27ac0065ffe89afc74212f903065c")!
                    let taskDetail: URLSessionDataTask = session.dataTask(with: urlDetail) { (data,response,error) in
                        if let data = data {
                            let filmDetails = try? JSONDecoder().decode(filmDetail.self,from: data)
                            
//                            if let details = filmDetails {
//                                self.movies.append(details)
//                            }
                        }
                    }
                    taskDetail.resume()
                }
                
                DispatchQueue.main.async{
                    completion(filmsResults)
                }
            } catch {
                print("Failed to decode with error : \(error)")
            }
        }
        task.resume()
    }
    
    func setupViews() {
        title = "Liste des films"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let movie = movies.results[indexPath.row]
        let dbCover = "https://image.tmdb.org/t/p/w500"
        
        cell.titreFilmlist.text = movie.title
        cell.synopsisFilmlist.text = movie.overview
        cell.dateFilmlist.text = movie.releaseDate
        if let posterPath = movie.poster_path, let url = URL(string: dbCover + posterPath) {
            let data = try? Data(contentsOf: url)
            cell.imgFilmlist.image = UIImage(data: data!)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies.results[indexPath.row]
        
        //let storyboard = UIStoryboard(name: "FilmListViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "Mainview") as! ViewController
        customViewController.recupmovie = movie
        navigationController?.pushViewController(customViewController, animated: true)
    }
    
    
}
