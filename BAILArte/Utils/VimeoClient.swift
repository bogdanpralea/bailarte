//
//  VimeoClient.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 20/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import Foundation
import VimeoNetworking

/// Extend app configuration to provide a default configuration
extension AppConfiguration
{
    /// The default configuration to use for this application, populate your client key, secret, and scopes.
    /// Also, don't forget to set up your application to receive the code grant authentication redirect, see the README for details.
    static let defaultConfiguration = AppConfiguration(clientIdentifier: "993b88d430610ab9471e70378c692375e7f0e023", clientSecret: "1NYAIRCI0W0E5jiO2k7azvVawaPfrHPlAeJVQi3KJtdsCtJcJw0hBe7Zh7LfAzTz+wGwjPpw+d3HPUywTs8MdMxsVk2NwmfPLqOtG8sOoAJBozh9qA9EBVk9YgXotUsc", scopes: [.VideoFiles, .Private, .Public, .Interact], keychainService: "")
}

/// Extend vimeo client to provide a default client
extension VimeoClient
{
    /// The default client this application should use for networking, must be authenticated by an `AuthenticationController` before sending requests
    static let defaultClient = VimeoClient(appConfiguration: AppConfiguration.defaultConfiguration, configureSessionManagerBlock: nil)
    static let accessToken = "b43758b99f3b46553edddaf15f02cc73"
}

