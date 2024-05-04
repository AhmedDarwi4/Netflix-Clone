//
//  NFError.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 19/04/2024.
//

import Foundation

enum NFError:String,Error{
    case invalidUrl            = "Failed to make invalid request. Plaese try again."
    case internetIssue         = "Unable to complete your request.please check your internet connection."
    case invalidResponse       = "Invalid response from the server.please try again."
    case invalidData           = "The data received from the server was invalid.please try again."
    case databaseSavingError   = "Failed to save data."
    case databaseFetchingError = "Failed to fetch data from database."
    case databaseDeletingError = "Failed to delete data from database."
}
