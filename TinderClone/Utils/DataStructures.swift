//
//  DataStructures.swift
//  TinderClone
//
//  Created by HieuPM on 9/21/20.
//  Copyright © 2020 HieuPM. All rights reserved.
//

import Foundation

class DataStructures {
   public class Node<T> {
      public init(withKey key: T) {
         self.key = key
      }
      var key: T
      var next: Node?
   }
   
   
   public class Queue<T> {
      
      private var top: Node<T>?
      private var trail: Node<T>?
      private var _count: Int = 0
      public init() {
         
      }
      //enqueue the specified object
      public func enQueue(_ key: T) {
         
         let childToUse = Node<T>(withKey: key)
         _count += 1
         
         //trivial case
         guard top != nil else {
            top = childToUse
            trail = childToUse
            return
         }
         
         
         trail?.next = childToUse
         trail = childToUse
         
      }
      
      //retrieve items - O(1) constant time
      public func deQueue() -> Node<T>? {
         
         //determine key instance
         guard let validTop = top else {
            return nil
         }
         _count -= 1
         
         //retrieve and queue the next item
         let queueItem: Node<T>? = validTop
         
         
         //use optional binding
         if validTop.next == nil {
            trail = nil
         }
         
         top = validTop.next
         validTop.next = nil
         return queueItem
      }
      
      //retrieve the top most item
      public func peek() -> Node<T>? {
         return top
      }
      
      
      //check for the presence of a value
      public func isEmpty() -> Bool {
         
         guard top?.key != nil else {
            return true
         }
         return false
      }
      
      public func count() -> Int {
         return _count
      }
      
   }
}
