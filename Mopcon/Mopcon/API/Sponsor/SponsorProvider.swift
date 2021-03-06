//
//  SponsorProvider.swift
//  Mopcon
//
//  Created by WU CHIH WEI on 2019/8/23.
//  Copyright © 2019 EthanLin. All rights reserved.
//

import Foundation

class SponsorProvider {
    
    static func fetchSponsor(completion: @escaping SponsorListResultType) {
        
        HTTPClient.shared.request(
            SponsorAPI.sponsorList,
            completion: { result in
                
                switch result{
                    
                case .success(let data):
                    
                    do {
                        
                        let sponsorLists = try JSONDecoder.shared.decode(
                            SuccessResponse<[SponsorList]>.self,
                            from: data
                        )
                        
                        completion(Result.success(sponsorLists.data))
                        
                    } catch {
                        
                        completion(Result.failure(error))
                    }
                    
                case .failure(let error):
                    
                        completion(Result.failure(error))
                }
            }
        )
    }
    
    static func fetchSponsor(id: Int, completion: @escaping SponsorResultType) {
        
        HTTPClient.shared.request(
            SponsorAPI.sponsor(id),
            completion: { result in
                
                switch result{
                    
                case .success(let data):
                    
                    do {
                        
                        let sponsorLists = try JSONDecoder.shared.decode(
                            SuccessResponse<[Sponsor]>.self,
                            from: data
                        )
                        
                        completion(Result.success(sponsorLists.data))
                        
                    } catch {
                        
                        completion(Result.failure(error))
                    }
                    
                case .failure(let error):
                    
                        completion(Result.failure(error))
                }
            }
        )
    }
    
}
