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
package com.dell.research.bc.eth.solidity.editor.validation

import com.dell.research.bc.eth.solidity.editor.SolidityTypeConformance
import com.dell.research.bc.eth.solidity.editor.SolidityTypeProvider
import com.dell.research.bc.eth.solidity.editor.solidity.Contract
import com.dell.research.bc.eth.solidity.editor.solidity.ContractOrLibrary
import com.dell.research.bc.eth.solidity.editor.solidity.Expression
import com.dell.research.bc.eth.solidity.editor.solidity.Library
import com.dell.research.bc.eth.solidity.editor.solidity.ReturnStatement
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage
import com.dell.research.bc.eth.solidity.editor.solidity.StandardVariableDeclaration
import com.dell.research.bc.eth.solidity.editor.solidity.VarVariableDeclaration
import com.google.inject.Inject
import org.eclipse.xtext.validation.Check

import static extension com.dell.research.bc.eth.solidity.editor.SolidityUtil.*

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class SolidityValidator extends AbstractSolidityValidator {
    @Inject extension SolidityTypeProvider
    @Inject extension SolidityTypeConformance

    public static val HIERARCHY_CYCLE = "com.dell.research.bc.eth.solidity.editor.HierarchyCycle"
    public static val CONTRACT_IN_HIERARCHY = "com.dell.research.bc.eth.solidity.editor.ContractInHierarchy"
    public static val UNREACHABE_CODE = "com.dell.research.bc.eth.solidity.editor.UnreachableCode"
    public static val DUPLICATE_ELEMENT = "com.dell.research.bc.eth.solidity.editor.DuplicateElement"
    public static val INCOMPATIBLE_TYPES = "com.dell.research.bc.eth.solidity.editor.IncompatibleTypes"

    @Check
    def checkNoCycleInContractOrLibraryHierarchy(ContractOrLibrary contract) {
        // Does the Contract or Library appear in its own hierarchy?
        if (contract.classHierarchy.contains(contract)) {
            // Yes
            error("cycle in hierarchy of Contract/Library '" + contract.name + "'",
                SolidityPackage::eINSTANCE.contractOrLibrary_InheritanceSpecifiers, HIERARCHY_CYCLE, contract.name)
        }
    } // checkNoCycleInContractOrLibraryHierarchy

    @Check
    def checkContractNotInLibraryHierarchy(Library library) {
        val classHierarchy = library.classHierarchy

        for (ContractOrLibrary cl : classHierarchy) {
            // Contract?
            if (cl instanceof Contract) {
                // Yes
                error("Contract '" + cl.name + "' in hierarchy of Library '" + library.name + "'",
                    SolidityPackage::eINSTANCE.contractOrLibrary_InheritanceSpecifiers, CONTRACT_IN_HIERARCHY, cl.name)
                return;
            }
        }
    } // checkContractNotInLibraryHierarchy

    @Check
    def checkNoStatementAfterReturn(ReturnStatement ret) {

        val ifStatement = ret.containingIfStatement
        if (ifStatement != null && ifStatement.trueBody == ret) {
            return
        }

        val statements = ret.containingBlock.statements
        if (statements.last != ret) { // && !statements.last instanceof IfStatement) {
        // Error on the statement after the return
            error("Unreachable code", statements.get(statements.indexOf(ret) + 1), null, // EStructualFeature
            UNREACHABE_CODE)
        }
    } // checkNoStatementAfterReturn

    @Check
    def void checkNoDuplicateContract(Contract contract) {
        if (contract.containingSolidity.contract.exists[it != contract && it.name == contract.name]) {
            error(
                "Duplicate Contract '" + contract.name + "'",
                SolidityPackage::eINSTANCE.contractOrLibrary_Name,
                DUPLICATE_ELEMENT
            )
        }
    } // checkNoDuplicateContract

    @Check
    def void checkNoDuplicateLibrary(Library library) {
        if (library.containingSolidity.library.exists[it != library && it.name == library.name]) {
            error(
                "Duplicate Library '" + library.name + "'",
                SolidityPackage::eINSTANCE.contractOrLibrary_Name,
                DUPLICATE_ELEMENT
            )
        }
    } // checkNoDuplicateLibrary

    @Check
    def void checkNoDuplicateLibraryOrContractVariables(StandardVariableDeclaration vd) {
        var duplicate = vd.containingContractOrLibrary.body.variables.findFirst [
            it != vd && it.eClass == vd.eClass && (it as StandardVariableDeclaration).variable.name == vd.variable.name
        ]

        // Duplicate Var Variable Declaration?
        if (duplicate == null) {
            duplicate = vd.containingContractOrLibrary.body.variables.findFirst [
                it != vd && it.eClass == SolidityPackage::eINSTANCE.varVariableDeclaration &&
                    (it as VarVariableDeclaration).variable.name == vd.variable.name
            ]
        }

        if (duplicate != null) {
            error(
                "Duplicate variable '" + vd.variable.name + "'",
                SolidityPackage::eINSTANCE.standardVariableDeclaration_Variable,
                DUPLICATE_ELEMENT
            )
        }
    } // checkNoDuplicateLibraryOrContractVariables

    @Check
    def void checkNoDuplicateLibraryOrContractVariables(VarVariableDeclaration vd) {
        var duplicate = vd.containingContractOrLibrary.body.variables.findFirst [
            it != vd && it.eClass == vd.eClass && (it as VarVariableDeclaration).variable.name == vd.variable.name
        ]

        // Duplicate Standard Variable Declaration?
        if (duplicate == null) {
            duplicate = vd.containingContractOrLibrary.body.variables.findFirst [
                it != vd && it.eClass == SolidityPackage::eINSTANCE.standardVariableDeclaration &&
                    (it as StandardVariableDeclaration).variable.name == vd.variable.name
            ]
        }

        if (duplicate != null) {
            error(
                "Duplicate variable '" + vd.variable.name + "'",
                SolidityPackage::eINSTANCE.varVariableDeclaration_Variable,
                DUPLICATE_ELEMENT
            )
        }
    } // checkNoDuplicateLibraryOrContractVariables

    @Check
    def checkCompatibleTypes(Expression exp) {
        val actualType = exp.typeFor
        val expectedType = exp.expectedType

        // Anything to compare?
        if (expectedType != null && actualType != null) {
            if (!actualType.isConformant(expectedType)) {
                error(
                    "Incompatible types. Expected '" + expectedType?.name + "' but was '" + actualType?.name + "'",
                    null,
                    INCOMPATIBLE_TYPES
                )
            }
        } // if
    } // checkCompatibleTypes
} // SolidityValidator
