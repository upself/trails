/*
 * Created on Feb 1, 2006
 *
 */
package com.ibm.ea.bravo.parser;

import java.io.IOException;

import com.ibm.ea.bravo.software.parser.SwScan;


/**
 * @author Thomas
 *
 */
public interface InterfaceParser {
	
    /* The normal parser 
     */
    public boolean parse(SwScan lpar) throws IOException;        
    public void display(SwScan lpar);

}
