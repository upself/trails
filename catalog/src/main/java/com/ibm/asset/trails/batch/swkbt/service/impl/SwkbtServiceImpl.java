package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import java.util.zip.ZipInputStream;

import javax.xml.bind.JAXBException;
import javax.xml.stream.XMLStreamException;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.batch.swkbt.HttpFileDownload;
import com.ibm.asset.trails.batch.swkbt.SslHttpClient;
import com.ibm.asset.trails.batch.swkbt.SwkbtException;
import com.ibm.asset.trails.batch.swkbt.service.FileTransferService;
import com.ibm.asset.trails.batch.swkbt.service.SwkbtService;
import com.ibm.asset.trails.dao.RelationshipDao;

@Service
public class SwkbtServiceImpl implements SwkbtService {

	@Autowired
	private SslHttpClient httpClient;
	private Properties properties = new Properties();
	private String guid;
	@Value("${localDownloadDir}")
	private String localDownloadDir;
	@Value("${deltaFileName}")
	private String deltaFileName;
	@Value("${fullFileName}")
	private String fullFileName;
	private Date startDate;
	private Date endDate;
	@Value("${baseUri}")
	private String baseUri;
	@Value("${scheduleCanonical}")
	private String scheduleCanonical;
	@Value("${statusCanonical}")
	private String statusCanonical;
	@Value("${downloadCanonical}")
	private String downloadCanonical;
	@Value("${deltaSubtraction}")
	private String deltaSubtraction;
  //@Autowired
  //private RelationshipDao kbDao;
	
		private static final Logger logger = Logger
			.getLogger(SwkbtServiceImpl.class);


	public boolean daily() throws FileNotFoundException, XMLStreamException,
			JAXBException, IOException, SwkbtException, InterruptedException {
		processCanonical(true, false);
		return true;
	}

	public boolean weekly() throws FileNotFoundException, XMLStreamException,
			JAXBException, IOException, SwkbtException, InterruptedException {
		processCanonical(false, false);
		return true;
	}

	public void processCanonical(boolean delta, boolean reload)
			throws FileNotFoundException, XMLStreamException, JAXBException,
			IOException, SwkbtException, InterruptedException {
		logger.debug("Trying to get canonical");
		requestCanonical(delta);
		statusCanonical();
		downloadCanonical(delta);
	}

	private void requestCanonical(boolean delta) throws FileNotFoundException,
			SwkbtException, InterruptedException {
		HttpFileDownload httpFileDownload = new HttpFileDownload(httpClient,
				SwkbtService.REQUEST_PROPS, SwkbtService.PROPERTIES_DIR,
				getRequestUri(delta));
		if (!retrieveRequestStatus(httpFileDownload)) {
			logger.debug("Export not accepted by SWKBT");
			throw new SwkbtException("Export not accepted by SWKBT");
		}
		setGuid(properties.getProperty("guid"));
	}

	private void downloadCanonical(boolean delta) throws SwkbtException,
			InterruptedException, IOException {
		HttpFileDownload httpFileDownload = new HttpFileDownload(httpClient,
				getDownloadFileName(delta), localDownloadDir,
				getDownloadUri(guid));
		int count = 0;
		boolean downloaded = false;
		while (!downloaded && count <= SwkbtService.REQUEST_TRIES) {
			try {
				httpFileDownload.execute();
				downloaded = true;
			} catch (Exception e) {
				if (count == SwkbtService.REQUEST_TRIES) {
					throw new SwkbtException(e);
				}
				count++;
			}
			Thread.sleep(600000);
		}
		unzip(localDownloadDir + "/" + getDownloadFileName(delta));
		logger.debug("unzipped file");
		move(localDownloadDir + "/CANONICAL.xml", localDownloadDir
				+ "/unzipped/CANONICAL.xml");
		logger.debug("moved file to processing directory");
	}

	private void move(String source, String destination) {
		File file = new File(source);
		file.renameTo(new File(destination));
	}

	private void unzip(String zipFile) throws IOException {
		BufferedOutputStream dest = null;
		FileInputStream fis = new FileInputStream(zipFile);
		ZipInputStream zis = new ZipInputStream(new BufferedInputStream(fis));
		while (zis.getNextEntry() != null) {
			int count;
			byte data[] = new byte[2048];
			// write the files to the disk
			FileOutputStream fos = new FileOutputStream(localDownloadDir
					+ "/CANONICAL.xml");
			dest = new BufferedOutputStream(fos, 2048);
			while ((count = zis.read(data, 0, 2048)) != -1) {
				dest.write(data, 0, count);
			}
			dest.flush();
			dest.close();
		}
		zis.close();
	}

	private String getDownloadFileName(boolean delta) {
		if (delta) {
			return deltaFileName;
		}
		return fullFileName;
	}

	private void statusCanonical() throws FileNotFoundException,
			SwkbtException, InterruptedException {
		HttpFileDownload httpFileDownload = new HttpFileDownload(httpClient,
				SwkbtService.STATUS_PROPS, SwkbtService.PROPERTIES_DIR,
				getStatusUri(guid));
		if (!retrieveExportStatus(httpFileDownload)) {
			logger.debug("Issue with status -- Apparent SWKBT application problem");
			throw new SwkbtException(
					"Apparent SWKBT application problem: Status error.");
		}
	}

