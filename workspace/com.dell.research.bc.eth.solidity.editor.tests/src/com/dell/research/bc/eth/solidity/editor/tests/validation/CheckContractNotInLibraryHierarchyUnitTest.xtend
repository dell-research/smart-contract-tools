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
class CheckContractNotInLibraryHierarchyUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    @Test
    def void givenLibrary_whenDirectlyExtendsLibrary_thenNoError() {
        '''
            library A is B() {}
            library B {}
        '''.parse.assertNoError(SolidityValidator::CONTRACT_IN_HIERARCHY)
    }

    @Test
    def void givenLibrary_whenDirectlyExtendsContract_thenError() {
        '''
            library A is B() {}
            contract B {}
        '''.parse.assertError(
            SolidityPackage::eINSTANCE.library,
            SolidityValidator::CONTRACT_IN_HIERARCHY,
            "Contract 'B' in hierarchy of Library 'A'"
        )
    }

    @Test
    def void givenLibrary_whenIndirectlyExtendsContract_thenError() {
        '''
            library A is B() {}
            library B is C() {}
            contract C {}
        '''.parse.assertError(
            SolidityPackage::eINSTANCE.library,
            SolidityValidator::CONTRACT_IN_HIERARCHY,
            "Contract 'C' in hierarchy of Library 'A'"
        )
    }

    @Test
    def void givenLibrary_whenIndirectlyExtendsContractWithMultipleInheritance_thenError() {
        '''
            library A is B(), C {}
            library B {}
            library C is D() {}
            contract D {}
        '''.parse.assertError(
            SolidityPackage::eINSTANCE.library,
            SolidityValidator::CONTRACT_IN_HIERARCHY,
            "Contract 'D' in hierarchy of Library 'A'"
        )
    }

} // CheckContractNotInLibraryHierarchy