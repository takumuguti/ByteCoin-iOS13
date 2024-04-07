//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ error: Error)
    func didUpdateRate(_ rate: Double)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8FD72BF9-7A6B-4CE5-8C81-A7CA857AF40A"
    
    var delegate: CoinManagerDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        print("getting the price for: \(currency)")
        let requestURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(requestURL)
        performRequest(urlString: requestURL)
    }
    
    func performRequest(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url){(data, reponse, error)  in
            if error != nil {
                self.delegate?.didFailWithError(error!)
                return
            }
            if let safeData = data {
                if let rate = self.parseJSON(safeData){
                    delegate?.didUpdateRate(rate)
                }
            }
        }
        task.resume()
        
    }
    func parseJSON(_ bitCoinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(BitCoinData.self, from: bitCoinData)
            let rate = decodedData.rate
            return rate
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
