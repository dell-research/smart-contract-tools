/*******************************************************************************
 * Copyright (c) 2015 Dell Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Daniel Ford, Dell Corporation - initial API and implementation
 *******************************************************************************/
package com.dell.research.bc.eth.solidity.editor.tests

import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.solidity.VarVariableTypeDeclaration
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Ignore
import org.junit.Test

import static extension org.junit.Assert.*

class ExpressionTest extends AbsExpressionTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper

    // Assignment
    // --------------------------------------------------------------------
    @Test
    def void testAssignment() {
        '''a = b'''.assertRepr("(a = b)")
    }

    @Test
    def void testAssignment_IntegerLiteral() {
        '''a = 1'''.assertRepr("(a = 1)")
    }

    @Test
    def void testAssignmentOr() {
        '''a |= b'''.assertRepr("(a |= b)")
    }

    @Test
    def void testAssignmentXor() {
        '''a ^= b'''.assertRepr("(a ^= b)")
    }

    @Test
    def void testAssignmentAnd() {
        '''a &= b'''.assertRepr("(a &= b)")
    }

    @Test
    def void testAssignmentShiftLeft() {
        '''a <<= b'''.assertRepr("(a <<= b)")
    }

    @Test
    def void testAssignmentShiftRight() {
        '''a >>= b'''.assertRepr("(a >>= b)")
    }

    @Test
    def void testAssignmentArithmeticShiftRight() {
        '''a >>>= b'''.assertRepr("(a >>>= b)")
    }

    @Test
    def void testAssignmentAdd() {
        '''a += b'''.assertRepr("(a += b)")
    }

    @Test
    def void testAssignmentSub() {
        '''a -= b'''.assertRepr("(a -= b)")
    }

    @Test
    def void testAssignmentMult() {
        '''a *= b'''.assertRepr("(a *= b)")
    }

    @Test
    def void testAssignmentDiv() {
        '''a /= b'''.assertRepr("(a /= b)")
    }

    @Test
    def void testAssignmentMod() {
        '''a %= b'''.assertRepr("(a %= b)")
    }

    // Or
    // --------------------------------------------------------------------
    @Test
    def void testOrAssociativity() {
        '''true || false || true'''.assertRepr("((true || false) || true)")
    }

    @Test
    def void testOrWithParenthesis() {
        '''(true || false) || (false || false)'''.assertRepr("((true || false) || (false || false))")
    }

    // And
    // --------------------------------------------------------------------
    @Test
    def void testAnd() {
        '''true && false'''.assertRepr("(true && false)")
    }

    @Test
    def void testAndAssociativity() {
        '''true && false && true'''.assertRepr("((true && false) && true)")
    }

    @Test
    def void testAndWithParenthesis() {
        '''(true && false) && (false && false)'''.assertRepr("((true && false) && (false && false))")
    }

    @Test
    def void testAndOrAssocitivity() {
        '''true||false&&false||true'''.assertRepr("((true || (false && false)) || true)")
    }

    // Equality
    // --------------------------------------------------------------------
    @Test
    def void testEquality() {
        '''1 == 1'''.assertRepr("(1 == 1)")
    }

    @Test
    def void testInequality() {
        '''1 != 1'''.assertRepr("(1 != 1)")
    }

    // Check the grammar for this one.  DAF
    @Test
    def void testEqualityAssociativity() {
        '''1 == 1 == 2'''.assertRepr("((1 == 1) == 2)")
    }

    // Comparison
    // --------------------------------------------------------------------
    @Test
    def void testComparisonLessThan() {
        '''1 < 1'''.assertRepr("(1 < 1)")
    }

    @Test
    def void testComparisonGreaterThan() {
        '''1 > 1'''.assertRepr("(1 > 1)")
    }

    @Test
    def void testComparisonLessEqual() {
        '''1 <= 1'''.assertRepr("(1 <= 1)")
    }

    @Test
    def void testComparisonGreaterEqual() {
        '''1 >= 1'''.assertRepr("(1 >= 1)")
    }

    @Test
    def void testComparisonIn() {
        '''1 in 1'''.assertRepr("(1 in 1)")
    }

    // This test passes incorrectly DAF
    @Ignore
    @Test
    def void testComparisonAssociativity() {
        '''1 > 1 < 2'''.assertRepr("((1 > 1) < 2)")
    }

    // BitOr
    // --------------------------------------------------------------------
    @Test
    def void testBitOr() {
        '''1 | 1'''.assertRepr("(1 | 1)")
    }

    // BitXor
    // --------------------------------------------------------------------
    @Test
    def void testBitXor() {
        '''1 ^ 1'''.assertRepr("(1 ^ 1)")
    }

    // BitAnd
    // --------------------------------------------------------------------
    @Test
    def void testBitAnd() {
        '''1 & 1'''.assertRepr("(1 & 1)")
    }

    // Shift
    // --------------------------------------------------------------------
    @Test
    def void testShiftLeft() {
        '''1 << 1'''.assertRepr("(1 << 1)")
    }

    @Test
    def void testShiftRight() {
        '''1 >> 1'''.assertRepr("(1 >> 1)")
    }

    // Is this really Arithmetic shift? DAF
    @Test
    def void testArithmeticShiftRight() {
        '''1 >>> 1'''.assertRepr("(1 >>> 1)")
    }

    // Add
    // --------------------------------------------------------------------
    @Test
    def void testAddAssociativity() {
        '''10 + 5 + 1 + 2'''.assertRepr("(((10 + 5) + 1) + 2)")
    }

    @Test
    def void testAddWithParenthesis() {
        '''(10 + 5) + (1 + 2)'''.assertRepr("((10 + 5) + (1 + 2))")
    }

    // Sub
    // --------------------------------------------------------------------
    @Test
    def void testSubAssociativity() {
        '''10 - 5 - 1 - 2'''.assertRepr("(((10 - 5) - 1) - 2)")
    }

    @Test
    def void testSubWithParenthesis() {
        '''(10 - 5) - (1 - 2)'''.assertRepr("((10 - 5) - (1 - 2))")
    }

    // Mult
    // --------------------------------------------------------------------
    @Test
    def void testMultAssociativity() {
        '''10 * 5 * 1 * 2'''.assertRepr("(((10 * 5) * 1) * 2)")
    }

    @Test
    def void testMultWithParenthesis() {
        '''(10 * 5) * (1 * 2)'''.assertRepr("((10 * 5) * (1 * 2))")
    }

    // Div
    // --------------------------------------------------------------------
    @Test
    def void testDivAssociativity() {
        '''10 / 5 / 1 / 2'''.assertRepr("(((10 / 5) / 1) / 2)")
    }

    @Test
    def void testDivWithParenthesis() {
        '''(10 / 5) / (1 / 2)'''.assertRepr("((10 / 5) / (1 / 2))")
    }

    // Exponent
    // --------------------------------------------------------------------
    @Test
    def void testExponentAssociativity() {
        '''10 ** 5 ** 1 ** 2'''.assertRepr("(((10 ** 5) ** 1) ** 2)")
    }

    @Test
    def void testExponentWithParenthesis() {
        '''(10 ** 5) ** (1 ** 2)'''.assertRepr("((10 ** 5) ** (1 ** 2))")
    }

    // Not
    // --------------------------------------------------------------------
    @Test
    def void testNot() {
        '''!true'''.assertRepr("(!true)")
    }

    @Test
    def void testNotAssociativity() {
        '''!!true'''.assertRepr("(!(!true))")
    }

    // PreIncDec
    // --------------------------------------------------------------------
    @Test
    def void testPreInc() {
        '''++1'''.assertRepr("(++1)")
    }

    @Test
    def void testPreDec() {
        '''--1'''.assertRepr("(--1)")
    }

    // BinaryNot
    // --------------------------------------------------------------------
    @Test
    def void testBinaryNot() {
        '''~1'''.assertRepr("(~1)")
    }

    @Test
    def void testBinaryNotAssociativity() {
        '''~~1'''.assertRepr("(~(~1))")
    }

    // Sign
    // --------------------------------------------------------------------
    @Test
    def void testPlusSign() {
        '''+1'''.assertRepr("(+1)")
    }

    @Test
    def void testPlusSignAssociativity() {
        '''+ +1'''.assertRepr("(+(+1))")
    }

    @Test
    def void testMinusSign() {
        '''-1'''.assertRepr("(-1)")
    }

    @Test
    def void testMinusSignAssociativity() {
        '''- -1'''.assertRepr("(-(-1))")
    }

    @Test
    def void testPlusMinusSignAssociativity() {
        '''+-1'''.assertRepr("(+(-1))")
    }

    @Test
    def void testMinusPlusSignAssociativity() {
        '''-+1'''.assertRepr("(-(+1))")
    }

    // PostIncDec
    // --------------------------------------------------------------------
    @Test
    def void testPostInc() {
        '''a++'''.assertRepr("(a++)")
    }

    @Test
    def void testPostDec() {
        '''a--'''.assertRepr("(a--)")
    }

    // BooleanConstant
    // --------------------------------------------------------------------
    @Test
    def void testBooleanConstTrue() {
        '''true'''.assertRepr("true")
    }

    @Test
    def void testBooleanConstFalse() {
        '''false'''.assertRepr("false")
    }

    // EtherSubDenomination
    // --------------------------------------------------------------------
    @Test
    def void testEtherSubDenominationConstWei() {
        '''1 wei'''.assertRepr("1 wei")
    }

    @Test
    def void testEtherSubDenominationConstSzabo() {
        '''1 szabo'''.assertRepr("1 szabo")
    }

    @Test
    def void testEtherSubDenominationConstFinney() {
        '''1 finney'''.assertRepr("1 finney")
    }

    @Test
    def void testEtherSubDenominationConstEther() {
        '''1 ether'''.assertRepr("1 ether")
    }

    // TimeSubdenomination
    // --------------------------------------------------------------------
    @Test
    def void testTimeSubdenominationConstSeconds() {
        '''1 seconds'''.assertRepr("1 seconds")
    }

    @Test
    def void testTimeSubdenominationConstMinutes() {
        '''1 minutes'''.assertRepr("1 minutes")
    }

    @Test
    def void testTimeSubdenominationConstHours() {
        '''1 hours'''.assertRepr("1 hours")
    }

    @Test
    def void testTimeSubdenominationConstDays() {
        '''1 days'''.assertRepr("1 days")
    }

    @Test
    def void testTimeSubdenominationConstWeeks() {
        '''1 weeks'''.assertRepr("1 weeks")
    }

    @Test
    def void testTimeSubdenominationConstYears() {
        '''1 years'''.assertRepr("1 years")
    }

    // NumberConst
    // --------------------------------------------------------------------
    @Test
    def void testNumberConst() {
        '''1'''.assertRepr("1")
    }
    
    // StringLiteral
    // --------------------------------------------------------------------
    @Test
    def void testStringLiteral() {
        '''"foobar"'''.assertRepr("foobar")
    }

    // IdentifierRef
    // --------------------------------------------------------------------
