/*
 * Created on Apr 1, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.batch;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.upload.FormFile;

import com.ibm.tap.misld.framework.Constants;

/**
 * @author alexmois
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class BatchFileLoader {

    public static Properties    properties = new Properties();

    private static final Logger logger     = Logger
                                                   .getLogger(BatchFileLoader.class);

    private String              dir;

    public BatchFileLoader() throws ServletException {

        logger.debug("Loading the initialization for BatchLoader");

        try {
            properties.load(new FileInputStream(Constants.CONF_DIR
                    + Constants.PROPERTIES));

        } catch (Exception e) {
            logger.error(e, e);
        }

        this.dir = properties.getProperty("workingDir");
    }

    public void loadBatch(String fname, FormFile file,
            HttpServletRequest request) throws FileNotFoundException,
            IOException {

        // -- From here below just copies the file to a standard location
        InputStream streamIn = file.getInputStream();
        OutputStream streamOut = new FileOutputStream(dir + fname);

        int bytesRead = 0;
        byte[] buffer = new byte[8192];

        logger.debug("writing to " + dir + fname);
        while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
            streamOut.write(buffer, 0, bytesRead);
        }

        streamOut.close();
        streamIn.close();
    }

    /**
     * @return Returns the dir.
     */
    public String getDir() {
        return dir;
    }

    /**
     * @param dir
     *            The dir to set.
     */
    public void setDir(String dir) {
        this.dir = dir;
    }
}