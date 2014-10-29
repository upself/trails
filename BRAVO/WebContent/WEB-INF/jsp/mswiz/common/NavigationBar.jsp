<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<!-- start navigation -->
<div id="navigation">
<h2 class="access">Start of left navigation</h2>
<!-- left nav -->

<div id="left-nav">

<div class="top-level"><logic:iterate id="linkOne" name="navigation">
	<a
		<logic:equal name="linkOne" property="active" value="true">
			class="active"
	</logic:equal>
		href="<bean:write name="linkOne" property="link"/>"> <bean:write
		name="linkOne" property="value" /></a>

	<logic:equal name="linkOne" property="open" value="true">
		<div class="second-level"><logic:iterate id="linkTwo" name="linkOne"
			property="children">
			<a
				<logic:equal name="linkTwo" property="active" value="true">
						class="active"
					</logic:equal>
				href="<bean:write name="linkTwo" property="link"/>"> <bean:write
				name="linkTwo" property="value" /></a>
			<logic:equal name="linkTwo" property="open" value="true">
				<div class="third-level"><logic:iterate id="linkThree"
					name="linkTwo" property="children">
					<a
						<logic:equal name="linkThree" property="active" value="true">
						class="active"
					</logic:equal>
						href="<bean:write name="linkThree" property="link"/>"> <bean:write
						name="linkThree" property="value" /></a>
				</logic:iterate></div>
			</logic:equal>
		</logic:iterate></div>

	</logic:equal>
</logic:iterate></div>
</div>

<!-- stop navigation -->