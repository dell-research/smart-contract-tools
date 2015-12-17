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

package com.dell.research.bc.eth.solidity.editor;

import com.dell.research.bc.eth.solidity.editor.SolidityStandaloneSetupGenerated;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class SolidityStandaloneSetup extends SolidityStandaloneSetupGenerated{

	public static void doSetup() {
		new SolidityStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

