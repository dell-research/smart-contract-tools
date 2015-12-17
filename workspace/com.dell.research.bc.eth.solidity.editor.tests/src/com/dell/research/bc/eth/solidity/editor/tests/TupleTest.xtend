package com.dell.research.bc.eth.solidity.editor.tests

import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.Ignore

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class TupleTest extends AbsStatementTest {
	@Ignore
	@Test
	def void givenValidTuple_thenNoErrors() {
		'''(x, y, z) = (1, 2 ,3)'''.assertReprStmt("(x, y, z) = (1, 2 ,3);")
	}
} // TupleTest