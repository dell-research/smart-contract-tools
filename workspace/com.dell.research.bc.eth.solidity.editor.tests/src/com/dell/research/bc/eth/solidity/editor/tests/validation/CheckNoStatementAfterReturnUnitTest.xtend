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
package com.dell.research.bc.eth.solidity.editor.tests.validation

import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage
import com.dell.research.bc.eth.solidity.editor.validation.SolidityValidator
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class CheckNoStatementAfterReturnUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    @Test
    def void givenFunction_whenNoCodeAfterReturn_thenNoError() {
        '''
            contract A {
                function foo() {
                    var a = 1;
                    return;
                }
            }
        '''.parse.assertNoError(SolidityValidator::UNREACHABE_CODE)
    }

    @Test
    def void givenIfStatement_whenNonBlockElse__thenNoError() {
        '''contract A {
               function foo(uint256 a) {
                   if (a >= 8) return 2; else { var b = 7; }
               }
           }'''.parse.assertNoError(SolidityValidator::UNREACHABE_CODE)
    }

    @Test
    def void givenFunction_whenCodeAfterReturn_thenError() {
        '''
            contract A {
                function foo() {
                    var a = 1;
                    return;
                    var b =2;
                }
            }
        '''.parse.assertError(SolidityPackage::eINSTANCE.varVariableTypeDeclaration, SolidityValidator::UNREACHABE_CODE,
            "Unreachable code")
    }

} // CheckNoStatementAfterReturnUnitTest