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

import static extension com.dell.research.bc.eth.solidity.editor.SolidityUtil.*
import com.dell.research.bc.eth.solidity.editor.solidity.ContractOrLibrary

class SolidityTypeConformance {

    def isSubclassOf(ContractOrLibrary c1, ContractOrLibrary c2) {
        c1.classHierarchy.contains(c2)
    }

    def isConformant(ContractOrLibrary c1, ContractOrLibrary c2) {
        c1 == c2 || c1.isSubclassOf(c2)
    }
} // SolidityTypeConformance