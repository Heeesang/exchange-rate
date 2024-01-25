import Foundation

final class MainViewModel {
    private let apiURL = "http://apilayer.net/api/live?access_key=cfda733219463bb613cd235c7e067cdc&currencies=KRW,JPY,PHP&source=USD&format=1"
    
    //통신
    func fetchExchangeRates(completion: @escaping (Result<RateModel, Error>) -> Void) {
        guard let url = URL(string: apiURL) else { return print("error") }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let exchangeRateResponse = try decoder.decode(RateModel.self, from: data)
                completion(.success(exchangeRateResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
