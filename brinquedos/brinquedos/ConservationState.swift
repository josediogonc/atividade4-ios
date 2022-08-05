//
//  ConservationState.swift
//  brinquedos
//
//  Created by user225450 on 8/1/22.
//
enum ConservationState : String {
    case NOVO
    case USADO
    case REPARO
    
    func getSegmentIndex() -> Int {
        switch self {
            case .NOVO: return 0
            case .USADO: return 1
            case .REPARO: return 2
        }
    }
}
