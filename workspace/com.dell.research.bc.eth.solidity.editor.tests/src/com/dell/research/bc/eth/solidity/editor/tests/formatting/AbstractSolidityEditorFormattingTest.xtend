package com.dell.research.bc.eth.solidity.editor.tests.formatting

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

import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.tests.AbsStatementTest
import com.google.inject.Inject
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource

import static extension org.junit.Assert.*

abstract class AbstractSolidityEditorFormattingTest extends AbsStatementTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension INodeModelFormatter;

    def void assertFormattedAs(CharSequence input, CharSequence expected) {
        // This doesn't quite do what's needed.  We want to embed a statement,
        // parse and format it and then extract it to see if its correct. DAF
        val flap = extractParsedStatement(embedStatement(input).parse) // 
        val zip = flap.eResource
        val foo = (zip as XtextResource);
        val bar = foo.parseResult
        val rn = bar.rootNode
        val f = rn.format(0, input.length)
        val ft = f.formattedText

        expected.toString.assertEquals(ft)

//        expected.toString.assertEquals(
//            (input.parse.eResource as XtextResource).parseResult.rootNode.format(0, input.length).formattedText)
    }
} // AbstractSolidityEditorFormattingTest
