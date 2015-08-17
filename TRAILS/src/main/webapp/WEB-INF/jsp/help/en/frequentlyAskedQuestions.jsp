<!-- start help doc -->

<p><a href="#_What_is_TRAILS">What is TRAILS?</a></p>

<p />

<p><a href="#_Where_did_the">Where did the data in TRAILS come
from?</a></p>

<p />

<p><a href="#_How_is_data">How is data loaded into TRAILS?</a></p>

<p />

<p><a href="#_What_are_Alerts">What are Alerts?</a></p>

<p />

<p><a href="#_How_is_the">How is the age of the alert
calculated?</a></p>

<p />

<p><a href="#_How_is_asset">How is asset management involved in
the tool?</a></p>

<p />

<p><a href="#_How_can_I">How can I access TRAILS?</a></p>

<p />

<p><a href="#_Can_TRAILS_data">Can TRAILS data be distributed
externally?</a></p>

<p />

<p><a href="#_Where_can_I">Where can I go to obtain education
on TRAILS?</a></p>

<p />

<h3><a name="_What_is_TRAILS"></a>What is TRAILS?</h3>

<p>The Reconciliation And Inventory of Licensed Software
(TRAILS) tool is a Web-based asset management tool that compares installed
software to software licenses to manage software license compliance. TRAILS 4.0
provides a continuous reconciliation engine that shows the current software
license management posture for each in-scope account, through an alert-based
variance management system.</p>

<h3><a name="_Where_did_the"></a>Where did the data in TRAILS come from?</h3>

<p>Account information comes directly from the asset management
Customer Number Database (CNDB). Installed software data and hardware data is
provided through a load from BRAVO. License data is provided through a load
from SoftReq and/or SWCM. </p>

<h3><a name="_How_is_data"></a>How is data loaded into TRAILS?</h3>

<p>All account and asset data is automatically fed in to the
system from CNDB, BRAVO, SoftReq, and SWCM. This happens through continuous
delta loads from the source systems within a 24 hour turnaround of a change.
This loading process generates the alerts for an account.</p>

<h3><a name="_What_are_Alerts"></a>What are Alerts?</h3>

<p>TRAILS 4.0 is an alert-based variance management system. An
alert in TRAILS is a flagged variance between the account's current data and desired
state. All alerts are tracked based on their age in order to show severity of
the variance. Six total alerts are possible within the TRAILS tool to cover the
tracked variances.</p>
<ul>
	<li>
		HW w/o HW LPAR: This is a hardware record without hostname; more
		specifically, a hardware asset record without an assigned logical partition
		name (hostname).
	</li>
	<li>
		HW LPAR w/o SW LPAR: This is hardware with a hostname, but without a scan;
		more specifically, a hardware asset record with an assigned logical
		partition name (hostname) that does not have associated active installed
		software from a scan or from a manual upload of installed software.
	</li>
	<li>
		SW LPAR w/o HW LPAR: This is a scan not matched to hardware; more
		specifically, a set of active installed software, provided by a scan or a
		manual upload of installed software that is not tied to a logical partition
		name from a hardware record.
	</li>
	<li>
		Outdated SW LPAR: This is an expired scan. More specifically, it is a set of
		installed software products, provided by a scan or a manual upload of
		installed software that has a scan date older than allowed for this account,
		based on the CNDB scan validity field.
	</li>
	<li>
		Unlicensed IBM SW: This is an IBM software discrepancy. More specifically,
		it is an installed software product developed by IBM that currently does not
		have a license assigned to it or has not had a manual reconciliation action
		applied to close the discrepancy.
	</li>
	<li>
		Unlicensed ISV SW: This is an ISV software discrepancy. More specifically,
		it is an installed software product developed by an independent software
		vendor (ISV) that currently does not have a license assigned to it or has
		not had a manual reconciliation action applied to close the discrepancy.
	</li>
</ul>

<p />

<h3><a name="_How_is_the"></a>How is the age of the alert calculated?</h3>

<p>For the HW w/o HW LPAR, HW LPAR w/o SW LPAR, and SW LPAR w/o
HW LPAR alert types, the age of the alert is calculated using the date that the
alert was generated in the system (created date). Initially the age of the
alert is calculated based on the date that TRAILS v4.0 was released. In the
future, the age is calculated using the date that the asset was added to the
system.</p>

<p />

<p>For the Outdated SW LPAR alert type, the age of the alert is
calculated using the scan time and the scan validity days from the Customer
Number Database for the account. This identifies when the scan expires and the
age is calculated from the date of expiration.</p>

<p />

<h3><a name="_How_is_asset"></a>How is asset management involved in the tool?</h3>

<p>Asset management is responsible for monitoring the compliance
management system and driving the closure of alerts generated for their accounts.
This includes: </p>

<p>- The validation of accounts and the associated data,
including scope status, in the customer number database </p>

<p>- Validation of hardware asset information and corrections
made in the source system </p>

<p>- Validation of software scans and installed software asset
information and corrections made in the source system </p>

<p>- Validation of software license information and corrections
made in the source system </p>

<p>- Evaluation and closure of all discrepancies to ensure good
audit posture</p>

<h3><a name="_How_can_I"></a>How can I access TRAILS? </h3>

<p>There are two types of access; read and administrative
access. By default, the Asset Management community has read access. If you are
outside this group and need either read or administrative access, contact your
Asset Management Focal to request access on your behalf.  </p>

<h3><a name="_Can_TRAILS_data"></a>Can TRAILS data be distributed externally? </h3>

<p>TRAILS data should only be provided to the appropriate
members of the account teams and within the asset management group. If required
per the customer contract, data can be provided to a customer after it has been
approved by asset management and the account team lead.</p>

<h3><a name="_Where_can_I"></a>Where can I go to obtain education on TRAILS? </h3>

<p>Education for TRAILS can be found on the home page of TRAILS
under Help Documentation. Additionally, please see your asset management focal,
team lead, or manager for education.</p>

		<hr/>
<!-- end help doc -->