package com.ibm.asset.trails.action;

import java.io.File;

//TODO need to go verify user roles are properly set on all the actions
public class FileUploadAction extends BaseAction {

    private static final long serialVersionUID = 1L;

    private transient File upload;

    private String uploadContentType;

    private String uploadFileName;

    @Override
    public String execute() throws Exception {
        return SUCCESS;
    }

    public File getUpload() {
        return upload;
    }

    public void setUpload(File upload) {
        this.upload = upload;
    }

    public String getUploadContentType() {
        return uploadContentType;
    }

    public void setUploadContentType(String uploadContentType) {
        this.uploadContentType = uploadContentType;
    }

    public String getUploadFileName() {
        return uploadFileName;
    }

    public void setUploadFileName(String uploadFileName) {
        this.uploadFileName = uploadFileName;
    }

}
