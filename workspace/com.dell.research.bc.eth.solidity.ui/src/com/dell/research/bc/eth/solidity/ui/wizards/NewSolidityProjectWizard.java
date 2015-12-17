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
package com.dell.research.bc.eth.solidity.ui.wizards;

import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.SubProgressMonitor;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.actions.WorkspaceModifyOperation;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;

public class NewSolidityProjectWizard extends Wizard implements INewWizard {
	private WizardNewProjectCreationPage mainPage;

	public NewSolidityProjectWizard() {
		super();
		setWindowTitle("New Solidity Project");
	}

	@Override
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		// Nothing
	}

	@Override
	public void addPages() {
		super.addPages();
		mainPage = new WizardNewProjectCreationPage("New Solidity Project");
		mainPage.setTitle("Solidity Project");
		mainPage.setDescription("Create a new Solidity project.");
		addPage(mainPage);
	}

	@Override
	public boolean performFinish() {
		WorkspaceModifyOperation op = new WorkspaceModifyOperation() {
			@Override
			protected void execute(IProgressMonitor monitor)
					throws CoreException, InvocationTargetException, InterruptedException {
				finishPage(monitor);
			}
		};

		try {
			getContainer().run(false, true, op);
		} catch (InvocationTargetException ite) {
			return false;
		} catch (InterruptedException ie) {
			return false; // canceled
		}
		return true;
		
	} // performFinish

	private void finishPage(IProgressMonitor monitor) throws CoreException {
		if (monitor == null) {
			monitor = new NullProgressMonitor();
		}
		try {
			monitor.beginTask("Create Solidity Project", 3);
			IProject project = mainPage.getProjectHandle();
			IPath locationPath = mainPage.getLocationPath();
			
			IProjectDescription desc = project.getWorkspace().newProjectDescription(project.getName());
			desc.setComment("Solidity Project");
			if (!mainPage.useDefaults()) {
				desc.setLocation(locationPath);
			}
			project.create(desc, new SubProgressMonitor(monitor, 1));
			project.open(new SubProgressMonitor(monitor, 1));
			String[] natures = {SolidityProjectNature.NATURE_ID, "org.eclipse.xtext.ui.shared.xtextNature" };
			addNatures(project, natures, monitor);
			String[] paths = { "src"};
			addToProjectStructure(project, paths);
		}
		finally {
			monitor.done();
		}
	} // finishPage
	
	
	private  void addNatures(IProject project,String[] natures, IProgressMonitor monitor) throws CoreException {
		final IProjectDescription description = project.getDescription();
		
		final Set<String> natureDescriptions = (new HashSet<String>( Arrays.asList(description.getNatureIds())));
		natureDescriptions.addAll(Arrays.asList(natures));
		
		description.setNatureIds((String[]) natureDescriptions.toArray(new String[natureDescriptions.size()]));
		project.setDescription(description, new SubProgressMonitor(monitor, 1));
		
		
	} // addNatures
	

	private static void addToProjectStructure(IProject project, String[] paths) throws CoreException {
		for (String path : paths) {
			IFolder etcFolders = project.getFolder(path);
			createFolder(etcFolders);
		}
	}
	
	private static void createFolder(IFolder folder) throws CoreException {
		IContainer parent = folder.getParent();
		if (parent instanceof IFolder) {
			createFolder((IFolder)parent);
		}
		if (!folder.exists()) {
			folder.create(false, true, null);
		}
}
} // NewSolidityProjectWizard
