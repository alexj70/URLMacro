import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(URLMacroMacros)
import URLMacroMacros

let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self,
]
#endif

final class URLMacroTests: XCTestCase {
    func testValidURL() {
        assertMacroExpansion(
            #"""
            #URL("https://www.avanderlee.com")
            """#,
            expandedSource: #"""
            URL(string: "https://www.avanderlee.com")!
            """#,
            macros: testMacros
        )
    }
    
    func testURLStringLiteralError() {
        assertMacroExpansion(
            #"""
            #URL("https://www.avanderlee.com/\(Int.random())")
            """#,
            expandedSource: #"""

            """#,
            diagnostics: [
                DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
