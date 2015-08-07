package com.ibm.ea.bravo.framework.common;

import java.io.File;
import java.io.FileInputStream;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import org.apache.log4j.Logger;

public abstract class SFTPUtil {
	
	private static final Logger logger = Logger.getLogger(SFTPUtil.class);
	
	public static boolean sftpFileAsci(String host, String id, String pw,
			String sourceDir, String sourceFile, String targetDir) {

		boolean success = false;
		success = SFTPUtil.sftpFile(host, id, pw, sourceDir, sourceFile,
				targetDir,22);
		return success;
	}

	private static boolean sftpFile(String host, String user, String password,
			String sourceDir, String sourceFile, String targetDir,int port) {

		logger.debug("host=" + host);
		logger.debug("port=" + port);
		logger.debug("user=" + user);
		logger.debug("sourceDir=" + sourceDir);
		logger.debug("sourceFile=" + sourceFile);
		logger.debug("targetDir=" + targetDir);

		Session     session     = null;
		Channel     channel     = null;
		ChannelSftp channelSftp = null;
		
		String FILETOTRANSFER = sourceDir + sourceFile;
		
		logger.debug("FILETOTRANSFER=" + FILETOTRANSFER);
		try{
            JSch jsch = new JSch();
            session = jsch.getSession(user,host,port);
            session.setPassword(password);
            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect();
            channel = session.openChannel("sftp");
            channel.connect();
            channelSftp = (ChannelSftp)channel;
            channelSftp.cd(targetDir);
            File f = new File(FILETOTRANSFER);
            channelSftp.put(new FileInputStream(f), f.getName());
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return true;
	}

}