	private boolean retrieveExportStatus(HttpFileDownload httpFileDownload)
			throws SwkbtException, InterruptedException {
		int count = 0;
		boolean ready = false;
		while (!ready && count <= SwkbtService.REQUEST_TRIES) {
			try {
				httpFileDownload.execute();
				loadProperties(PROPERTIES_DIR + "/" + SwkbtService.STATUS_PROPS);
				if (properties.getProperty("status").equals("error")
						|| properties.getProperty("status").equals("not_found")) {
					return ready;
				} else if (properties.getProperty("status").equals("ready")) {
					return true;
				}
			} catch (Exception e) {
				if (count == SwkbtService.REQUEST_TRIES) {
					throw new SwkbtException(e);
				}
				count++;
			}
			Thread.sleep(600000);
		}
		return ready;
	}

	private String getDownloadUri(String guid) {
		return baseUri + "/" + downloadCanonical + guid;
	}

	private String getStatusUri(String guid) {
		return baseUri + "/" + statusCanonical + guid;
	}

	private boolean retrieveRequestStatus(HttpFileDownload httpFileDownload)
			throws InterruptedException, SwkbtException {
		int count = 0;
		boolean exportAccepted = false;
		while (!exportAccepted && count <= SwkbtService.REQUEST_TRIES) {
			try {
				httpFileDownload.execute();
				loadProperties(PROPERTIES_DIR + "/"
						+ SwkbtService.REQUEST_PROPS);
				return exportAccepted = new Boolean(
						properties.getProperty("export_accepted"))
						.booleanValue();
			} catch (Exception e) {
				if (count == SwkbtService.REQUEST_TRIES) {
					throw new SwkbtException(e);
				}
				count++;
			}
			Thread.sleep(300000);
		}
		return exportAccepted;
	}

	private void setGuid(String guid) {
		this.guid = guid;
	}

	private void loadProperties(String propertiesFile) throws IOException {
		InputStream inputStream = new FileInputStream(propertiesFile);
		properties.load(inputStream);
		inputStream.close();
	}

	private String getRequestUri(boolean delta) {
		if (delta) {
			setDeltaDates();
			checkDates();
			return baseUri + "/" + scheduleCanonical + "&start_date="
					+ getDateString(startDate) + "&end_date="
					+ getDateString(endDate);
		}
		return baseUri + "/" + scheduleCanonical;
	}

	private void checkDates() {
		if (startDate == null)
			throw new IllegalArgumentException("startDate is null");
		if (endDate == null)
			throw new IllegalArgumentException("endDate is null");
		if (startDate.after(endDate))
			throw new IllegalArgumentException("startDate is after endDate");
	}

	private String getDateString(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat(
				"yyyy-MM-dd'T'HH:mm:ss.S");
		return formatter.format(date);
	}

	private void setDeltaDates() {
		Calendar cal = Calendar.getInstance();
		int dSub = Integer.parseInt(deltaSubtraction);
		cal.add(Calendar.DATE, dSub);
		setStartDate(cal.getTime());
		setEndDate(new Date());
	}

	/**
	 * @param startDate
	 *            the startDate to set
	 */
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	/**
	 * @param endDate
	 *            the endDate to set
	 */
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	/**
	 * @param httpClient
	 *            the httpClient to set
	 */
	public void setHttpClient(SslHttpClient httpClient) {
		this.httpClient = httpClient;
	}

	/**
	 * @param ftService
	 *            the ftService to set
	 */
	public void setFtService(FileTransferService ftService) {
	}

	/**
	 * @param properties
	 *            the properties to set
	 */
	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	/**
	 * @param localDownloadDir
	 *            the localDownloadDir to set
	 */
	public void setLocalDownloadDir(String localDownloadDir) {
		this.localDownloadDir = localDownloadDir;
	}

	/**
	 * @param deltaFileName
	 *            the deltaFileName to set
	 */
	public void setDeltaFileName(String deltaFileName) {
		this.deltaFileName = deltaFileName;
	}

	/**
	 * @param fullFileName
	 *            the fullFileName to set
	 */
	public void setFullFileName(String fullFileName) {
		this.fullFileName = fullFileName;
	}

	/**
	 * @param baseUri
	 *            the baseUri to set
	 */
	public void setBaseUri(String baseUri) {
		this.baseUri = baseUri;
	}

	/**
	 * @param scheduleCanonical
	 *            the scheduleCanonical to set
	 */
	public void setScheduleCanonical(String scheduleCanonical) {
		this.scheduleCanonical = scheduleCanonical;
	}

	/**
	 * @param statusCanonical
	 *            the statusCanonical to set
	 */
	public void setStatusCanonical(String statusCanonical) {
		this.statusCanonical = statusCanonical;
	}

	/**
	 * @param downloadCanonical
	 *            the downloadCanonical to set
	 */
	public void setDownloadCanonical(String downloadCanonical) {
		this.downloadCanonical = downloadCanonical;
	}
}
