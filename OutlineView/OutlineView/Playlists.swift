//
//  Playlists.swift
//  OutlineView
//
//  Created by SUNG HAO LIN on 2018/11/22.
//  Copyright © 2018 GanNaSong. All rights reserved.
//

import Cocoa

@objcMembers class Playlists: NSObject {

  dynamic var name: String = "New Playlist"
  dynamic var creator: String = "User"

  func isLeaf() -> Bool {
    return true
  }

}
