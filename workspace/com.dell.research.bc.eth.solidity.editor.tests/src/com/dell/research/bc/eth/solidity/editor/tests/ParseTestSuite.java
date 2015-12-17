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
package com.dell.research.bc.eth.solidity.editor.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({ BinaryExpressionTest.class, BlockTest.class, ContractDefinitionTest.class,
		ElementaryTypeNameTest.class, EnumDefinitionTest.class, EnumValueTest.class, EventDefinitionTest.class,
		ExpressionTest.class, ExpressionStatementTest.class, ForStatementTest.class,
		FunctionCallListArgumentsTest.class, FunctionDefinitionTest.class, IfStatementTest.class,
		ImportDirectiveTest.class, InheritanceSpecifierTest.class, LibraryDefinitionTest.class,
		ModifierDefinitionTest.class, ModifierInvocationTest.class, ParameterListTest.class,
		PlaceholderStatementTest.class, ReturnParameterListTest.class, SimpleStatementTest.class,
		SolidityTypeConformanceUnitTest.class, SolidityTypeProviderUnitTest.class, StructDefinitionTest.class,
		TupleTest.class, TupleTypeTest.class, TypeNameTest.class, VariableDeclarationTest.class,
		VariableDeclarationStatementTest.class, WhileStatementTest.class })
public class ParseTestSuite {
	// Nothing
} // StatementParseTestSuite