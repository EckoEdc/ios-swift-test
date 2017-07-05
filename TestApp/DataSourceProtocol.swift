//
//  DataSource.swift
//  TestApp
//
//  Created by Edric MILARET on 17-07-05.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import Foundation

protocol DataSourceProtocol {
    func getAllNotes(onComplete: @escaping ([NoteModel], Error?) -> ())
}
