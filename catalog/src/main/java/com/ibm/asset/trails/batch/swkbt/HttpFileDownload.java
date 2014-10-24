package com.ibm.asset.trails.batch.swkbt;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.HttpResponseException;
import org.apache.http.client.methods.HttpGet;

public class HttpFileDownload {

	private final HttpClient httpClient;
	private final String localFileName;
	private final String localDownloadDirectory;
	private final String uri;

	public HttpFileDownload(HttpClient httpClient, String localFileName,
			String localDownloadDirectory, String uri)
			throws FileNotFoundException {
		checkConstructorForNull(httpClient, localFileName,
				localDownloadDirectory, uri);
		checkDirectory(localDownloadDirectory);
		this.httpClient = httpClient;
		this.localFileName = localFileName;
		this.localDownloadDirectory = localDownloadDirectory;
		this.uri = uri;
	}

	public void execute() throws ClientProtocolException, IOException {
		HttpResponse response = getResponse();
		HttpEntity entity = response.getEntity();
		InputStream inputStream = entity.getContent();
		OutputStream outputStream = new FileOutputStream(localDownloadDirectory
				+ "/" + localFileName);
		try {
			download(inputStream, outputStream);
		} finally {
			if (inputStream != null)
				inputStream.close();
			if (outputStream != null)
				outputStream.close();
			entity.consumeContent();
		}
	}

	private void download(InputStream inputStream, OutputStream outputStream)
			throws IOException {
		byte[] tmp = new byte[4096];
		int l;
		while ((l = inputStream.read(tmp)) != -1) {
			outputStream.write(tmp, 0, l);
		}
		outputStream.flush();
	}

	private HttpResponse getResponse() throws ClientProtocolException,
			IOException {
		HttpGet httpGet = new HttpGet(uri);
		HttpResponse response = httpClient.execute(httpGet);
		if (response.getStatusLine().getStatusCode() != HttpStatus.SC_OK) {
			throw new HttpResponseException(response.getStatusLine()
					.getStatusCode(), response.getStatusLine().getStatusCode()
					+ " " + response.getStatusLine().getReasonPhrase());
		}
		return response;
	}

	private void checkConstructorForNull(HttpClient httpClient,
			String fileName, String downloadDirectory, String uri) {
		if (httpClient == null)
			throw new IllegalArgumentException("httpClient is null");
		if (fileName == null)
			throw new IllegalArgumentException("fileName is null");
		if (downloadDirectory == null)
			throw new IllegalArgumentException("downloadDirectory is null");
		if (uri == null)
			throw new IllegalArgumentException("uri is null");
	}

	private void checkDirectory(String localDownloadDirectory)
			throws FileNotFoundException {
		if (!new File(localDownloadDirectory).exists())
			throw new FileNotFoundException(
					"localDownloadDirectory does not exist");
	}

	public ArrayList<String> getFileAsArrayList() throws IllegalStateException,
			IOException {
		HttpResponse response = getResponse();
		HttpEntity entity = response.getEntity();
		InputStream inputStream = entity.getContent();
		SimpleInputStreamReader sisr = new SimpleInputStreamReader(inputStream);
		return sisr.inputStreamAsArrayList();
	}
}
