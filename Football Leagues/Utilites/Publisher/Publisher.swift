//
//  Publisher.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import Combine
import Foundation

extension Publisher where Self.Failure == Never {
    public func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        receive(on: DispatchQueue.main).sink { [weak object] (value) in
        object?[keyPath: keyPath] = value
    }
  }
}
