//
//  ViewController.swift
//  OutlineView
//
//  Created by SUNG HAO LIN on 2018/11/22.
//  Copyright © 2018 GanNaSong. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

  @IBOutlet weak var outlineView: NSOutlineView!
  @IBOutlet var treeController: NSTreeController!

  override func viewDidLoad() {
    super.viewDidLoad()
    addData()
    outlineView.expandItem(nil, expandChildren: true)
    outlineView.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  func addData() {
    let root: [String: Any]  = [
      "name": "Library",
      "isLeaf": false
    ]

    let dict: NSMutableDictionary = NSMutableDictionary(dictionary: root)
    let p1 = Playlists()
    p1.name = "P1"
    let p2 = Playlists()
    p2.name = "P2"
    dict.setObject([p1, p2], forKey: "children" as NSCopying)
    treeController.addObject(dict)
  }

  // MARK: - Helpers

  func isHeader(item: Any) -> Bool {
    if let item = item as? NSTreeNode {
      return !(item.representedObject is Playlists)
    } else {
      return !(item is Playlists)
    }
  }

  // MARK: - NSOutlineViewDelegate

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if isHeader(item: item) {
      return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self)
    } else {
      return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self)
    }
  }

  // MARK: - NSOutlineViewDataSource

  func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
    let pbItem = NSPasteboardItem()

    if let playlist = ((item as? NSTreeNode)?.representedObject) as? Playlists {
      pbItem.setString(playlist.name, forType: .string)
      return pbItem
    }
    return nil
  }

  func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    let canDrag = index >= 0 && item != nil
    if canDrag {
      return .move
    }
    return NSDragOperation.init(rawValue: 0)
  }

  func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
    let pb = info.draggingPasteboard
    let name = pb.string(forType: .string)

    var sourceNode: NSTreeNode?

    if let item = item as? NSTreeNode, item.children != nil {
      for node in item.children! {
        if let playlist = node.representedObject as? Playlists {
          if playlist.name == name {
            sourceNode = node
          }
        }
      }
    }

    if sourceNode == nil {
      return false
    }

    let indexArr: [Int] = [0, index]
    let toIndexPath = NSIndexPath(indexes: indexArr, length: 2)
    treeController.move(sourceNode!, to: toIndexPath as IndexPath)
    return true
  }

}
