//
//  PokemonDetailNetworking.swift
//  AppNicoMVVM
//
//  Created by Tag Livros on 04/01/20.
//  Copyright © 2020 Pedro Ullmann. All rights reserved.
//

import Foundation
import Alamofire

protocol PokemonDetailNetworkingProtocol: AnyObject {
    func getPokemonDetail(pokemon: String, completion: @escaping (Result<Pokemon>) -> Void)
}

class PokemonDetailNetworking: PokemonDetailNetworkingProtocol {
    func getPokemonDetail(pokemon: String, completion: @escaping (Result<Pokemon>) -> Void) {
        request("https://pokeapi.co/api/v2/pokemon/\(pokemon)",
            method: .get,
            encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let pokemonDetail = try decoder.decode(Pokemon.self, from: response.data!)
                    completion(Result.success(pokemonDetail))
                } catch let error {
                    completion(Result.error(error))
                }
            case .failure(let error):
                completion(Result.error(error))
            }
        }
    }
}
