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
package com.dell.research.bc.eth.solidity.editor.ui.labeling

import com.dell.research.bc.eth.solidity.editor.solidity.Contract
import com.dell.research.bc.eth.solidity.editor.solidity.ElementaryType
import com.dell.research.bc.eth.solidity.editor.solidity.EnumDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.EnumValue
import com.dell.research.bc.eth.solidity.editor.solidity.FunctionDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.ImportDirective
import com.dell.research.bc.eth.solidity.editor.solidity.Library
import com.dell.research.bc.eth.solidity.editor.solidity.Mapping
import com.dell.research.bc.eth.solidity.editor.solidity.Modifier
import com.dell.research.bc.eth.solidity.editor.solidity.ParameterList
import com.dell.research.bc.eth.solidity.editor.solidity.ReturnParameterDeclaration
import com.dell.research.bc.eth.solidity.editor.solidity.ReturnsParameterList
import com.dell.research.bc.eth.solidity.editor.solidity.StandardVariableDeclaration
import com.dell.research.bc.eth.solidity.editor.solidity.Statement
import com.dell.research.bc.eth.solidity.editor.solidity.StructDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.VarVariableDeclaration
import com.dell.research.bc.eth.solidity.editor.solidity.VarVariableTupleVariableDeclaration
import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.jface.viewers.StyledString
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.utils.TextStyle
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider

/**
 * Provides labels for EObjects.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#label-provider
 */
class SolidityLabelProvider extends DefaultEObjectLabelProvider {

    @Inject
    new(AdapterFactoryLabelProvider delegate) {
        super(delegate);
    }

    def TextStyle getTypeTextStyle() {
        var TextStyle retValue = new TextStyle()
        retValue.setColor(new RGB(149, 125, 71))
        retValue.setStyle(SWT.ITALIC)
        retValue
    }

//---------------------------------------------------
// Look at pages 225-227 of the Xtext book on how to use
// StyledStrings to produce a more attractive outline view 
    def text(ImportDirective id) {
        id.url
    }

    def text(Contract cd) {
        cd.name
    }

    def text(Library ld) {
        ld.name
    }

    def text(FunctionDefinition fd) {
        var retValue = new StyledString(fd?.name ?: "")
        retValue = retValue.
            append(new StyledString(getText(fd.parameters)))

        if (fd.returnParameters != null) {
            retValue = retValue.append(new StyledString(
                " : " + getText(fd.returnParameters),
                StyledString::DECORATIONS_STYLER))
        } // if
        retValue
    }

    def text(ReturnsParameterList rpl) {
        val StringBuilder sb = new StringBuilder();
        // Aggregate returns?
        if (rpl.parameters != null) {
            if (rpl.parameters.size > 1) {
                sb.append("(")
            }
            for (var int i = 0; i < rpl.parameters.size - 1; i++) {
                sb.append(getText(rpl.parameters.get(i)))
                sb.append(", ")
            }
            if (rpl.parameters.size >= 1) {
                sb.append(getText(rpl.parameters.last()))
            }
            if (rpl.parameters.size > 1) {
                sb.append(")")
            }
        } // if != null
        sb.toString
    }

    def text(ReturnParameterDeclaration rpd) {
        val StringBuilder sb = new StringBuilder(getText(rpd.typeRef));
        sb.toString
    }

    def text(Modifier md) {
        val StringBuilder sb = new StringBuilder(md?.name);
        sb.append(getText(md.parameters))
        sb.toString
    }

    def text(Statement stmt) {
        switch stmt {
            default: "Statement"
        }
    }

    def text(StandardVariableDeclaration svd) {
        new StyledString(getText(svd.variable)).append(new StyledString(
            " : " + getText(svd.type),
            StyledString::DECORATIONS_STYLER
        ))
    }

    def text(ElementaryType et) {
        et.name.toString
    }

    def text(Mapping m) {
        val StringBuilder sb = new StringBuilder(m.keyType.toString)
        sb.append(" => ")
        sb.append(getText(m.valueType))
        sb.toString
    }

    def text(EnumDefinition ed) {
        ed.name
    }

    def text(EnumValue ev) {
        getText(ev.name)
    }

    def text(ParameterList pl) {
        val StringBuilder sb = new StringBuilder('(');
        for (var i = 0; i < pl.parameters.length - 1; i++) {
            sb.append(justTypeText(pl.parameters.get(i)))
            sb.append(', ')
        }
        if (pl.parameters.length >= 1) {
            sb.append(justTypeText(pl.parameters.get(pl.parameters.length - 1)))
        }
        sb.append(')')
        sb.toString
    }

    def justTypeText(Statement vd) {
        switch vd {
            StandardVariableDeclaration: getText(vd.type)
            VarVariableDeclaration: getText(vd.varType)
            VarVariableTupleVariableDeclaration: getText(vd.tuple)
            default: "foo"
        }
    }

    // Images (found in the "icons" folder
    // ---------------------------------------------------
    def image(ImportDirective cd) {
        'imp_obj.png'
    }

    def image(Contract cd) {
        'class_obj.png'
    }

    def image(Library ld) {
        'library_obj.png'
    }

    def image(StructDefinition s) {
        'struct_obj.gif'
    }
    
    def image(StandardVariableDeclaration svd) {
        'field_public_obj.png'
    }
    
    def image(FunctionDefinition fd) {
        'methpub_obj.png'
    }

    def image(Modifier md) {
        'public_co.png'
    }

    def image(EnumDefinition cd) {
        'enum_obj.png'
    }

    def image(EnumValue cd) {
        'enumerator_obj.gif'
    }
} // SolidityLabelProvider
