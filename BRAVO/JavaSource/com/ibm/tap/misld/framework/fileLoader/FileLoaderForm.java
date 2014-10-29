/*
 * Created on Apr 29, 2004
 * 
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

package com.ibm.tap.misld.framework.fileLoader;

import org.apache.struts.upload.FormFile;
import org.apache.struts.validator.ValidatorActionForm;

public class FileLoaderForm
        extends ValidatorActionForm {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private FormFile file;

    private String   fileName;

    private String   fileSize;

    private String   loader;

    private String   from;

    /**
     * @return
     */
    public FormFile getFile() {
        return file;
    }

    /**
     * @param file
     */
    public void setFile(FormFile file) {
        this.file = file;
    }

    /**
     * @return
     */
    public String getFileName() {
        return fileName;
    }

    /**
     * @param string
     */
    public void setFileName(String string) {
        fileName = string;
    }

    /**
     * @return
     */
    public String getFileSize() {
        return fileSize;
    }

    /**
     * @param string
     */
    public void setFileSize(String string) {
        fileSize = string;
    }

    /**
     * @return
     */
    public String getLoader() {
        return loader;
    }

    /**
     * @param string
     */
    public void setLoader(String string) {
        loader = string;
    }

    /**
     * @return
     */
    public String getFrom() {
        return from;
    }

    /**
     * @param string
     */
    public void setFrom(String string) {
        from = string;
    }

}

