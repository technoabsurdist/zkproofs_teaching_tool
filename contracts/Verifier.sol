//SPDX-License-Identifier
pragma solidity ^0.4.17;

library Pairing {
    struct G1Point {
        uint256 X;
        uint256 Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint256[2] X;
        uint256[2] Y;
    }

    /// @return the generator of G1
    function P1() internal pure returns (G1Point) {
        return G1Point(1, 2);
    }

    /// @return the generator of G2
    function P2() internal pure returns (G2Point) {
        // Original code point
        return
            G2Point(
                [
                    11559732032986387107991004021392285783925812861821192530917403151452391805634,
                    10857046999023057135944570762232829481370756359578518086990519993285655852781
                ],
                [
                    4082367875863433681332203403145435568316851327593401208105741076214120093531,
                    8495653923123431417604973247489272438418190587263600148770280649306958101930
                ]
            );

        /*
        // Changed by Jordi point
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
*/
    }

    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point p) internal pure returns (G1Point) {
        // The prime q in the base field F_q for G1
        uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0) return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }

    /// @return the sum of two points of G1
    function addition(G1Point p1, G1Point p2)
        internal
        view
        returns (G1Point r)
    {
        uint256[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas, 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
    }

    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point p, uint256 s)
        internal
        view
        returns (G1Point r)
    {
        uint256[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas, 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
    }

    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] p1, G2Point[] p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint256 elements = p1.length;
        uint256 inputSize = elements * 6;
        uint256[] memory input = new uint256[](inputSize);
        for (uint256 i = 0; i < elements; i++) {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint256[1] memory out;
        bool success;
        assembly {
            success := staticcall(
                sub(gas, 2000),
                8,
                add(input, 0x20),
                mul(inputSize, 0x20),
                out,
                0x20
            )
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
        return out[0] != 0;
    }

    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(
        G1Point a1,
        G2Point a2,
        G1Point b1,
        G2Point b2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
        G1Point a1,
        G2Point a2,
        G1Point b1,
        G2Point b2,
        G1Point c1,
        G2Point c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
        G1Point a1,
        G2Point a2,
        G1Point b1,
        G2Point b2,
        G1Point c1,
        G2Point c2,
        G1Point d1,
        G2Point d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }

    function verifyingKey() internal pure returns (VerifyingKey vk) {
        vk.A = Pairing.G2Point(
            [
                4661366302196809121496998920045377152472999500656881059804435644866065168970,
                9991067233918662646640345893723738352964210154085411556764492493620001137731
            ],
            [
                6455660124259453436879835789947373810769938859930102022056437494887456208356,
                5579166500781486576014254740850744390225499774695147847386343470301341605405
            ]
        );
        vk.B = Pairing.G1Point(
            6265384266187662073700315977836605281867954384540680920867370949175280300912,
            12850190877051566811919909640289902099074130184847167573688514763971569719919
        );
        vk.C = Pairing.G2Point(
            [
                8101646058385261679227717713730377942978455875569016755475908233327998379171,
                2481152012691496720426770925847097596438054029709308140195057975572267589885
            ],
            [
                20207211903033122373390543071535898430632810442684727631342960843405777928276,
                18340041957737387649781259395328695291933344125605964366426336979263483072182
            ]
        );
        vk.gamma = Pairing.G2Point(
            [
                21074203972841680604280153035946306482478553577423800071517857585956572285669,
                13428266705035548705101262003102112643588608461125361297364949536960063425904
            ],
            [
                20100865717762104739086073700114740618786726126807894850657106792135781979803,
                19426399384034463639800231160086163386820311450593943657661811191494527907106
            ]
        );
        vk.gammaBeta1 = Pairing.G1Point(
            357804957883469497736023798828044618375636613413983204549263862320325178823,
            10710167835556869989807652438307128419403278059933109073486741396104356962208
        );
        vk.gammaBeta2 = Pairing.G2Point(
            [
                2694938062022508348364379887652649685373519710997866805663812228632156896429,
                13382658632043071659263662700251987703990680885164167974325719096699859852240
            ],
            [
                19948227475010383894880600572038299216522552397979640679175148092044033095421,
                2273120896200172318812219203421277800501860832024171529836517281965353494093
            ]
        );
        vk.Z = Pairing.G2Point(
            [
                10845918713224718013260343299126837647046053442322884606639091970721258680142,
                6597676180283303812048560687535192550761753951479825716251140241448774753491
            ],
            [
                479903942944544816945648785350299533320016838171560103455573786367610603249,
                3190610219084602863504179322459479865566821153697868429701642038446291320010
            ]
        );
        vk.IC = new Pairing.G1Point[](2);
        vk.IC[0] = Pairing.G1Point(
            19343808648392426372399262545375284614579575909076325735278304273311840077823,
            16487441093187451990158872598550907535657669382784361467285403349838725387846
        );
        vk.IC[1] = Pairing.G1Point(
            428794828237164308181536977403852474313412725051071541338252268512827818941,
            10792738081089011354724622625482024770835436684628798834791235229731335645289
        );
    }

    // first button: input[0], second button: input[1]
    function verify(uint256[] input, Proof proof)
        internal
        view
        returns (uint256)
    {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint256 i = 0; i < input.length; i++)
            vk_x = Pairing.addition(
                vk_x,
                Pairing.scalar_mul(vk.IC[i + 1], input[i])
            );
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (
            !Pairing.pairingProd2(
                proof.A,
                vk.A,
                Pairing.negate(proof.A_p),
                Pairing.P2()
            )
        ) return 1;
        if (
            !Pairing.pairingProd2(
                vk.B,
                proof.B,
                Pairing.negate(proof.B_p),
                Pairing.P2()
            )
        ) return 2;
        if (
            !Pairing.pairingProd2(
                proof.C,
                vk.C,
                Pairing.negate(proof.C_p),
                Pairing.P2()
            )
        ) return 3;
        if (
            !Pairing.pairingProd3(
                proof.K,
                vk.gamma,
                Pairing.negate(
                    Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))
                ),
                vk.gammaBeta2,
                Pairing.negate(vk.gammaBeta1),
                proof.B
            )
        ) return 4;
        if (
            !Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A),
                proof.B,
                Pairing.negate(proof.H),
                vk.Z,
                Pairing.negate(proof.C),
                Pairing.P2()
            )
        ) return 5;
        return 0;
    }

    function verifyProof(
        uint256[2] a,
        uint256[2] a_p,
        uint256[2][2] b,
        uint256[2] b_p,
        uint256[2] c,
        uint256[2] c_p,
        uint256[2] h,
        uint256[2] k,
        uint256[1] input
    ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint256[] memory inputValues = new uint256[](input.length);
        for (uint256 i = 0; i < input.length; i++) {
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }

    mapping(address => uint256) public balances;

    function mint(address receiver, uint256 amount) {
        balances[receiver] += amount;
    }
}
