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
package com.dell.research.bc.eth.solidity.editor.ui.outline

import com.dell.research.bc.eth.solidity.editor.solidity.Contract
import com.dell.research.bc.eth.solidity.editor.solidity.EnumDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.EnumValue
import com.dell.research.bc.eth.solidity.editor.solidity.FunctionDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.ImportDirective
import com.dell.research.bc.eth.solidity.editor.solidity.Library
import com.dell.research.bc.eth.solidity.editor.solidity.Modifier
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage
import com.dell.research.bc.eth.solidity.editor.solidity.StandardVariableDeclaration
import com.dell.research.bc.eth.solidity.editor.solidity.VisibilitySpecifier
import com.google.inject.Inject
import org.eclipse.xtext.ui.IImageHelper
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

/**
 * Customization of the default outline structure.
 * 
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#outline
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 * 
 * see http://www.drdobbs.com/architecture-and-design/customizing-xtext/231902091?pgno=1
 */
class SolidityOutlineTreeProvider extends DefaultOutlineTreeProvider {
    @Inject
    private IImageHelper imageHelper
    
    def protected _createChildren(DocumentRootNode parentNode, Solidity solidity) {

        if (solidity.importDirective.size > 0) {
            createEStructuralFeatureNode(parentNode, solidity, SolidityPackage.Literals.SOLIDITY__IMPORT_DIRECTIVE,
            imageHelper.getImage("impc_obj.png"), "import declarations", false);
        }

        for (id : solidity.contract) {
            createNode(parentNode, id)
        }

        for (id : solidity.library) {
            createNode(parentNode, id)
        }

    } // _createChildren

    def protected _isLeaf(ImportDirective id) {
        true
    }

    def protected _createChildren(IOutlineNode parentNode, Contract cd) {
        //cd.body.inheritanceSpecifiers.forEach[createNode(parentNode, it)]
        cd.body.structs.forEach[createNode(parentNode, it)]
        cd.body.enums.forEach[createNode(parentNode, it)]
        cd.body.variables.forEach[createNode(parentNode, it)]
        cd.body.modifiers.forEach[createNode(parentNode, it)]
        cd.body.events.forEach[createNode(parentNode, it)]
        cd.body.functions.forEach[createNode(parentNode, it)]
    } // _createChildren

    def protected _createChildren(IOutlineNode parentNode, Library ld) {
        //ld.body.inheritanceSpecifiers.forEach[createNode(parentNode, it)]
        ld.body.structs.forEach[createNode(parentNode, it)]
        ld.body.enums.forEach[createNode(parentNode, it)]
        ld.body.variables.forEach[createNode(parentNode, it)]
        ld.body.modifiers.forEach[createNode(parentNode, it)]
        ld.body.events.forEach[createNode(parentNode, it)]
        ld.body.functions.forEach[createNode(parentNode, it)]
    } // _createChildren

    def protected _createChildren(IOutlineNode parentNode, EnumDefinition enumDefinition) {
        enumDefinition.members.forEach[createNode(parentNode, it)]
    } // _createChildren

//    def protected _createChildren(IOutlineNode parentNode, InheritanceSpecifier is) {
//        is.args.arguments.forEach[createNode(parentNode, it)]
//    }

    def protected _isLeaf(FunctionDefinition fd) {
        true
    }

    def protected _isLeaf(Modifier md) {
        true
    }

    def protected _isLeaf(EnumValue ev) {
        true
    }

    def protected _isLeaf(VisibilitySpecifier vs) {
        true
    }

    def protected _isLeaf(StandardVariableDeclaration svd) {
        true
    }

} // SolidityOutlineTreeProvider
