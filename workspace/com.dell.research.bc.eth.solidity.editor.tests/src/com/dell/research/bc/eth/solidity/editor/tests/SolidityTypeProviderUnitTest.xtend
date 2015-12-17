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

import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import com.dell.research.bc.eth.solidity.editor.SolidityTypeProvider
import com.dell.research.bc.eth.solidity.editor.solidity.ExpressionStatement
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.solidity.Statement
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class SolidityTypeProviderUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper
    @Inject extension SolidityTypeProvider

    def private assertType(CharSequence testExp, String expectedClassName) {
        '''
            contract R { V v;}
            contract P is R() { function m() { return; }}
            contract V is R() { N n;}
            contract N is R() {}
            contract F is R() {}
            contract C is R() {
                F f;
                function m(P p) {
                    V v;
                    «testExp»;
                    return;
                }
            }
        '''.parse =>
            [
                assertNoErrors
                expectedClassName.assertEquals(
                    contract.last.body.functions.last.block.statements.get(1).statementExpressionType.name)
            ]
    } // assertType

    def private statementExpressionType(Statement s) {
        (s as ExpressionStatement).expression.typeFor
    }
    
    @Test def void newType() { "new N".assertType("N") }

    @Test def void booleanConstTrueType() { "true".assertType("booleanType") }

    @Test def void booleanConstFalseType() { "false".assertType("booleanType") }

    @Test def void orType() { "false || true".assertType("booleanType") }

    @Test def void andType() { "false && true".assertType("booleanType") }

    @Test def void qualityType() { "false == true".assertType("booleanType") }

    @Test def void comparisonType() { "1 > 2".assertType("booleanType") }

    @Test def void stringType() { '"foo"'.assertType("stringType") }

    @Test def void numberType() { "1".assertType("numberDimensionlessType") }

    @Test def void etherType() { "1 ether".assertType("etherType") }
    
    @Test def void timeType() { "1 seconds".assertType("timeType") }
} // SolidityTypeProviderUnitTest