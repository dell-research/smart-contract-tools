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

import org.eclipse.xtext.parser.antlr.ISyntaxErrorMessageProvider;

import com.dell.research.bc.eth.solidity.editor.SoliditySyntaxErrorMessageProvider;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class SolidityRuntimeModule extends com.dell.research.bc.eth.solidity.editor.AbstractSolidityRuntimeModule {
	public Class<? extends ISyntaxErrorMessageProvider> bindISyntaxErrorMessageProvider() {
	    return SoliditySyntaxErrorMessageProvider.class;
	}
} // SolidityRuntimeModule
