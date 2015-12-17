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
package com.dell.research.bc.eth.solidity.editor.tests.validation;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({ CheckContractNotInLibraryHierarchyUnitTest.class,
		CheckNoCycleInContractOrLibraryHierarchyUnitTest.class, CheckNoDuplicateContractUnitTest.class,
		CheckNoDuplicateLibraryUnitTest.class, CheckNoDuplicateLibraryOrContractVariablesUnitTest.class,
		CheckNoStatementAfterReturnUnitTest.class })
public class ParseTestSuite {
	// Nothing
} // StatementParseTestSuite