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
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.InjectWith
import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import org.eclipse.xtext.junit4.XtextRunner
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import org.junit.Test
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage
import com.dell.research.bc.eth.solidity.editor.validation.SolidityValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class CheckNoCycleInContractOrLibraryHierarchyUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    @Test
    def void givenContract_whenExtendsAnotherWithNoCycle_thenNoError() {
        '''
            contract A is B() {}
            contract B() {}
        '''.parse.assertNoError(SolidityValidator::HIERARCHY_CYCLE)
    }

    @Test
    def void givenContract_whenExtendsLibraryWithNoCycle_thenNoError() {
        '''
            contract A is B() {}
            library B() {}
        '''.parse.assertNoError(SolidityValidator::HIERARCHY_CYCLE)
    }

    @Test
    def void givenLibrary_whenExtendsAnotherWithNoCycle_thenNoError() {
        '''
            library A is B() {}
            library B() {}
        '''.parse.assertNoError(SolidityValidator::HIERARCHY_CYCLE)
    }

    @Test
    def void givenContract_whenExtendsItSelf_thenError() {
        '''
            contract A is A() {}
        '''.parse.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )
    }

    @Test
    def void givenLibrary_whenExtendsItSelf_thenError() {
        '''
            library A is A() {}
        '''.parse.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )
    }

    @Test
    def void givenThreeContractsSingleInheritance_whenCycle_thenError() {
        val model = '''
            contract A is B() {}
            contract B is C() {}
            contract C is A() {}
        '''.parse;

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'B'"
        )
        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'C'"
        )
    }

    @Test
    def void givenThreeLibrariesSingleInheritance_whenCycle_thenError() {
        val model = '''
            library A is B() {}
            library B is C() {}
            library C is A() {}
        '''.parse;

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'B'"
        )
        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'C'"
        )
    }

    @Test
    def void givenThreeContractsMultipleInheritance_whenCycle_thenError() {
        val model = '''
            contract A is B(),C() {}
            contract B  {}
            contract C is A() {}
        '''.parse;

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'C'"
        )
    }

    @Test
    def void givenThreeLibrariesMultipleInheritance_whenCycle_thenError() {
        val model = '''
            library A is B(),C() {}
            library B  {}
            library C is A() {}
        '''.parse;

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'A'"
        )

        model.assertError(
            SolidityPackage::eINSTANCE.contractOrLibrary,
            SolidityValidator::HIERARCHY_CYCLE,
            "cycle in hierarchy of Contract/Library 'C'"
        )
    }
} // CheckNoCycleInContractOrLibraryHierarchyUnitTest