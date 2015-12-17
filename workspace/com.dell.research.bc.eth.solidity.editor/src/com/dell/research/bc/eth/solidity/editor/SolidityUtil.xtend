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

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.dell.research.bc.eth.solidity.editor.solidity.FunctionDefinition
import com.dell.research.bc.eth.solidity.editor.solidity.ReturnStatement
import org.eclipse.emf.ecore.EObject
import com.dell.research.bc.eth.solidity.editor.solidity.Block
import com.dell.research.bc.eth.solidity.editor.solidity.ContractOrLibrary
import com.dell.research.bc.eth.solidity.editor.solidity.IfStatement
import com.dell.research.bc.eth.solidity.editor.solidity.InheritanceSpecifier
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity

// See page 202 of Xtext book
class SolidityUtil {

    def static containingSolidity(EObject e) {
        e.getContainerOfType(typeof(Solidity))
    }

	def static returnStatement(FunctionDefinition fd) {
		fd.block.statements.typeSelect(typeof(ReturnStatement)).head
	}

	def static containingContractOrLibrary(EObject e) {
		e.getContainerOfType(ContractOrLibrary)
	}

	def static containingFunction(EObject e) {
		e.getContainerOfType(FunctionDefinition)
	}

	def static containingIfStatement(EObject e) {
		e.getContainerOfType(IfStatement)
	}

	def static containingBlock(EObject e) {
		e.getContainerOfType(Block)
	}

	def static classHierarchy(ContractOrLibrary cl) {
		val toVisit = <InheritanceSpecifier>newHashSet();
		toVisit.addAll(cl.inheritanceSpecifiers)
		val visited = <ContractOrLibrary>newHashSet();
		//visited.add(cl)

		while (!toVisit.empty) {
			var is = toVisit.last
			toVisit.remove(is)
			var current = is.superType
			// Seen this one before?
			if (!visited.contains(current)) {
				// No
				toVisit.addAll(current.inheritanceSpecifiers)
				visited.add(current)
			}
		} // while !toVisit.empty
		visited
	}

} // SolidityUtil