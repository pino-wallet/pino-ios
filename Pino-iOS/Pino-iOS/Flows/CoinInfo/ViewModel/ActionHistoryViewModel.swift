//
//  ActionHistoryViewModel.swift
//  Pino-iOS
//
//  Created by Mohammadhossein Ghadamyari on 1/28/23.
//

import Foundation

struct ActionHistoryViewModel {
    //MARK: - Public Properties
    public var actionHistoryModel: ActionHistoryModel!

    
    public var actionIcon:String{
       return actionHistoryModel.actinIcon
    }
    
    public var actionTitle :String{
        return actionHistoryModel.actionTitle
    }
    
    public var time :String{
        return actionHistoryModel.time
    }
    
    public var status : ActionStatus{
        if let status = actionHistoryModel.status {
          return status
        }else{
            return .success
        }
    }
    
}
