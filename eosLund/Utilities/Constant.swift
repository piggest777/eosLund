//
//  Constant.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-27.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation

//Firebase reference
let GAMES_REF = "games"
let PLAYERS_REF = "players"

//Realm
let REALM_QUEUE = DispatchQueue(label: "realmQueue")

//game constants
let EOS_CODE = "eosCode"
let OPPOSITE_TEAM_CODE = "oppositeTeamCode"
let IS_HOME_GAME = "isHomeGame"
let EOS_SCORES = "eosScores"
let OPPOSITE_TEAM_SCORES = "oppositeTeamScores"
let GAME_DATE_AND_TIME = "gameDateAndTime"
let EOS_PLAYERS = "eosPlayers"
let OPPOSITE_TEAM_PLAYERS = "oppositeTeamPlayers"
let TEAM_LEAGUE = "teamLeague"
let GAME_DESCRIPTION = "gameDescription"
let STATISTIC_LINK = "statsLink"
let GAME_COVER_URL = "gameCoverUrl"

//player constants
let PLAYER_NAME = "playerName"
let PLAYER_NUMBER = "playerNumber"
let PLAYER_POSITION = "playerPosition"
let PLAYER_IMAGE_URL = "playerImageURL"
let PLAYER_UPDATE_DATE = "playerUpdateDate"
let DAY_OF_BIRTH = "dayOfBirth"
let PLAYER_HEIGHT = "playerHeight"
let PLAYER_NATIONALITY = "playerNationality"
let PLAYER_ORIGINAL_CLUB = "playerOriginalClub"
let PLAYER_INEOS_FROM  = "playerInEOSFrom"
let PLAYER_BIG_IMAGE_URL = "playerBigImageUrl"

//Team constants
let TEAM_NAME = "teamName"
let TEAM_CITY = "teamCity"
let HOME_ARENA = "homeArena"
let LOGO_PATH_NAME = "logoPathName"


//youtube API key
let API_KEY = "AIzaSyBxQ4uUEYTfTBp72F4EJzYueGLZa3v7Kmc"

//eos team base team
let EOS_TEAM: TeamFirestoreModel = TeamFirestoreModel(id: "EOS", teamName: "Eos Basket", teamCity: "Lund", homeArena: "Eoshallen", logoPathName: "eosLogo.png")

