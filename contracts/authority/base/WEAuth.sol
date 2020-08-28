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

import "./WEBasicAuth.sol";
import "./WEAuthority.sol";

contract WEAuth  is WEBasicAuth {
    WEAuthority  public  _authority;

    event LogSetAuthority (address indexed authority, address from, bytes4 sig);


    function setAuthority(WEAuthority authority)
        public
        onlyAuthorized
    {
        _authority = authority;
        emit LogSetAuthority(authority, msg.sender, msg.sig);
    }

    modifier onlyAuthorized {
        require(isAuthorized(msg.sender, msg.sig), "WEAuth: is not authorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig) public view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == _owner) {
            return true;
        } else if (_authority == WEAuthority(0)) {
            return false;
        } else {
            return _authority.canCall(src, this, sig);
        }
    }
}