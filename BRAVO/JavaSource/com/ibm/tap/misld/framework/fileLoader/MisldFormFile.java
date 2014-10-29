/*
 * Created on Jul 2, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.framework.fileLoader;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;

import org.apache.struts.upload.FormFile;

/**
 * @author newtont
 * 
 * This object is only used to hold form files while loading the test data
 * suite. It Implements a FormFile so they can be generated outside of the
 * struts framework.
 */
public class MisldFormFile implements FormFile, Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	String fileName;

    public String getContentType() {
        return null;
    }

    public void setContentType(String arg0) {

    }

    public int getFileSize() {
        return 0;
    }

    public void setFileSize(int arg0) {

    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String arg0) {
        fileName = arg0;

    }

    public byte[] getFileData() throws FileNotFoundException, IOException {
        return null;
    }

    public InputStream getInputStream() throws FileNotFoundException,
            IOException {
        return null;
    }

    public void destroy() {
    }

}