<!-- NAVIGATION_BEGIN -->
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<div id="ibm-navigation">
	<h2 class="ibm-access">Content navigation</h2>
	<tiles:useAttribute name="menu" classname="java.util.HashMap" scope="request" />
	<tiles:useAttribute name="swTrackingAccountFlag" classname="java.lang.Boolean" scope="request" />
	
	<!-- Navigation for SW tracking only accounts -->
	<s:if test='#request.swTrackingAccountFlag'>
		<ul id='ibm-primary-links'>
			<s:iterator value='#request.menu'>
				<s:url id="firstLevelUrl" value="%{key.link}" includeParams="none" />
				
				<!-- Hiden admin section -->
				<s:if test='key.link == "/admin/home.htm"'></s:if>
				
				<!-- Create first level menu -->
				<s:else>
					<s:if test='key.link=="/"'>
						<li id="ibm-overview"><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a></li>
					</s:if>
					<s:elseif test='key.Tooltip=="active" || key.Tooltip=="open"'>
						<li class="ibm-active"><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a>
							<ul>
								<s:iterator value="#request.menu.get(key)">
									<s:url id="secondLevelUrl" value="%{key.link}" includeParams="none" />
				
									<!-- Hiden license base line section && Reconciliation section -->
									<s:if test='key.link == "/account/license/license.htm" || key.link == "/account/recon/home.htm"'></s:if>
									
									<!-- Create second level menu -->
									<s:else>
										<s:if test='key.Tooltip=="active" || key.Tooltip=="open"'>
											<li class="ibm-active"><s:a href='%{secondLevelUrl}'><s:property value='key.value'/></s:a>
												<ul>
													<s:iterator value="value">
														<s:url id="thirdLevelUrl" value="%{link}" includeParams="none" />
														
														<!-- Hiden SOM3,SOM4a,SOM4b,SOM4c, HW BOX NO PROCESSOR,HW BOX NO CHIP,
														 HW LPAR NO PROCESSOR TYPE, HW LPAR NO CPU MODEL-->
														<s:if test='link == "/account/alerts/alertWithDefinedContractScope.htm" 
															|| link == "/account/alerts/alertIbmSwInstancesReviewed.htm"
															|| link == "/account/alerts/alertPriorityIsvSwInstancesReviewed.htm"
															|| link == "/account/alerts/alertIsvSwInstancesReviewed.htm"
															|| link == "/account/exceptions/lparHWNPRC.htm"
															|| link == "/account/exceptions/lparHWNCHP.htm"
															|| link == "/account/exceptions/lparNPRCTYP.htm"
															|| link == "/account/exceptions/lparNCPMDL.htm"'>
														</s:if>
														<!-- Create third level menu -->
														<s:else>
															<s:if test='Tooltip=="active" || Tooltip=="open"'>
																<li class="ibm-active"><s:a href='%{thirdLevelUrl}'><s:property value='value'/></s:a></li>
															</s:if>
															<s:else>
																<li><s:a href='%{thirdLevelUrl}'><s:property value='value'/></s:a></li>
															</s:else>
														</s:else>
													</s:iterator>
												</ul>
											</li>
										</s:if>
										<s:else>
											<li><s:a href='%{secondLevelUrl}'><s:property value='key.value'/></s:a></li>
										</s:else>
									</s:else>
								</s:iterator>
							</ul>
						</li>
					</s:elseif>
					<s:else>
						<li><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a></li>
					</s:else>
				</s:else>
			</s:iterator>
		</ul>
	</s:if>
	<!-- ./Navigation for SW tracking only accounts  -->
	
	
	
	<!-- Navigation for Non SW tracking only accounts -->
	<s:else>
		<ul id='ibm-primary-links'>
			<s:iterator value='#request.menu'>
				<s:url id="firstLevelUrl" value="%{key.link}" includeParams="none" />
				
				<!-- Create first level menu -->
				<s:if test='key.link=="/"'>
					<li id="ibm-overview"><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a></li>
				</s:if>
				<s:elseif test='key.Tooltip=="active" || key.Tooltip=="open"'>
					<li class="ibm-active"><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a>
						<ul>
							<s:iterator value="#request.menu.get(key)">
								<s:url id="secondLevelUrl" value="%{key.link}" includeParams="none" />
								
								<!-- Create second level menu -->
								<s:if test='key.Tooltip=="active" || key.Tooltip=="open"'>
									<li class="ibm-active"><s:a href='%{secondLevelUrl}'><s:property value='key.value'/></s:a>
										<ul>
											<s:iterator value="value">
												<s:url id="thirdLevelUrl" value="%{link}" includeParams="none" />
												
												<!-- Create third level menu -->
												<s:if test='Tooltip=="active" || Tooltip=="open"'>
													<li class="ibm-active"><s:a href='%{thirdLevelUrl}'><s:property value='value'/></s:a></li>
												</s:if>
												<s:else>
													<li><s:a href='%{thirdLevelUrl}'><s:property value='value'/></s:a></li>
												</s:else>
											</s:iterator>
										</ul>
									</li>
								</s:if>
								<s:else>
									<li><s:a href='%{secondLevelUrl}'><s:property value='key.value'/></s:a></li>
								</s:else>
							</s:iterator>
						</ul>
					</li>
				</s:elseif>
				<s:else>
					<li><s:a href='%{firstLevelUrl}'><s:property value='key.value'/></s:a></li>
				</s:else>
			</s:iterator>
		</ul>	
	</s:else>
	<!-- ./Navigation for Non SW tracking only accounts -->
</div>
<!-- NAVIGATION_END -->
