//
//  DataLoader.swift
//  CardSlider
//
//  Created by Farah on 5/14/21.
//

import Foundation

@available(iOS 13.0, *)
public class DataLoader{
    @Published var userData = [Houses]()
    
    init() {
        load()
    }
    
    func load() {
        if let filelocation = Bundle.main.url(forResource: "houses", withExtension: "json"){
            //do catch in case of error
            do {
                let data = try Data(contentsOf: filelocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Houses].self, from: data)
                
                self.userData = dataFromJson
                
            } catch {
                print(error)
            }
        }
    }
    
//    func sort(){
//        self.userData = self.userData.sorted
//    }
}
