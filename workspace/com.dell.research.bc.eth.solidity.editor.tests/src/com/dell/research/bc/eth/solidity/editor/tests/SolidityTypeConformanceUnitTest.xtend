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
import com.dell.research.bc.eth.solidity.editor.SolidityTypeConformance
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class SolidityTypeConformanceUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension SolidityTypeConformance

    @Test
    def void testClassConformance() {
        '''
            contract A {}
            contract B is A() {}
            contract C {}
        '''.parse.contract => [
            // A sub-contract of A
            get(0).isConformant(get(0)).assertTrue
            // B sub-contract of A
            get(1).isConformant(get(0)).assertTrue
            // C not sub-contract of A
            get(2).isConformant(get(0)).assertFalse
        ]
    } // testClassConformance
} // SolidityTypeConformanceUnitTest