//    @Test
//    def void testIdentifierRef() {
//        '''someidentifier'''.assertRepr("someidentifier")
//    }
    // Incomplete DAF
    // ElementaryTypeExpression
    // --------------------------------------------------------------------
    @Ignore
    @Test
    def void testElementaryTypeExpressionInt() {
        '''int'''.assertRepr("int")
    }

    // Parenthesis
    // --------------------------------------------------------------------
    @Test
    def void testParenthesis1() {
        '''(1)'''.assertRepr("1")
    }

    @Test
    def void testParenthesis2() {
        '''((2))'''.assertRepr("2")
    }

    // Precedence
    // --------------------------------------------------------------------
    @Test
    def void testPrecedenceArithmeticOnly() {
        '''1+2-3*4/5%6**7'''.assertRepr("((1 + 2) - (((3 * 4) / 5) % (6 ** 7)))")
    }

    @Test
    def void testPrecedenceBooleanComparison() {
        '''a > b || c < d && true'''.assertRepr("((a > b) || ((c < d) && true))")
    }

    @Test
    def void testPrecedenceBooleanComparison2() {
        '''false || a > b || c < d && true'''.assertRepr("((false || (a > b)) || ((c < d) && true))")
    }

    @Test
    def void testPrecedenceArithmeticComparison() {
        '''1+2 > 3 || 5 <= 6 '''.assertRepr("(((1 + 2) > 3) || (5 <= 6))")
    }

//-----------------------------------------------------------------------   
    def assertRepr(CharSequence input, CharSequence expected) {
        embedExpression(input).parse => [
            assertNoErrors;
            expected.assertEquals(
                (extractParsedStatement as VarVariableTypeDeclaration).expression.stringRepr
            )
        ]
    }

//    def assertReprNoValidation(CharSequence input, CharSequence expected) {
//        embedExpression(input).parse => [
//            expected.assertEquals(
//                extractParsedExpression.stringRepr
//            )
//        ]
//    }

    def embedExpression(CharSequence sequence) {
        embedStatement('''var z = «sequence»''')
    }

//    def extractParsedExpression(Solidity s) {
//        s.extractParsedStatement.expression
//    }

} // ExpressionTest

