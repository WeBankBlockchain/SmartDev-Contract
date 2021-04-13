/*
 * Copyright 2014-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * */

pragma solidity ^0.4.25;

import "./LibRoles.sol";

contract IssuerRole {
    using LibRoles for LibRoles.Role;

    event IssuerAdded(address indexed account);
    event IssuerRemoved(address indexed account);

    LibRoles.Role private _issuers;

    constructor () internal {
        _issuers.add(msg.sender);
    }

    modifier onlyIssuer() {
        require(isIssuer(msg.sender), "IssuerRole: caller does not have the Issuer role");
        _;
    }

    function isIssuer(address account) public view returns (bool) {
        return _issuers.has(account);
    }

    function addIssuer(address account) public {
        _issuers.add(account);
        emit IssuerAdded(account);
    }

    function renounceIssuer(address account) public onlyIssuer {
        _issuers.remove(account);
        emit IssuerRemoved(account);
    }
}