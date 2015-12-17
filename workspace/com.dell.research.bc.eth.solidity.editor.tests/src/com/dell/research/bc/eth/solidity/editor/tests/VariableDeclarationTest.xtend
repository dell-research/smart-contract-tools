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
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Ignore
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class VariableDeclarationTest extends AbsStatementTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper

    // This should fail, as it does. DAF
    @Ignore
    @Test
    def void givenValidVariableDeclarationVarWithoutInitializationInContract_thenNoErrors() {
        '''contract foo {
             var a;
         }'''.parse.assertNoErrors
    }

    @Test
    def void givenValidVariableDeclarationVarWithInitializationInContract_thenNoErrors() {
        '''contract foo {
             var a = 1; 
         }'''.parse.assertNoErrors
    }
    
    // This should fail, as it does. DAF
    @Ignore
    @Test
    def void givenValidVariableDeclarationVarWithoutInitializationInFunction_thenNoErrors() {
        '''contract foo {
             function bar() {
                 var a;
             }
         }'''.parse.assertNoErrors
    }
    
     @Test
    def void givenValidVariableDeclarationVarWithInitializationInFunction_thenNoErrors() {
        '''contract foo {
             function bar() {
                 var a=1;
             }
         }'''.parse.assertNoErrors
    }
} // VariableDeclarationTest

