//
//  String+EXT.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 19/04/2024.
//

import Foundation

extension String{
    
     func capitalizeFirstLetter()->String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
