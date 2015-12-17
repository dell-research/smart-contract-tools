package com.dell.research.bc.eth.solidity.editor.tests.external

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import com.google.inject.Inject
import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import org.junit.Test
import org.junit.Ignore
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage

// These tests mirror the ones in 
// https://github.com/ethereum/solidity/blob/develop/test/libsolidity/SolidityParser.cpp
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class SolidityParseTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper

    @Test
    def void smokeTest() {
        '''contract test {
                         uint256 stateVariable1;
                       }'''.parse.assertNoErrors
    }

    val MISSING_VARIABLE_NAME_IN_DECLARATION = '''contract test {
                         uint256 ;
                       }'''

    @Ignore
    @Test
    def void missingVariableNameInDeclaration() {
        MISSING_VARIABLE_NAME_IN_DECLARATION.parse.assertNoErrors
    }

    @Test
    def void emptyFunction() {
        '''contract test {
                         uint256 stateVar;
                         function functionName(bytes20 arg1, address addr) constant
                           returns (int id)
                         { }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void noFunctionParams() {
        '''contract test {
                         uint256 stateVar;
                         function functionName() {}
                       }'''.parse.assertNoErrors
    }

    @Test
    def void singleFunctionParam() {
        '''contract test {
                         uint256 stateVar;
                         function functionName(bytes32 input) returns (bytes32 out) {}
                       }'''.parse.assertNoErrors
    }

    @Test
    def void functionNoBody() {
        '''contract test {
                         function functionName(bytes32 input) returns (bytes32 out);
                       }'''.parse.assertNoErrors
    }

    val MISSING_PARAMETER_NAME_IN_NAMED_ARGS = '''contract test {
                         function a(uint a, uint b, uint c) returns (uint r) { r = a * 100 + b * 10 + c * 1; }
                         function b() returns (uint r) { r = a({: 1, : 2, : 3}); }
                       }'''

    @Ignore
    @Test
    def void missingParameterNameInNamedArgs() {
        MISSING_PARAMETER_NAME_IN_NAMED_ARGS.parse.assertNoErrors
    }

    val MISSING_ARGUMENT_NAME_IN_NAMED_ARGS = '''contract test {
                         function a(uint a, uint b, uint c) returns (uint r) { r = a * 100 + b * 10 + c * 1; }
                         function b() returns (uint r) { r = a({a: , b: , c: }); }
                       }'''

    @Ignore
    @Test
    def void missingArgumentNameInNamedArgs() {
        MISSING_ARGUMENT_NAME_IN_NAMED_ARGS.parse.assertNoErrors
    }

    val TWO_EXACT_FUNCTIONS = '''contract test {
            function fun(uint a) returns(uint r) { return a; }
            function fun(uint a) returns(uint r) { return a; }
        }'''

    // There are multiple errors detected in this test resulting in a 
    // long expected output string.
    @Ignore
    @Test
    def void twoExactFunctions() {
        // TWO_EXACT_FUNCTIONS.parse.assertNoErrors
        var s = TWO_EXACT_FUNCTIONS.parse;
        s.assertError(SolidityPackage::eINSTANCE.solidity, "ERROR",
            "Expected ERROR 'ERROR' on Solidity at [-1:-1] but got[")
    }

    val OVERLOADED_FUNCTIONS = '''contract test {
            function fun(uint a) returns(uint r) { return a; }
            function fun(uint a, uint b) returns(uint r) { return a + b; }
        }'''

    @Ignore
    @Test
    def void overloadedFunctions() {
        OVERLOADED_FUNCTIONS.parse.assertNoErrors
    }

    @Test
    def void functionNatspecDocumentation() {
        '''contract test {
                         uint256 stateVar;
                         /// This is a test function
                         function functionName(bytes32 input) returns (bytes32 out) {}
                       }'''.parse.assertNoErrors
    }

    @Test
    def void functionNormalComments() {
        '''contract test {
                         uint256 stateVar;
                         // We won't see this comment
                         function functionName(bytes32 input) returns (bytes32 out) {}
                       }'''.parse.assertNoErrors
    }

    @Test
    def void multipleFunctionsNatspecDocumentation() {
        '''contract test {
                         uint256 stateVar;
                         /// This is test function 1
                         function functionName1(bytes32 input) returns (bytes32 out) {}
                         /// This is test function 2
                         function functionName2(bytes32 input) returns (bytes32 out) {}
                         // nothing to see here
                         function functionName3(bytes32 input) returns (bytes32 out) {}
                         /// This is test function 4
                         function functionName4(bytes32 input) returns (bytes32 out) {}
                       }'''.parse.assertNoErrors
    }

    @Test
    def void multilineFunctionDocumentation() {
        '''contract test {
                         uint256 stateVar;
                         /// This is a test function
                         /// and it has 2 lines
                         function functionName1(bytes32 input) returns (bytes32 out) {}
                       }'''.parse.assertNoErrors
    }

    val NATSPEC_COMMENT_IN_FUNCTION_BODY = '''contract test {
                         /// fun1 description
                         function fun1(uint256 a) {
                           var b;
                           /// I should not interfere with actual natspec comments
                           uint256 c;
                           mapping(address=>bytes32) d;
                           bytes7 name = "Solidity";
                         }
                         /// This is a test function
                         /// and it has 2 lines
                         function fun(bytes32 input) returns (bytes32 out) {}
                       }'''

    @Ignore
    @Test
    def natspecCommentInFunctionBody() {
        NATSPEC_COMMENT_IN_FUNCTION_BODY.parse.assertNoErrors
    }

    val NATSPEC_DOCSTRING_BETWEEN_KEYWORD_AND_SIGNATURE = '''contract test {
                         uint256 stateVar;
                         function ///I am in the wrong place 
                         fun1(uint256 a) {
                           var b;
                           /// I should not interfere with actual natspec comments
                           uint256 c;
                           mapping(address=>bytes32) d;
                           bytes7 name = "Solidity";
                         }
                       }'''

    @Ignore
    @Test
    def void natspecDocstringBetweenKeywordAndSignature() {
        NATSPEC_DOCSTRING_BETWEEN_KEYWORD_AND_SIGNATURE.parse.assertNoErrors
    }

    val NATSPEC_DOCSTRING_AFTER_SIGNATURE = '''contract test {
                         uint256 stateVar;
                         function fun1(uint256 a) {
                         /// I should have been above the function signature
                           var b;
                           /// I should not interfere with actual natspec comments
                           uint256 c;
                           mapping(address=>bytes32) d;
                           bytes7 name = "Solidity";
                         }
                       }'''

    @Ignore
    @Test
    def void natspecDocstringAfterSignature() {
        NATSPEC_DOCSTRING_AFTER_SIGNATURE.parse.assertNoErrors
    }

    val STRUCT_DEFINITION = '''contract test {
                         uint256 stateVar;
                         struct MyStructName {
                           address addr;
                           uint256 count;
                         }
                       }'''

    @Ignore
    @Test
    def void structDefinition() {
        STRUCT_DEFINITION.parse.assertNoErrors
    }

    @Test
    def void mapping() {
        '''contract test {
                         mapping(address => bytes32) names;
                       }'''.parse.assertNoErrors
    }

    @Test
    def void mappingInStruct() {
        '''contract test {
                         struct test_struct {
                           address addr;
                           uint256 count;
                           mapping(bytes32 => test_struct) self_reference;
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void mappingToMappingInStruct() {
        '''contract test {
                         struct test_struct {
                           address addr;
                           mapping (uint64 => mapping (bytes32 => uint)) complex_mapping;
                         }
                       }'''.parse.assertNoErrors
    }

    val VARIABLE_DEFINITION = '''contract test {
                         function fun(uint256 a) {
                           var b;
                           uint256 c;
                           mapping(address=>bytes32) d;
                           customtype varname;
                         }
                       }'''

    @Ignore
    @Test
    def void variableDefinition() {
        VARIABLE_DEFINITION.parse.assertNoErrors
    }

    @Test
    def void variableDefinitionWithInitialization() {
        '''contract test {
                         function fun(uint256 a) {
                           var b = 2;
                           uint256 c = 0x87;
                           mapping(address=>bytes32) d;
                           bytes7 name = "Solidity";
                           customtype varname;
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void variableDefinitionInFunctionParameter() {
        '''contract test {
            function fun(var a) {}
        }'''.parse.assertNoErrors
    }

    val VARIABLE_DEFINITION_IN_MAPPING = '''contract test {
            function fun() {
                mapping(var=>bytes32) d;
            }
        }'''

    @Ignore
    @Test
    def void variableDefinitionInMapping() {
        VARIABLE_DEFINITION_IN_MAPPING.parse.assertNoErrors
    }

    @Test
    def void variableDefinitionInFunctionReturn() {
        '''contract test {
            function fun() returns(var d) {
                return 1;
            }
        }'''.parse.assertNoErrors
    }

    @Test
    def void operatorExpression() {
        '''contract test {
                         function fun(uint256 a) {
                           uint256 x = (1 + 4) || false && (1 - 12) + -9;
                         }
                       }'''.parse.assertNoErrors
    }

    val COMPLEX_EXPRESSION = '''contract test {
                         function fun(uint256 a) {
                           uint256 x = (1 + 4).member(++67)[a/=9] || true;
                         }
                       }'''

    @Ignore
    @Test
    def void complexExpression() {
        COMPLEX_EXPRESSION.parse.assertNoErrors
    }

    @Test
    def void expExpression() {
        '''contract test {
            function fun(uint256 a) {
                uint256 x = 3 ** a;
            }
        }'''.parse.assertNoErrors
    }

    @Test
    def void whileLoop() {
        '''contract test {
                         function fun(uint256 a) {
                           while (true) { uint256 x = 1; break; continue; } x = 9;
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void forLoopVardefInitexpr() {
        '''contract test {
                         function fun(uint256 a) {
                           for (uint256 i = 0; i < 10; i++)
                           { uint256 x = i; break; continue; }
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void forLoopSimpleInitExpr() {
        '''contract test {
                         function fun(uint256 a) {
                           uint256 i =0;
                           for (i = 0; i < 10; i++)
                           { uint256 x = i; break; continue; }
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void forLoopSimpleNoExpr() {
        '''contract test {
                         function fun(uint256 a) {
                           uint256 i =0;
                           for (;;)
                           { uint256 x = i; break; continue; }
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void forLoopSingleStmtBody() {
        '''contract test {
                         function fun(uint256 a) {
                           uint256 i =0;
                           for (i = 0; i < 10; i++)
                               continue;
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void ifStatement() {
        '''contract test {
                         function fun(uint256 a) {
                           if (a >= 8) return 2; else { var b = 7; }
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void elseIfStatement() {
        '''contract test {
                         function fun(uint256 a) returns (address b) {
                           if (a < 0) b = 0x67; else if (a == 0) b = 0x12; else b = 0x78;
                         }
                       }'''.parse.assertNoErrors
    }

    val STATEMENT_STARTING_WITH_TYPE_CONVERSION = '''contract test {
                         function fun() {
                           uint64(2);
                           uint64[7](3);
                           uint64[](3);
                         }
                       }'''

    @Ignore
    @Test
    def void statementStartingWithTypeConversion() {
        STATEMENT_STARTING_WITH_TYPE_CONVERSION.parse.assertNoErrors
    }

    val TYPE_CONVERSION_TO_DYNAMIC_ARRAY = '''contract test {
                         function fun() {
                           var x = uint64[](3);
                         }
                       }'''

    @Ignore
    @Test
    def void typeConversionToDynamicArray() {
        TYPE_CONVERSION_TO_DYNAMIC_ARRAY.parse.assertNoErrors
    }

    @Test
    def void importDirective() {
        '''import "abc";
                       contract test {
                         function fun() {
                           uint64(2);
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void multipleContracts() {
        '''contract test {
                         function fun() {
                           uint64(2);
                         }
                       }
                       contract test2 {
                         function fun() {
                           uint64(2);
                         }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void multipleContractsAndImports() {
        '''import "abc";
                       contract test {
                         function fun() {
                           uint64(2);
                         }
                       }
                       import "def";
                       contract test2 {
                         function fun() {
                           uint64(2);
                         }
                       }
                       import "ghi";'''.parse.assertNoErrors
    }

    val CONTRACT_INHERITANCE = '''contract base {
                         function fun() {
                           uint64(2);
                         }
                       }
                       contract derived is base {
                         function fun() {
                           uint64(2);
                         }
                       }'''

    @Ignore
    @Test
    def void contractInheritance() {
        CONTRACT_INHERITANCE.parse.assertNoErrors
    }

    val CONTRACT_MULTIPLE_INHERITANCE = '''contract base {
                         function fun() {
                           uint64(2);
                         }
                       }
                       contract derived is base, nonExisting {
                         function fun() {
                           uint64(2);
                         }
                       }'''

    @Ignore
    @Test
    def void contractMultipleInheritance() {
        CONTRACT_MULTIPLE_INHERITANCE.parse.assertNoErrors
    }

    val CONTRACT_MULTIPLE_INHERITANCE_WITH_ARGUMENTS = '''contract base {
                         function fun() {
                           uint64(2);
                         }
                       }
                       contract derived is base(2), nonExisting("abc", "def", base.fun()) {
                         function fun() {
                           uint64(2);
                         }
                       }'''

    @Ignore
    @Test
    def void contractMultipleInheritanceWithArguments() {
        CONTRACT_MULTIPLE_INHERITANCE_WITH_ARGUMENTS.parse.assertNoErrors
    }

    val PLACEHOLDER_IN_FUNCTION_CONTEXT = '''contract c {
                         function fun() returns (uint r) {
                           var _ = 8;
                           return _ + 1;
                         }
                       }'''

    @Ignore
    @Test
    def void placeholderInFunctionContext() {
        PLACEHOLDER_IN_FUNCTION_CONTEXT.parse.assertNoErrors
    }

    @Test
    def void modifier() {
        '''contract c {
                         modifier mod { if (msg.sender == 0) _ }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void modifierArguments() {
        '''contract c {
                         modifier mod(uint a) { if (msg.sender == a) _ }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void modifierInvocation() {
        '''contract c {
                         modifier mod1(uint a) { if (msg.sender == a) _ }
                         modifier mod2 { if (msg.sender == 2) _ }
                         function f() mod1(7) mod2 { }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void fallbackFunction() {
        '''contract c {
                         function() { }
                       }'''.parse.assertNoErrors
    }

    @Test
    def void event() {
        '''contract c {
            event e();
        }'''.parse.assertNoErrors
    }

    @Test
    def void eventArguments() {
        '''contract c {
            event e(uint a, bytes32 s);
        }'''.parse.assertNoErrors
    }

    @Test
    def void eventArgumentsIndexed() {
        '''contract c {
            event e(uint a, bytes32 indexed s, bool indexed b);
        }'''.parse.assertNoErrors
    }

    @Test
    def void visibilitySpecifiers() {
        '''contract c {
            uint private a;
            uint internal b;
            uint public c;
            uint d;
            function f() {}
            function f_priv() private {}
            function f_public() public {}
            function f_internal() internal {}
        }'''.parse.assertNoErrors
    }

    val MULTIPLE_VISIBILITY_SPECIFIERS = '''contract c {
            uint private internal a;
        }'''

    @Ignore
    @Test
    def void multipleVisibilitySpecifiers() {
        MULTIPLE_VISIBILITY_SPECIFIERS.parse.assertNoErrors
    }

    @Test
    def void literalConstantsWithEtherSubdenominations() {
        '''contract c {
            function c ()
            {
                 a = 1 wei;
                 b = 2 szabo;
                 c = 3 finney;
                 b = 4 ether;
            }
            uint256 a;
            uint256 b;
            uint256 c;
            uint256 d;
        }'''.parse.assertNoErrors
    }

    @Test
    def void literalConstantsWithEtherSubdenominationsInExpressions() {
        '''contract c {
            function c ()
            {
                 a = 1 wei * 100 wei + 7 szabo - 3;
            }
            uint256 a;
        }'''.parse.assertNoErrors
    }

    @Test
    def void enumValidDeclaration() {
        '''contract c {
            enum validEnum { Value1, Value2, Value3, Value4 }
        }'''.parse.assertNoErrors
    }

    @Test
    def void emptyEnumDeclaration() {
        '''contract c {
            enum foo { }
        }'''.parse.assertNoErrors
    }

//    val MALFORMED_ENUM_DECLARATION = '''contract c {
//            enum foo { WARNING,}
//        }'''
    // probably should fail DAF
    @Ignore
    @Test
    def void malformedEnumDeclaration() {
        // MALFORMED_ENUM_DECLARATION.parse.assertError
    }

    @Test
    def void externalFunction() {
        '''contract c {
            function x() external {}
        }'''.parse.assertNoErrors
    }

    @Test
    def void externalVariable() {
        '''contract c {
            uint external x;
        }'''.parse.assertNoErrors
    }

    val ARRAYS_IN_STORAGE = '''contract c {
            uint[10] a;
            uint[] a2;
            struct x { uint[2**20] b; y[0] c; }
            struct y { uint d; mapping(uint=>x)[] e; }
        }'''

    @Ignore
    @Test
    def void arraysInStorage() {
        ARRAYS_IN_STORAGE.parse.assertNoErrors
    }

    @Test
    def void arraysInEvents() {
        '''contract c {
            event e(uint[10] a, bytes7[8] indexed b, c[3] x);
        }'''.parse.assertNoErrors
    }

    @Test
    def void arraysInExpressions() {
        '''contract c {
            function f() { c[10] a = 7; uint8[10 * 2] x; }
        }'''.parse.assertNoErrors
    }

    val MULTI_ARRAYS = '''contract c {
            mapping(uint => mapping(uint => int8)[8][][9])[] x;
        }'''

    @Ignore
    @Test
    def void multiArrays() {
        MULTI_ARRAYS.parse.assertNoErrors
    }

    // This fails as it should, need to assert that Failure is correct DAF
    @Ignore
    @Test
    def void constantIsKeyword() {
        '''contract Foo {
            uint constant = 4;
    }'''.parse.assertNoErrors
    }

    val VAR_ARRAY = '''contract Foo {
            function f() { var[] a; }
    }'''

    @Ignore
    @Test
    def void varArray() {
        VAR_ARRAY.parse.assertNoErrors
    }

    @Test
    def void locationSpecifiersForParams() {
        '''contract Foo {
            function f(uint[] storage constant x, uint[] memory y) { }
        }'''.parse.assertNoErrors
    }

    @Test
    def void locationSpecifiersForLocals() {
        '''contract Foo {
            function f() {
                uint[] storage x;
                uint[] memory y;
            }
        }'''.parse.assertNoErrors
    }

    val LOCATION_SPECIFIERS_WITH_VAR = '''contract Foo {
            function f() { var memory x; }
    }'''

    @Ignore
    @Test
    def void locationSpecifiersWithVar() {
        LOCATION_SPECIFIERS_WITH_VAR.parse.assertNoErrors
    }

    @Test
    def void emptyComment() {
        '''//
        contract test
        {}'''.parse.assertNoErrors
    }

    @Test
    def void librarySimple() {
        '''library Lib {
            function f() { }
        }'''.parse.assertNoErrors
    }

    @Test
    def void localConstVariable() {
        '''contract Foo {
            function localConst() returns (uint ret)
            {
                uint constant local = 4;
                return local;
            }
    }'''.parse.assertNoErrors
    }

    val MULTI_VARIABLE_DECLARATION = '''contract C {
            function f() {
                var (a,b,c) = g();
                var (d) = 2;
                var (,e) = 3;
                var (f,) = 4;
                var (x,,) = g();
                var (,y,) = g();
                var () = g();
                var (,,) = g();
            }
            function g() returns (uint, uint, uint) {}
        }'''

    @Ignore
    @Test
    def void multiVariableDeclaration() {
        MULTI_VARIABLE_DECLARATION.parse.assertNoErrors
    }

    @Test
    def void tuples() {
        '''contract C {
            function f() {
                uint a = (1);
                var (b,) = (1,);
                var (c,d) = (1, 2 + a);
                var (e,) = (1, 2, b);
            }
        }'''.parse.assertNoErrors
    }

    val MEMBER_ACCESS_PARSER_AMBIGUITY = '''contract C {
            struct S { uint a; uint b; uint[][][] c; }
            function f() {
                C.S x;
                C.S memory y;
                C.S[10] memory z;
                C.S[10](x);
                x.a = 2;
                x.c[1][2][3] = 9;
            }
        }'''

    @Ignore
    @Test
    def void memberAccessParserAmbiguity() {
        MEMBER_ACCESS_PARSER_AMBIGUITY.parse.assertNoErrors
    }
} // SolidityParseTest