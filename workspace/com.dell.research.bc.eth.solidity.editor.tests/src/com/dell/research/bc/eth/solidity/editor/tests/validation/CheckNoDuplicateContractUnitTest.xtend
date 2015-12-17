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
class CheckNoDuplicateContractUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    @Test
    def void givenTwoContracts_whenDifferentNames_thenNoError() {
        '''
            contract A {}
            contract B {}
        '''.parse.assertNoError(SolidityValidator::DUPLICATE_ELEMENT)
    }

    @Test
    def void givenTwoContracts_whenHaveSameName_thenError() {
        '''
            contract A {}
            contract A {}
        '''.parse.assertError(SolidityPackage::eINSTANCE.contractOrLibrary, SolidityValidator::DUPLICATE_ELEMENT,
            "Duplicate contract 'A'")
    }

} // CheckNoDuplicateContract