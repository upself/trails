package com.ibm.ea.common.help;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.tiles.locale.impl.DefaultLocaleResolver;

import com.ibm.asset.trails.action.BaseActionWithSession;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Preparable;

public class HelpAction extends BaseActionWithSession implements Preparable,
		ServletResponseAware {

	private static final long serialVersionUID = 1L;

	private Map<String, String> languageDropDown;

	private String language;

	private HttpServletResponse response;

	private String request_locale;

	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {

		if (request_locale == null) {
			if (getSession().get(DefaultLocaleResolver.LOCALE_KEY) == null) {
				// no form submit, nothing in session
				language = this.getLocale().getLanguage();
				request_locale = language;
				getSession().put(DefaultLocaleResolver.LOCALE_KEY, new Locale(language));
			} else {
				language = ((Locale) getSession().get(DefaultLocaleResolver.LOCALE_KEY))
						.getLanguage();
				request_locale = language;
			}
		} else {
			language = request_locale;
			getSession().put(DefaultLocaleResolver.LOCALE_KEY, new Locale(language));
		}

		languageDropDown = new HashMap<String, String>();
		languageDropDown.put("en", this.getText("en"));
		// languageDropDown.put("es-419", this.getText("es-419"));
		// languageDropDown.put("ja", this.getText("ja"));
		// languageDropDown.put("ko", this.getText("ko"));
		// languageDropDown.put("th", this.getText("th"));
		// languageDropDown.put("zh-hans", this.getText("zh-hans"));
		// languageDropDown.put("zh-hant", this.getText("zh-hant"));

		response.setCharacterEncoding("utf-8");
	}

	@UserRole(userRole = UserRoleType.READER)
	public String home() {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String userGuide() {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String faq() {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String admin() {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	public String onPageRef() {
		return SUCCESS;
	}

	public Map<String, String> getLanguageDropDown() {
		return languageDropDown;
	}

	public void setLanguageDropDown(Map<String, String> languageDropDown) {
		this.languageDropDown = languageDropDown;
	}

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}

	public String getRequest_locale() {
		return request_locale;
	}

	public void setRequest_locale(String request_locale) {
		this.request_locale = request_locale;
	}

}