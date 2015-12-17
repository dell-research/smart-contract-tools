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
package com.dell.research.bc.eth.solidity.editor

import org.eclipse.xtext.parser.antlr.SyntaxErrorMessageProvider
import com.google.inject.Inject
import org.eclipse.xtext.IGrammarAccess
import org.eclipse.xtext.GrammarUtil
import org.eclipse.xtext.nodemodel.SyntaxErrorMessage

class SoliditySyntaxErrorMessageProvider extends SyntaxErrorMessageProvider {

    public static val String USED_RESERVED_KEYWORD = "USED_RESERVED_KEYWORD"

    @Inject IGrammarAccess grammarAccess

    override getSyntaxErrorMessage(IParserErrorContext context) {
        val unexpectedText = context?.recognitionException?.token?.text
        if (GrammarUtil::getAllKeywords(grammarAccess.getGrammar()).contains(unexpectedText) &&
            unexpectedText.isAlpha) {
            return new SyntaxErrorMessage(
                '''"«unexpectedText»" is a reserved keyword, an Identifier was expected.''',
                USED_RESERVED_KEYWORD
            )
        }
        super.getSyntaxErrorMessage(context)
    } // getSyntaxErrorMessage

    def boolean isAlpha(String text) {
        return text.matches("[A-Za-z]+");
    }
} // SoliditySyntaxErrorMessageProvider