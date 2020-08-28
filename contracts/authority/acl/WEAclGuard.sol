// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.4.25;

import "./base/WEAuth.sol";

contract WEAclGuard is WEAuth, WEAuthority {
    bytes4 constant public ANY_SIG = bytes4(uint(-1));
    address constant public ANY_ADDRESS = address(bytes20(uint(-1)));

    mapping (address => mapping (address => mapping (bytes4 => bool))) _acl;

    event LogPermit(
        address indexed src,
        address indexed dst,
        bytes4 indexed sig
    );

    event LogForbid(
        address indexed src,
        address indexed dst,
        bytes4 indexed sig
    );

    constructor() public {
        setOwner(msg.sender);
    }

    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool) {
        return _acl[src][dst][sig]
            || _acl[src][dst][ANY_SIG]
            || _acl[src][ANY_ADDRESS][sig]
            || _acl[src][ANY_ADDRESS][ANY_SIG]
            || _acl[ANY_ADDRESS][dst][sig]
            || _acl[ANY_ADDRESS][dst][ANY_SIG]
            || _acl[ANY_ADDRESS][ANY_ADDRESS][sig]
            || _acl[ANY_ADDRESS][ANY_ADDRESS][ANY_SIG];
    }

    function permit(address src, address dst, bytes4 sig) public onlyAuthorized {
        _acl[src][dst][sig] = true;
        emit LogPermit(src, dst, sig);
    }

    function forbid(address src, address dst, bytes4 sig) public onlyAuthorized {
        _acl[src][dst][sig] = false;
        emit LogForbid(src, dst, sig);
    }
    
    function permit(address src, address dst, string sig) external {
        permit(src, dst, bytes4(keccak256(sig)));
    }
    
    function forbid(address src, address dst, string sig) external {
        forbid(src, dst, bytes4(keccak256(sig)));
    }

    function permitAny(address src, address dst) external {
        permit(src, dst, ANY_SIG);
    }
    
    function forbidAny(address src, address dst) external {
        forbid(src, dst, ANY_SIG);
    }
}
