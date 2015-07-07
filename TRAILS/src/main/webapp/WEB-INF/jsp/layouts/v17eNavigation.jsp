<!-- NAVIGATION_BEGIN -->
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<div id="ibm-navigation">
	<h2 class="ibm-access">Content navigation</h2>
	<tiles:useAttribute name="menu" classname="java.util.HashMap"
		scope="request" />
	<ul id="ibm-primary-links">
		<s:iterator value="#request.menu">
			<s:url id="oneUrl" value="%{key.link}" includeParams="none" />
			<s:if test='key.link=="/"'>
				<li id="ibm-overview">
			</s:if>
			<s:else>
				<s:if test='key.Tooltip==""'>
					<li>
				</s:if>
				<s:else>
					<li class="ibm-active">
				</s:else>
			</s:else>
			<s:a href="%{oneUrl}">
				<s:property value="%{key.value}" />
			</s:a>
			<s:if test="key.Tooltip=='active' || key.Tooltip=='open'">
				<ul>
					<s:iterator value="#request.menu.get(key)">
						<s:url id="twoUrl" value="%{key.link}" includeParams="none" />
						<s:if test='key.Tooltip=="active"'>
							<li class="ibm-active"><s:a href="%{twoUrl}"
									cssClass="ibm-active">
									<s:property value="%{key.value}" />
								</s:a>
						</s:if>
						<s:else>
							<li><s:a href="%{twoUrl}">
									<s:property value="%{key.value}" />
								</s:a>
						</s:else>


						<s:if test="key.Tooltip=='active' || key.Tooltip=='open'">
							<ul>
								<s:iterator value="value">
									<s:url id="threeUrl" value="%{link}" includeParams="none" />
									<s:if test='tooltip=="active"'>
										<li class="ibm-active"><s:a href="%{threeUrl}"
												cssClass="ibm-active">
												<s:property value="%{value}" />
											</s:a>
									</s:if>
									<s:else>
										<li><s:a href="%{threeUrl}">
												<s:property value="%{value}" />
											</s:a>
									</s:else>

									</li>
								</s:iterator>
							</ul>
						</s:if>
						</li>
					</s:iterator>
				</ul>
			</s:if>
			</li>
		</s:iterator>
	</ul>
</div>
<!-- NAVIGATION_END -->
