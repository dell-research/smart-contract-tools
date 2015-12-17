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
package com.dell.research.bc.eth.solidity.editor.formatting

import com.dell.research.bc.eth.solidity.editor.services.SolidityGrammarAccess
import com.google.inject.Inject
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import org.eclipse.xtext.util.Pair

/**
 * This class contains custom formatting declarations.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#formatting
 * on how and when to use it.
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
class SolidityFormatter extends AbstractDeclarativeFormatter {

    @Inject extension SolidityGrammarAccess g

    override protected void configureFormatting(FormattingConfig c) {

        c.setAutoLinewrap(120);

        // Preserve newlines around comments
        c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
        c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
        c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)

        // No space before ";"
        // Min 1, Max: 2, newlines after ";"
        for (Keyword semicolon : g.findKeywords(";")) {
            c.setNoSpace().before(semicolon)
            c.setLinewrap(1, 2, 2).after(semicolon)
        }

        // No space before ","
        for (Keyword comma : g.findKeywords(",")) {
            c.setNoSpace().before(comma)
        }

//        // No space before "?"
//        for (Keyword questionMark : g.findKeywords("?")) {
//            c.setNoSpace().before(questionMark)
//        }
        // No space before "."
        // No space after "."
        for (Keyword period : g.findKeywords(".")) {
            c.setNoSpace().before(period)
            c.setNoSpace().after(period)
        }

        // Paired "(" and ")"
        // No space after ( or before )
        for (Pair<Keyword,Keyword> pair : g.findKeywordPairs("(", ")")) {
            c.setNoSpace().after(pair.getFirst());
            c.setNoSpace().before(pair.getSecond());
        }

        // Paired "{" and "}"
        // Newline after { and before }
        for (Pair<Keyword,Keyword> pair : g.findKeywordPairs("{", "}")) {
            c.setLinewrap().after(pair.getFirst());
            c.setLinewrap().before(pair.getSecond());
            c.setLinewrap().after(pair.getSecond());
        }

        // Paired "[" and "]"
        // Space after [ and before ]
        for (Pair<Keyword,Keyword> pair : g.findKeywordPairs("[", "]")) {
            c.setSpace(" ").after(pair.getFirst());
            c.setSpace(" ").before(pair.getSecond());
        }

        // ContractDefintiion
        // ----------------------------------------------------
        val cd = g.contractAccess

        // Min:1, Max:2 , Newline before use
        c.setLinewrap(0, 2, 2).before(cd.contractKeyword_0)

        // LibraryDefinition
        // ----------------------------------------------------
        val ld = g.libraryAccess

        // Min:1, Max:2 , Newline before "library"
        c.setLinewrap(1, 2, 2).before(ld.libraryKeyword_0)

        // DefinitionBody
        // ----------------------------------------------------
        val db = g.definitionBodyAccess

        // Indent definitionBody
        c.setIndentation(db.leftCurlyBracketKeyword_1, db.rightCurlyBracketKeyword_3)

        // Struct
        // ----------------------------------------------------
        val sd = g.structDefinitionAccess
        // Min:1, Max:2 , Newline before "struct"
        c.setLinewrap(1,2,2).after(sd.structKeyword_0)
        c.setIndentation(sd.leftCurlyBracketKeyword_2, sd.rightCurlyBracketKeyword_4)
        // One space between "struct" and name
        c.setSpace(" ").between(sd.structKeyword_0, sd.nameAssignment_1);

        // FunctionDefinition
        // ----------------------------------------------------
        val fd = g.functionDefinitionAccess

        // Min:1, Max:2 , Newline before "function"
        c.setLinewrap(1,2,2).before(fd.functionKeyword_0)
        // One space between "function" and name
        c.setSpace(" ").between(fd.functionDefinitionAction_1, fd.nameAssignment_2);

        // No space between name and "("
        // c.setNoSpace().between(fd.nameAssignment_2,fd.leftParenthesisKeyword_3);
        // Newline after ";"
        // c.setLinewrap(2, 2, 2).after(fd.semicolonKeyword_8_1)
        // Modifier
        // ----------------------------------------------------
        // val md = g.modifierAccess
        // ModifierInvocation
        // ----------------------------------------------------
        val mi = g.modifierInvocationAccess

        // No space after modifier name
        c.setNoSpace().after(mi.nameAssignment_0)

        // ReturnParameterList
        // ----------------------------------------------------
        // val rpl = g.returnParameterListAccess
        // StructDefinition
        // ----------------------------------------------------
      

        // EnumDefinition
        // ----------------------------------------------------
        val ed = g.enumDefinitionAccess
        // Min:1, Max:2 , Newline before "enum"
        c.setLinewrap(1, 2, 2).before(ed.enumKeyword_0)

        // One space between "enum" and name
        c.setSpace(" ").between(ed.enumKeyword_0, ed.nameAssignment_1);

        // One space after each enum element
        c.setSpace(" ").after(ed.commaKeyword_3_1_0);

        // Indent Enum
        c.setIndentation(ed.leftCurlyBracketKeyword_2, ed.rightCurlyBracketKeyword_4)

        // Newline after "}"
        c.setLinewrap(2, 2, 2).after(ed.rightCurlyBracketKeyword_4)

        // VariableDeclaration
        // ----------------------------------------------------
        // val vd = g.variableDeclarationAccess
        // ModifierDefinition
        // ----------------------------------------------------
        val modDef = g.modifierAccess
        // One space between "modifier" and name
        c.setSpace(" ").between(modDef.modifierKeyword_0, modDef.nameAssignment_1);

        // EventDefinition
        // ----------------------------------------------------
        val eventDef = g.eventAccess
        // One space between "event" and name
        c.setSpace(" ").between(eventDef.eventKeyword_0, eventDef.nameAssignment_1);

        // TypeName
        // ----------------------------------------------------
        // Mapping
        // ----------------------------------------------------
        val mappingDef = g.mappingAccess

        // One space after "mapping"
        c.setSpace(" ").after(mappingDef.mappingKeyword_0);

        // One space before/after "=>"
        c.setSpace(" ").before(mappingDef.equalsSignGreaterThanSignKeyword_3);
        c.setSpace(" ").after(mappingDef.equalsSignGreaterThanSignKeyword_3);

        // UserDefinedTypeName
        // ----------------------------------------------------
        // ArrayDimensions
        // ----------------------------------------------------
        // ParameterListElements
        // ----------------------------------------------------
        // Statement
        // val statement = g.statementAccess;
        // Newline before "statement"
        // c.setLinewrap(1, 2, 2).before(statement.simpleStatementParserRuleCall_9)
        // ----------------------------------------------------
        // IfStatement
        // ----------------------------------------------------
        val ifs = g.ifStatementAccess

        // Newline before "if"
        c.setLinewrap(1, 2, 2).before(ifs.ifKeyword_0)
        c.setLinewrap(1,1,2).before(ifs.trueBodyAssignment_4)

//        c.setIndentation(ifs.trueBodyAssignment_4,ifs.trueBodyAssignment_4)
        
        // One space between "if" and "("
        c.setSpace(" ").between(ifs.ifKeyword_0, ifs.leftParenthesisKeyword_1);
        // Newline before "else"
        c.setLinewrap(1, 2, 2).before(ifs.elseKeyword_5_0)

        // WhileStatementElements
        // ----------------------------------------------------
        val wstatement = g.whileStatementAccess

        // One space after "while"
        c.setSpace(" ").after(wstatement.whileKeyword_0);

        // ForStatement
        // ----------------------------------------------------
        val forStatement = g.forStatementAccess

        c.setSpace(" ").between(forStatement.forKeyword_0, forStatement.leftParenthesisKeyword_1);
        c.setSpace(" ").between(forStatement.semicolonKeyword_3, forStatement.conditionExpressionAssignment_4);
        c.setNoSpace().between(forStatement.loopExpressionAssignment_6, forStatement.rightParenthesisKeyword_7)
        c.setNoLinewrap.after(forStatement.semicolonKeyword_3);
        c.setNoLinewrap.after(forStatement.semicolonKeyword_5);

        // Block
        // ----------------------------------------------------
        val blk = g.blockAccess
        // Indent Block
        c.setIndentation(blk.leftCurlyBracketKeyword_0, blk.rightCurlyBracketKeyword_3)

        // ContinueStatement
        // ----------------------------------------------------
        val continue = g.continueStatementAccess

        // Newline before "continue"
        c.setLinewrap(1, 2, 2).before(continue.continueKeyword_0);

        // BreakStatement
        // ----------------------------------------------------
        val brk = g.breakStatementAccess

        // Newline before "break"
        c.setLinewrap(1, 2, 2).before(brk.breakKeyword_0)

        // ReturnStatement
        // ----------------------------------------------------
        val rtn = g.returnStatementAccess

        // Newline before "return"
        c.setLinewrap(1, 2, 2).before(rtn.returnKeyword_0)

        // val returnStatement = g.returnStatementAccess
        // ThrowStatement
        // ----------------------------------------------------
        // val throwStatement = g.throwStatementAccess
        // PlaceHolderStatement
        // ----------------------------------------------------
        // SimpleStatement
        // ----------------------------------------------------
        // VariableDeclarationStatement
        // ----------------------------------------------------
        // ExpressionStatement
        // ----------------------------------------------------
        // Expression
        // ----------------------------------------------------
        // Assignment
        // ----------------------------------------------------
        val assignment = g.assignmentAccess

        // One space before/after "="
        c.setSpace(" ").before(assignment.assignmentOpAssignment_1_0_1);
        c.setSpace(" ").after(assignment.assignmentOpAssignment_1_0_1);

        // Or
        // ----------------------------------------------------
        val or = g.orAccess
        // One space before/after "||"
        c.setSpace(" ").before(or.verticalLineVerticalLineKeyword_1_1);
        c.setSpace(" ").after(or.verticalLineVerticalLineKeyword_1_1);

        // And
        // ----------------------------------------------------
        val and = g.andAccess
        // One space before/after "&&"
        c.setSpace(" ").before(and.ampersandAmpersandKeyword_1_1);
        c.setSpace(" ").after(and.ampersandAmpersandKeyword_1_1);

        // Equality
        // ----------------------------------------------------
        val equality = g.equalityAccess
        // One space before/after "&&"
        c.setSpace(" ").before(equality.getEqualityOpEqualityOpEnumEnumRuleCall_1_1_0)
        c.setSpace(" ").after(equality.getEqualityOpEqualityOpEnumEnumRuleCall_1_1_0);

        // Comparison
        // ----------------------------------------------------
        val comparison = g.comparisonAccess
        // One space before/after "op"
        c.setSpace(" ").before(comparison.comparisonOpComparisonOpEnumEnumRuleCall_1_1_0)
        c.setSpace(" ").after(comparison.comparisonOpComparisonOpEnumEnumRuleCall_1_1_0);

        // BitOr
        // ----------------------------------------------------
        val bitor = g.bitOrAccess
        // One space before/after "|"
        c.setSpace(" ").before(bitor.verticalLineKeyword_1_1);
        c.setSpace(" ").after(bitor.verticalLineKeyword_1_1);

        // BitXor
        // ----------------------------------------------------
        val bitxor = g.bitXorAccess
        // One space before/after "^"
        c.setSpace(" ").before(bitxor.circumflexAccentKeyword_1_1);
        c.setSpace(" ").after(bitxor.circumflexAccentKeyword_1_1);

        // BitAnd
        // ----------------------------------------------------
        val bitand = g.bitAndAccess
        // One space before/after "&"
        c.setSpace(" ").before(bitand.ampersandKeyword_1_1);
        c.setSpace(" ").after(bitand.ampersandKeyword_1_1);

        // Shift
        // ----------------------------------------------------
        val shift = g.shiftAccess
        // One space before/after ">>"
        c.setSpace(" ").before(shift.shiftOpShiftOpEnumEnumRuleCall_1_1_0)
        c.setSpace(" ").after(shift.shiftOpShiftOpEnumEnumRuleCall_1_1_0);

        // AddSub
        // ----------------------------------------------------
        val addsub = g.addSubAccess
        // One space before/after ">>"
        c.setSpace(" ").before(addsub.additionOpAdditionOpEnumEnumRuleCall_1_0_1_0)
        c.setSpace(" ").after(addsub.additionOpAdditionOpEnumEnumRuleCall_1_0_1_0);

        // MulDivMod
        // ----------------------------------------------------
        val mulldiv = g.mulDivModAccess
        // One space before/after "*"
        c.setSpace(" ").before(mulldiv.multipliciativeOpMulDivModOpEnumEnumRuleCall_1_1_0)
        c.setSpace(" ").after(mulldiv.multipliciativeOpMulDivModOpEnumEnumRuleCall_1_1_0);

        // Exponent
        // ----------------------------------------------------
        val exponent = g.exponentAccess
        // No spaces before/after "**"
        c.setNoSpace().before(exponent.asteriskAsteriskKeyword_1_1);
        c.setNoSpace().after(exponent.asteriskAsteriskKeyword_1_1);

        // UnaryExpressions
        // ----------------------------------------------------
        val notExpression = g.notExpressionAccess
        // No spaces after "!"
        c.setNoSpace().after(notExpression.exclamationMarkKeyword_0);

        val preIncExpression = g.preIncExpressionAccess
        // No space "++foo"
        c.setNoSpace().before(preIncExpression.expressionAssignment)

        val preDecExpression = g.preDecExpressionAccess
        // No space "--foo"
        c.setNoSpace().before(preDecExpression.expressionAssignment)

        val binaryNotExpression = g.binaryNotExpressionAccess
        // No spaces after "~"
        c.setNoSpace().after(binaryNotExpression.tildeKeyword_0);

        val signExpression = g.signExpressionAccess
        // No spaces after "+/-"
        c.setNoSpace().after(signExpression.signOpAssignment_0);

        val newExpression = g.newExpressionAccess
        // One space after "new"
        c.setSpace(" ").between(newExpression.newKeyword_0,newExpression.contractAssignment_1);

//        val postIncDecExpression = g.postIncDecExpressionAccess
        // No space "foo++" or "foo--"
//        c.setNoSpace().after(postIncDecExpression
        
        val ether = g.etherAccess
        // One space between # and EtherSubDenomination
        c.setSpace(" ").between(ether.valueAssignment_0,ether.etherEtherSubDenominationEnumEnumRuleCall_1_0);
        
        val time = g.timeAccess
        // One space between # and TimeSubDenomination
        c.setSpace(" ").between(time.valueAssignment_0,time.timeTimeSubdenominationEnumEnumRuleCall_1_0);
        
        val typeCast = g.typeCastAccess
        // No space
        c.setNoSpace().between(typeCast.valueElementaryTypeNameEnumEnumRuleCall_0_0,typeCast.leftParenthesisKeyword_1)
        c.setNoSpace().between(typeCast.leftParenthesisKeyword_1,typeCast.expressionAssignment_2)
        c.setNoSpace().between(typeCast.expressionAssignment_2,typeCast.rightParenthesisKeyword_3)
        
        
    } // configureFormatting
} // SolidityFormatter
