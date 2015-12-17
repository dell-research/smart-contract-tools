package com.dell.research.bc.eth.solidity.editor.tests.formatting

import com.dell.research.bc.eth.solidity.editor.tests.formatting.AbstractSolidityEditorFormattingTest
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.InjectWith
import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import org.junit.Test
import org.junit.Ignore

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class IfStatementFormattingTest extends AbstractSolidityEditorFormattingTest {
    val VALID_IF_STATMENT_UNFORMATTED0 = '''
        if (true) { return x;} else {return y;}
    '''

    val VALID_IF_STATMENT_FORMATTED0 = '''
    if (true) { return x;} else {return y;}'''

    @Ignore
    @Test
    def void givenUnformattedIfStatement0_thenCorrectlyFormatted() {
        VALID_IF_STATMENT_UNFORMATTED0.assertFormattedAs(
            VALID_IF_STATMENT_FORMATTED0
        )
    }
} // IfStatementFormattingTest