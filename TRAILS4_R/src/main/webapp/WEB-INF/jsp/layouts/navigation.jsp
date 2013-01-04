<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<tiles:useAttribute name="menu" classname="java.util.HashMap"
	scope="request" />
<s:iterator value="#request.menu">
	<s:url id="oneUrl" value="%{key.link}" includeParams="none" />
	<s:if test='key.link=="/"'>
		<s:if test='key.Tooltip==""'>
			<s:a href="%{oneUrl}" id="site-home">
				<s:property value="%{key.value}" />
			</s:a>
		</s:if>
		<s:else>
			<s:a href="%{oneUrl}" cssClass="%{key.Tooltip}" id="site-home">
				<s:property value="%{key.value}" />
			</s:a>
		</s:else>
	</s:if>
	<s:else>
		<s:if test='key.Tooltip==""'>
			<s:a href="%{oneUrl}">
				<s:property value="%{key.value}" />
			</s:a>
		</s:if>
		<s:else>
			<s:a href="%{oneUrl}" cssClass="%{key.Tooltip}">
				<s:property value="%{key.value}" />
			</s:a>
		</s:else>
	</s:else>
	<s:if test="key.Tooltip=='active' || key.Tooltip=='open'">
		<div class="second-level"><s:iterator
			value="#request.menu.get(key)">

			<s:if test="key.icon=='true'">
				<s:url id="twoUrl" value="%{key.link}" includeParams="none" />
				<s:if test='key.Tooltip==""'>
					<s:a href="%{twoUrl}">
						<s:property value="%{key.value}" />
					</s:a>
				</s:if>
				<s:else>
					<s:a href="%{twoUrl}" cssClass="%{key.Tooltip}">
						<s:property value="%{key.value}" />
					</s:a>
				</s:else>
			</s:if>
			<s:else>
				<s:url id="twoUrl" value="%{key.link}" includeParams="none" />
				<s:if test='key.Tooltip==""'>
					<s:a href="%{twoUrl}">
						<s:property value="%{key.value}" />
					</s:a>
				</s:if>
				<s:else>
					<s:a href="%{twoUrl}" cssClass="%{key.Tooltip}">
						<s:property value="%{key.value}" />
					</s:a>
				</s:else>
			</s:else>

			<s:if test="key.Tooltip=='active' || key.Tooltip=='open'">
				<div class="third-level"><s:iterator value="value">
					<s:url id="threeUrl" value="%{link}" includeParams="none" />
					<s:if test='tooltip==""'>
						<s:a href="%{threeUrl}">
							<s:property value="%{value}" />
						</s:a>
					</s:if>
					<s:else>
						<s:a href="%{threeUrl}" cssClass="%{tooltip}">
							<s:property value="%{value}" />
						</s:a>
					</s:else>
				</s:iterator></div>
			</s:if>
		</s:iterator></div>
	</s:if>
</s:iterator>
