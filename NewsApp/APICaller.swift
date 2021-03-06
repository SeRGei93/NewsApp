//
//  APICaller.swift
//  NewsApp
//
//  Created by Сергей Бушкевич on 24.07.21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants{
        static let topHeadingURL = URL(string: "https://newsapi.org/v2/top-headlines?country=RU&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    }
    
    private init(){}
    
    public func getTopStories(completition: @escaping (Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadingURL else{return}
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error{
                completition(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    //print("Articles count \(result.articles.count)")
                    completition(.success(result.articles))
                }catch{
                    completition(.failure(error))
                }
            }
        }
        
        task.resume()
        
    }
}

//Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}
struct Source:Codable {
    let name: String
}
