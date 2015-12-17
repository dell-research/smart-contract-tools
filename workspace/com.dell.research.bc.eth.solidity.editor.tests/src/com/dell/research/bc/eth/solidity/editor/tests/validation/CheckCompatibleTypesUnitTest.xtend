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
import org.eclipse.emf.ecore.EClass
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class CheckCompatibleTypesUnitTest extends AbsSolidityValidatorUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper;

    def void assertIncompatibleTypes(CharSequence functionBody, EClass c, String expectedType, String actualType) {
        '''
            contract F {}
            contract R {}
            contract P {}
            contract P1 {}
            contract P2 {}
            contract V {}
            contract C {
                F f;
                function m(P p) {
                    «functionBody»
                }
                function n(P1 p1, P2 p2) returns (R) { return; }
            }
        '''.parse.assertError(
            c,
            SolidityValidator::INCOMPATIBLE_TYPES,
            "Incompatible types. Expected '" + expectedType + "' but was '" + actualType + "'"
        )
    } // assertIncompatibleTypes

    @Ignore
    @Test
    def void assertVariableDeclExpIncompatibleTypes() {
        "V v = new P;".assertIncompatibleTypes(SolidityPackage::eINSTANCE.newExpression, "V", "P")
    } // assertVariableDeclExpIncompatibleTypes
} // CheckCompatibleTypesUnitTest