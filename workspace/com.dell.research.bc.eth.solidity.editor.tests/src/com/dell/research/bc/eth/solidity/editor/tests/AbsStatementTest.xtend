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
import com.dell.research.bc.eth.solidity.editor.solidity.BinaryNotExpression
import com.dell.research.bc.eth.solidity.editor.solidity.Block
import com.dell.research.bc.eth.solidity.editor.solidity.BooleanConst
import com.dell.research.bc.eth.solidity.editor.solidity.Ether
import com.dell.research.bc.eth.solidity.editor.solidity.Expression
import com.dell.research.bc.eth.solidity.editor.solidity.NotExpression
import com.dell.research.bc.eth.solidity.editor.solidity.NumberDimensionless
import com.dell.research.bc.eth.solidity.editor.solidity.PostIncDecExpression
import com.dell.research.bc.eth.solidity.editor.solidity.QualifiedIdentifier
import com.dell.research.bc.eth.solidity.editor.solidity.SignExpression
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.solidity.Statement
import com.dell.research.bc.eth.solidity.editor.solidity.StringLiteral
import com.dell.research.bc.eth.solidity.editor.solidity.Time
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import com.dell.research.bc.eth.solidity.editor.solidity.PreIncExpression
import com.dell.research.bc.eth.solidity.editor.solidity.PreDecExpression
import com.dell.research.bc.eth.solidity.editor.solidity.And
import com.dell.research.bc.eth.solidity.editor.solidity.Or
import com.dell.research.bc.eth.solidity.editor.solidity.Equality
import com.dell.research.bc.eth.solidity.editor.solidity.Comparison
import com.dell.research.bc.eth.solidity.editor.solidity.BitOr
import com.dell.research.bc.eth.solidity.editor.solidity.BitXor
import com.dell.research.bc.eth.solidity.editor.solidity.BitAnd
import com.dell.research.bc.eth.solidity.editor.solidity.AddSub
import com.dell.research.bc.eth.solidity.editor.solidity.Shift
import com.dell.research.bc.eth.solidity.editor.solidity.Exponent
import com.dell.research.bc.eth.solidity.editor.solidity.MulDivMod
import com.dell.research.bc.eth.solidity.editor.solidity.Assignment

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
abstract class AbsStatementTest extends AbsSolidityUnitTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper

    def embedStatement(CharSequence sequence) {
        '''contract foo { function bar() { var a = 1; var b = 2; var c = 3; var d = 4; «sequence»;}}'''
    }

    def extractParsedStatement(Solidity s) {
        var Block b = s.contract.last.body.functions.last.block
        b.statements.last
    }

    def assertReprStmt(CharSequence input, CharSequence expected) {
        embedStatement(input).parse => [
            assertNoErrors;
//            val stmt = extractParsedStatement
            expected.assertEquals(
                extractParsedStatement.stringRepr
            )
        ]
    }

    def CharSequence stringRepr(Statement s) {
//        switch (s) {
//            Assignment2: '''(«s.left» «s.op» «s.expression.stringRepr»)'''
//            StandardVariableDeclaration: {
//                var CharSequence temp = s.type.stringRepr
//                if (s.variable != null)
//                    temp = temp + ''' «s.variable»'''
//                if (s.expression != null)
//                    temp = temp + ''' = «s.expression.stringRepr»'''
//            }
//            ElementaryType: '''«s.name»'''
//        }.toString // switch
    } // stringRepr

//    def CharSequence stringRepr(VariableDeclaration2 vd) {
//        '''(«vd.typeRef» «vd.variable» = «vd.expression.stringRepr»)'''
//    } // stringRepr
    // Create a consistent string representation of each type of expression 
    // that can be used to check against the correct/expected values.
    // See: assertRepr
    def CharSequence stringRepr(Expression e) {
        switch (e) {
            Assignment: '''(«e.left.stringRepr» «e.assignmentOp» «e.expression.stringRepr»)'''
            Or: '''(«e.left.stringRepr» || «e.right.stringRepr»)'''
            And: '''(«e.left.stringRepr» && «e.right.stringRepr»)'''
            Equality: '''(«e.left.stringRepr» «e.equalityOp» «e.right.stringRepr»)'''
            Comparison: '''(«e.left.stringRepr» «e.comparisonOp» «e.right.stringRepr»)'''
            BitOr: '''(«e.left.stringRepr» | «e.right.stringRepr»)'''
            BitXor: '''(«e.left.stringRepr» ^ «e.right.stringRepr»)'''
            BitAnd: '''(«e.left.stringRepr» & «e.right.stringRepr»)'''
            Shift: '''(«e.left.stringRepr» «e.shiftOp» «e.right.stringRepr»)'''
            AddSub: '''(«e.left.stringRepr» «e.additionOp» «e.right.stringRepr»)'''
            MulDivMod: '''(«e.left.stringRepr» «e.multipliciativeOp» «e.right.stringRepr»)'''
            Exponent: '''(«e.left.stringRepr» ** «e.right.stringRepr»)'''
            NotExpression: '''(!«e.expression.stringRepr»)'''
            PreIncExpression: '''(++«e.expression.stringRepr»)'''
            PreDecExpression: '''(--«e.expression.stringRepr»)'''
            PostIncDecExpression: '''(«e.expression.stringRepr»«e.postOp»)'''
            BinaryNotExpression: '''(~«e.expression.stringRepr»)'''
            SignExpression: '''(«e.signOp»«e.expression.stringRepr»)'''
            // NewExpression: '''(new «e.contract.stringRepr»)'''
            BooleanConst: '''«e.value»'''
            NumberDimensionless: '''«e.value»'''
            Ether: '''«e.value» «e.ether»'''
            Time: '''«e.value» «e.time»'''
//            Tuple: {
//                var CharSequence temp = "("
//
//                for (TupleMember tm : e.members)
//                    temp = temp + '''«tm.stringRepr»'''
//                temp + ")"
//            }
            StringLiteral: '''«e.value»'''
            QualifiedIdentifier: '''«e.identifier»'''
//            ElementaryTypeExpression: '''«e.value»'''
        }.toString
    } // stringRepr

} // StatementTest

