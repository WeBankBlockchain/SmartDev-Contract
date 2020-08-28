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

contract WEBasicAuth {
    address public  _owner;
    event LogSetOwner(address indexed owner, address indexed oldOwner,  address indexed contractAddress);

    constructor() public {
        _owner = msg.sender;
    }

    function setOwner(address owner)
        public
        onlyOwner
    {
        _owner = owner;
        emit LogSetOwner(owner, _owner, this);
    }

    modifier onlyOwner() { 
        require(msg.sender == _owner, "WEBasicAuth: only owner is authorized.");
        _; 
    }
}