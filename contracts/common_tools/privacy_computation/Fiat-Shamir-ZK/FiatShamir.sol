pragma solidity >=0.4.16 <0.9.0;

contract FiatShamir {
    //============Phase 0: Agreed parameters===================
    // prime
    uint public n = 8269;
    // generator
    uint public g = 11;
    //=========================================================
    
    // g^x mod n
    uint y;
    // Victor's random challenge
    uint public c;
    // peggy sends random t 
    uint t;
    
    //======Phase 1: Peggy sends y to Victor,Victor store y as Peggy' token==================
    // peggy registers with y,  y = g^x mod n
    function Step1_register( uint _y) public {
        y = _y;
    }
    //=======================================================================================
    
    //======Phase 2: Peggy wants to login , She send t to Victor=============================
    function Step2_login(uint _t) public {
        t = _t;
    }
    //=======================================================================================
    
    //======Phase 3: Victor choose c randomly ,and sends it to Peggy=========================
    function Step3_randomchallenge() external returns (uint){
        c = randomgen();
        return c;
    }

    //TODO : NOT secure , low entropy ,change random source.
    function randomgen() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp))) % n;
    }
    //=======================================================================================
    
    //======Phase 4: Peggy recieves c and calculate r=v-cx, sends r to Victor================
    //======Phase 5: Victor calculates (g^r)*(y^c)== t? =====================================
    function Step45_verify(uint r) public  returns (bool){
        uint256 result = 0;
        
        result = (modExp(g,r,n)*modExp(y,c,n)) % n;
        
        return t == result;
    }
    //=======================================================================================
    

    // modular algorithm : calculate  b**e mod m
    function modExp(uint256 _b, uint256 _e, uint256 _m) private returns (uint256 result) {
        assembly {
            // Free memory pointer
            let pointer := mload(0x40)

            // Define length of base, exponent and modulus. 0x20 == 32 bytes
            mstore(pointer, 0x20)
            mstore(add(pointer, 0x20), 0x20)
            mstore(add(pointer, 0x40), 0x20)

            // Define variables base, exponent and modulus
            mstore(add(pointer, 0x60), _b)
            mstore(add(pointer, 0x80), _e)
            mstore(add(pointer, 0xa0), _m)

            // Store the result
            let value := mload(0xc0)

            // Call the precompiled contract 0x05 = bigModExp
            if iszero(call(not(0), 0x05, 0, pointer, 0xc0, value, 0x20)) {
                revert(0, 0)
            }

            result := mload(value)
        }
    }
}