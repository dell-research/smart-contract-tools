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

import com.dell.research.bc.eth.solidity.editor.solidity.And
import com.dell.research.bc.eth.solidity.editor.solidity.BinaryNotExpression
import com.dell.research.bc.eth.solidity.editor.solidity.BooleanConst
import com.dell.research.bc.eth.solidity.editor.solidity.Comparison
import com.dell.research.bc.eth.solidity.editor.solidity.Equality
import com.dell.research.bc.eth.solidity.editor.solidity.Expression
import com.dell.research.bc.eth.solidity.editor.solidity.NewExpression
import com.dell.research.bc.eth.solidity.editor.solidity.NotExpression
import com.dell.research.bc.eth.solidity.editor.solidity.NumberDimensionless
import com.dell.research.bc.eth.solidity.editor.solidity.Or
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityFactory
import com.dell.research.bc.eth.solidity.editor.solidity.StringLiteral
import com.dell.research.bc.eth.solidity.editor.solidity.Tuple
import com.dell.research.bc.eth.solidity.editor.solidity.Ether
import com.dell.research.bc.eth.solidity.editor.solidity.Time
import com.dell.research.bc.eth.solidity.editor.solidity.TypeCast
import com.dell.research.bc.eth.solidity.editor.solidity.SolidityPackage
import com.dell.research.bc.eth.solidity.editor.solidity.VariableDeclarationExpression
import com.dell.research.bc.eth.solidity.editor.solidity.Assignment

class SolidityTypeProvider {

    public static val booleanType = SolidityFactory.eINSTANCE.createContractOrLibrary => [name = "booleanType"]
    public static val tupleType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "tupleType"
    ]
    public static val numberDimensionlessType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "numberDimensionlessType"
    ]
    public static val stringType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "stringType"
    ]

    // The Ether, Time and TypeCast probably need to be expanded to include
    // the different sub-domains. DAF
    public static val etherType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "etherType"
    ]
    public static val timeType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "timeType"
    ]
    public static val typeCastType = SolidityFactory.eINSTANCE.createContractOrLibrary => [
        name = "typeCastType"
    ]

    def typeFor(Expression e) {
        switch (e) {
            Or: booleanType
            And: booleanType
            Equality: booleanType
            Comparison: booleanType
            NotExpression: booleanType
            BinaryNotExpression: booleanType
            NewExpression: e.contract
            Tuple: tupleType
            BooleanConst: booleanType
            StringLiteral: stringType
            NumberDimensionless: numberDimensionlessType
            Ether: etherType
            Time: timeType
            TypeCast: typeCastType
            default: booleanType
        } // switch
    } // typeFor

    def expectedType(Expression e) {
        val c = e.eContainer
        val f = e.eContainingFeature

        switch (c) {
            VariableDeclarationExpression case f == SolidityPackage::VARIABLE_DECLARATION_EXPRESSION: c.type.typeFor
            Assignment case f == SolidityPackage::ASSIGNMENT__LEFT: c.left.typeFor
            NewExpression case f == SolidityPackage::VARIABLE_DECLARATION_EXPRESSION__TYPE: c.contract
            case f == SolidityPackage::IF_STATEMENT__CONDITION: booleanType
        } // switch
    } // expectedType
} // SolidityTypeProvider