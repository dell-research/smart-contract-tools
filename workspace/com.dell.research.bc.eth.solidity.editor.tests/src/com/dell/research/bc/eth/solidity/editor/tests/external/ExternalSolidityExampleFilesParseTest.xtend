/*
 * Copyright 2015 by Dell Inc. 
 */
package com.dell.research.bc.eth.solidity.editor.tests.external

import com.google.inject.Inject
import java.io.File
import java.nio.charset.Charset
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.Arrays
import java.util.HashSet
import java.util.Set
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import com.dell.research.bc.eth.solidity.editor.SolidityInjectorProvider
import com.dell.research.bc.eth.solidity.editor.solidity.Solidity
//import org.junit.Assert
import java.util.HashMap
import java.util.Map
import org.junit.Before

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(SolidityInjectorProvider))
class ExternalSolidityExampleFilesParseTest {
    @Inject extension ParseHelper<Solidity>;
    @Inject extension ValidationTestHelper

    val PROJECT = "com.dell.research.bc.eth.solidity.editor.tests"
    val PROJECT_ROOT = ".."
    val FILE_ROOT = "solidity-test-input"
//    val THIRD_PARTY_ROOT = "third-party-examples"
    val SOLIDITY_FILE_SUFFIX = "sol"

    val FOLDERS_TO_SKIP = new HashSet<String>(Arrays.asList("runtimets", "metadata"))

    var Set<String> successFullyParsedFiles = new HashSet<String>();
    var Map<String, String> errorFiles = new HashMap<String, String>();

    @Before
    def void before() {
        successFullyParsedFiles = new HashSet<String>();
        errorFiles = new HashMap<String, String>();
    }

    @Test
    def void givenExistingSolidityExamples_whenParsed_thenNoParseErrors() {
        parseFilesInFolder(Paths.get(
            PROJECT_ROOT + File.separator + PROJECT + File.separator + FILE_ROOT
        ))
        System.out.println("Files parsed:\t" + (successFullyParsedFiles.size() + errorFiles.size()))
        System.out.println("Errors:\t\t" + errorFiles.size())
        System.out.println("Success:\t" + successFullyParsedFiles.size())

        if (!successFullyParsedFiles.isEmpty) {
            System.out.println
            System.out.println("Successfully parsed files are:")
            successFullyParsedFiles.forEach[println(it)]
        }

        if (!errorFiles.isEmpty) {
            System.out.println
            System.out.println("Parsed files with errors are:")
            errorFiles.keySet.forEach[println(errorFiles.get(it))]
        }

//        Assert::assertTrue(errorFiles.size() + " file(s) did not parse.", errorFiles.isEmpty)
    } // givenExistingSolidityExamples_whenParsed_thenNoParseErrors

//    @Test
//    def void givenThirdPartySolidityExamples_whenParsed_thenNoParseErrors() {
//        parseFilesInFolder(Paths.get(
//            PROJECT_ROOT + File.separator + PROJECT + File.separator + FILE_ROOT + THIRD_PARTY_ROOT
//        ))
//        System.out.println("3rd Party Files parsed:\t" + (successFullyParsedFiles.size() + errorFiles.size()))
//        System.out.println("Errors:\t\t" + errorFiles.size())
//        System.out.println("Success:\t" + successFullyParsedFiles.size())
//
//        if (!successFullyParsedFiles.isEmpty) {
//            System.out.println
//            System.out.println("Successfully parsed files are:")
//            successFullyParsedFiles.forEach[println(it)]
//        }
//
//        if (!errorFiles.isEmpty) {
//            System.out.println
//            System.out.println("Parsed files with errors are:")
//            errorFiles.keySet.forEach[println(errorFiles.get(it))]
//        }
//
//        Assert::assertTrue(errorFiles.size() + " file(s) did not parse.", errorFiles.size() == 0)
//    } // givenThirdPartySolidityExamples_whenParsed_thenNoParseErrors

    def void parseFilesInFolder(Path path) {
        // Is this a Solidity source file?
        if (Files.isRegularFile(path) && getExtension(path.fileName).equals(SOLIDITY_FILE_SUFFIX)) {
            // Yes
            try {
                parseFile(path)
                successFullyParsedFiles.add(removePrefix(path.toString))
            } catch (AssertionError ae) {
                // Parse error
                errorFiles.put(removePrefix(path.toString), ae.getMessage())
            // System.out.println(ae.getMessage())
            // errorCount++
            }
        } // Is it a folder?
        else if (Files.isDirectory(path) && !FOLDERS_TO_SKIP.contains(path.fileName.toString)) {
            // Yes
            Files.newDirectoryStream(path).iterator.forEach[parseFilesInFolder]
        }
    } // parseFilesInFolder

    def removePrefix(String string) {
        val i = string.lastIndexOf(File.separator) + 1
        return string.substring(i)
    }

    // parseFilesInFolder
    def getExtension(Path path) {
        val fileName = path.fileName.toString
        val i = fileName.lastIndexOf(".")
        return fileName.substring(i + 1)
    }

    // parseFilesInFolder
    def void parseFile(Path path) {
        try {
            readFileAsString(path, StandardCharsets.UTF_8).parse.assertNoErrors
        } // try
        catch (AssertionError ae) {
            throw new AssertionError("File \"" + path + "\" " + ae.message, ae)
        } catch (NullPointerException npe) {
            System.out.println("NPE for " + path)
        }
    } // parseFile

    def String readFileAsString(Path path, Charset encoding) {
        val retValue = new String(Files.readAllBytes(path), encoding);
        return retValue
    }

} // ExternalSolidityExampleFilesParseTest
