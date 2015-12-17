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

import com.dell.research.bc.eth.solidity.editor.tests.validation.AbsSolidityValidatorUnitTest
import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.validation.SolidityValidator
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class CheckNoDuplicateLibraryOrContractVariablesUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    @Test
    def void givenTwoStandardVariables_whenDifferentNames_thenNoError() {
        '''
            library A {
                int a;
                int b;
            }
        '''.parse.assertNoError(SolidityValidator::DUPLICATE_ELEMENT)
    }

    @Test
    def void givenTwoVarVariables_whenDifferentNames_thenNoError() {
        '''
            library A {
                var a;
                var b;
            }
        '''.parse.assertNoError(SolidityValidator::DUPLICATE_ELEMENT)
    }

    @Test
    def void givenVarVariableAndStandardVariable_whenDifferentNames_thenError() {
        '''
            library A {
                var a;
                int b;
             }
        '''.parse.assertNoError(SolidityValidator::DUPLICATE_ELEMENT)
    }

    @Test
    def void givenTwoStandardVariables_whenHaveSameName_thenError() {
        '''
            library A {
                int a;
                int a;
             }
        '''.parse.assertError(SolidityPackage::eINSTANCE.standardVariableDeclaration,
            SolidityValidator::DUPLICATE_ELEMENT, "Duplicate Variable 'a'")
    }

    @Test
    def void givenTwoVarVariables_whenHaveSameName_thenError() {
        '''
            library A {
                var a;
                var a;
             }
        '''.parse.assertError(SolidityPackage::eINSTANCE.varVariableDeclaration, SolidityValidator::DUPLICATE_ELEMENT,
            "Duplicate Variable 'a'")
    }

    @Test
    def void givenVarVariableAndStandardVariable_whenHaveSameName_thenError() {
        val solidity = 
        '''
            library A {
                var a;
                int a;
             }
        '''.parse
        
        solidity.assertError(SolidityPackage::eINSTANCE.standardVariableDeclaration, SolidityValidator::DUPLICATE_ELEMENT,
            "Duplicate Variable 'a'")
        
        solidity.assertError(SolidityPackage::eINSTANCE.varVariableDeclaration, SolidityValidator::DUPLICATE_ELEMENT,
            "Duplicate Variable 'a'")
    }
} // CheckNoDuplicateVariablesUnitTest