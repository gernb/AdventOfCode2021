//
//  InputData.swift
//  Day 12
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    case example1, example2, example3, challenge

    var data: [String] {
        switch self {

        case .example1: return """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
""".components(separatedBy: .newlines)

        case .example2: return """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
""".components(separatedBy: .newlines)

        case .example3: return """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
""".components(separatedBy: .newlines)

        case .challenge: return """
end-ry
jf-jb
jf-IO
jb-hz
jo-LM
hw-end
hw-LM
hz-ry
WI-start
LM-start
kd-jf
xi-WI
hw-jb
hz-jf
LM-jb
jb-xi
ry-jf
WI-jb
end-hz
jo-start
WI-jo
xi-ry
xi-LM
xi-hw
jo-xi
WI-jf
""".components(separatedBy: .newlines)

        }
    }
}
