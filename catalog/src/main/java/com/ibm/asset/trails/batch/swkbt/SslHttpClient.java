package com.ibm.asset.trails.batch.swkbt;

import java.io.InputStream;
import java.security.KeyStore;

import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SslHttpClient extends DefaultHttpClient implements
		InitializingBean {

	@Autowired
	private InputStream certFileInputStream;
	@Value("${certFilePassword}")
	private String certFilePassword;
	@Value("${schemeName}")
	private String schemeName;
	@Value("${port}")
	private Integer port;

	public void destroy() {
		getConnectionManager().shutdown();
	}

	public void setCertFileInputStream(InputStream certFileInputStream) {
		this.certFileInputStream = certFileInputStream;
	}

	public void setCertFilePassword(String certFilePassword) {
		this.certFilePassword = certFilePassword;
	}

	public void setSchemeName(String schemeName) {
		this.schemeName = schemeName;
	}

	public void setPort(Integer port) {
		this.port = port;
	}

	public void afterPropertiesSet() throws Exception {
		KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
		try {
			trustStore
					.load(certFileInputStream, certFilePassword.toCharArray());
		} finally {
			certFileInputStream.close();
		}
		SSLSocketFactory socketFactory = new SSLSocketFactory(trustStore);
		Scheme sch = new Scheme(schemeName, socketFactory, port.intValue());
		getConnectionManager().getSchemeRegistry().register(sch);
	}
}
