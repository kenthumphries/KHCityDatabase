//
//  ContentView.swift
//  KHCityViewer
//
//  Created by Kent Humphries on 12/9/21.
//  Copyright © 2021 KentHumphries. All rights reserved.
//

import SwiftUI

struct CityView: View {
    @StateObject private var viewModel = CityViewViewModel()
    
    var body: some View {
        Text("Found \(viewModel.cities.count) cities")
            .padding()
        List() {
            ForEach(viewModel.cities, id: \.self) {city in
                Text("\(city.cityNamePreferred), \(city.admin1Code ?? "-"), \(city.countryCode)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
