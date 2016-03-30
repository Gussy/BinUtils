//
//  BinUtilsTests.swift
//  BinUtilsTests
//
//  Created by Nicolas Seriot on 14/03/16.
//  Copyright © 2016 Nicolas Seriot. All rights reserved.
//

import XCTest

class BinUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUnhexlify() {
        let s = String(data: unhexlify("48656C6C6F")!, encoding: NSUTF8StringEncoding)
        XCTAssertEqual(s, "Hello")
    }

    func testHexlifyUnhexlify() {
        let s1 = "ABcdEF"
        
        let s2 = hexlify(unhexlify(s1)!)
        
        XCTAssertEqual(s1.lowercaseString, s2)
    }

    func testUnpackWithFile() {
        let path = "/bin/ls"
        if let f = NSFileHandle(forReadingAtPath: path) {
            let a = unpack("<2H", f.readDataOfLength(4))
            f.closeFile()
         
            XCTAssertEqual(a[0] as? Int, 64207)
            XCTAssertEqual(a[1] as? Int, 65261)
        } else {
            XCTFail("cannot open \("/bin/ls") for reading")
        }
    }

    func testUnpack1() {
        let a = unpack(">hBsf", unhexlify("050001413fc00000")!)
        
        XCTAssertEqual(a[0] as? Int, 1280)
        XCTAssertEqual(a[1] as? Int, 1)
        XCTAssertEqual(a[2] as? String, "A")
        XCTAssertEqual(a[3] as? Double, 1.5)
    }

    func testUnpack2() {
        let a = unpack("<I 2s f", unhexlify("010000006162cdcc2c40")!)
        
        XCTAssertEqual(a[0] as? Int, 1)
        XCTAssertEqual(a[1] as? String, "ab")
        XCTAssertEqual(a[2] as? Double, 2.700000047683716)
    }

    func testUnpack3() {
        let a = unpack("<2sss", unhexlify("41414141")!)
        
        XCTAssertEqual(a[0] as? String, "AA")
        XCTAssertEqual(a[1] as? String, "A")
        XCTAssertEqual(a[2] as? String, "A")
    }

    func testFormatSizes() {

        XCTAssertEqual(0, numberOfBytesInFormat(""))
        XCTAssertEqual(1, numberOfBytesInFormat(">x"))
        XCTAssertEqual(2, numberOfBytesInFormat(">h"))
        XCTAssertEqual(4, numberOfBytesInFormat(">I"))
        XCTAssertEqual(5, numberOfBytesInFormat(">5s"))
        XCTAssertEqual(6, numberOfBytesInFormat(">5sb"))
        XCTAssertEqual(8, numberOfBytesInFormat(">hBsf"))
    }
    
    func testPointerSize() {
        let a = unpack("@P", unhexlify("0001000200000003")!)
        XCTAssertEqual(a[0] as? Int, 216172782147338496)
    }
    
    func testPackLittleEndian() {
        let data = pack("<Ih", [1, 2])
        XCTAssertEqual(data, unhexlify("01000000 0200"))
    }

    func testPackBigEndian() {
        let data = pack(">Ih", [1, 2])
        XCTAssertEqual(data, unhexlify("00000001 0002"))
    }

    func testPackDefaultLittleEndianAndNativeSize() {
        let data = pack("Ih", [1, 2])
        XCTAssertEqual(data, unhexlify("00000000 01000000 00000000 00000200"))
    }

    func testPackPointer() {
        let data = pack("@P", [1])
        XCTAssertEqual(data, unhexlify("00000000 01000000"))
    }

    func testPackWithPadding() {
        let data = pack("xh", [123])
        XCTAssertEqual(data, unhexlify("00000000 00007b00"))
    }
}

