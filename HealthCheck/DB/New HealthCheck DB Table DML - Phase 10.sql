<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  
  


  <head>
    <title>
      New HealthCheck DB Table DML - Phase 10.sql on Ticket #436 – Attachment
     – swtools
    </title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--[if IE]><script type="text/javascript">
      if (/^#__msie303:/.test(window.location.hash))
        window.location.replace(window.location.hash.replace(/^#__msie303:/, '#'));
    </script><![endif]-->
        <link rel="search" href="/search" />
        <link rel="help" href="/wiki/TracGuide" />
        <link rel="alternate" href="/raw-attachment/ticket/436/New%20HealthCheck%20DB%20Table%20DML%20-%20Phase%2010.sql" type="text/x-sql; charset=iso-8859-15" title="Original Format" />
        <link rel="up" href="/ticket/436" title="Ticket #436" />
        <link rel="start" href="/wiki" />
        <link rel="stylesheet" href="/chrome/common/css/trac.css" type="text/css" /><link rel="stylesheet" href="/chrome/common/css/code.css" type="text/css" />
        <link rel="shortcut icon" href="/chrome/common/trac.ico" type="image/x-icon" />
        <link rel="icon" href="/chrome/common/trac.ico" type="image/x-icon" />
      <link type="application/opensearchdescription+xml" rel="search" href="/search/opensearch" title="Search swtools" />
    <script type="text/javascript" src="/chrome/common/js/jquery.js"></script><script type="text/javascript" src="/chrome/common/js/babel.js"></script><script type="text/javascript" src="/chrome/common/js/trac.js"></script><script type="text/javascript" src="/chrome/common/js/search.js"></script>
    <!--[if lt IE 7]>
    <script type="text/javascript" src="/chrome/common/js/ie_pre7_hacks.js"></script>
    <![endif]-->
      <script type="text/javascript" src="/chrome/common/js/folding.js"></script>
      <script type="text/javascript">
        jQuery(document).ready(function($) {
          $('#preview table.code').enableCollapsibleColumns($('#preview table.code thead th.content'));
        });
      </script>
  </head>
  <body>
    <div id="banner">
      <div id="header">
        <a id="logo" href="/wiki/TracIni#header_logo-section"><img src="/chrome/common/trac_banner.png" alt="(please configure the [header_logo] section in trac.ini)" /></a>
      </div>
      <form id="search" action="/search" method="get">
        <div>
          <label for="proj-search">Search:</label>
          <input type="text" id="proj-search" name="q" size="18" value="" />
          <input type="submit" value="Search" />
        </div>
      </form>
      <div id="metanav" class="nav">
    <ul>
      <li class="first">logged in as liuhaidl@cn.ibm.com</li><li><a href="/logout">Logout</a></li><li><a href="/prefs">Preferences</a></li><li><a href="/wiki/TracGuide">Help/Guide</a></li><li class="last"><a href="/about">About Trac</a></li>
    </ul>
  </div>
    </div>
    <div id="mainnav" class="nav">
    <ul>
      <li class="first"><a href="/wiki">Wiki</a></li><li><a href="/timeline">Timeline</a></li><li><a href="/roadmap">Roadmap</a></li><li><a href="/browser">Browse Source</a></li><li><a href="/report">View Tickets</a></li><li><a href="/newticket">New Ticket</a></li><li><a href="/search">Search</a></li><li class="last"><a href="/admin" title="Administration">Admin</a></li>
    </ul>
  </div>
    <div id="main">
      <div id="ctxtnav" class="nav">
        <h2>Context Navigation</h2>
          <ul>
              <li class="last first"><a href="/ticket/436">Back to Ticket #436</a></li>
          </ul>
        <hr />
      </div>
      <div id="warning" class="system-message">
          <strong>Warning:</strong>
          HTML preview using EnscriptRenderer failed (Exception: Running enscript failed with (127, sh: enscript: command not found), disabling EnscriptRenderer (command: 'enscript --color -h -q --language=html -p - -Esql'))
      </div>
    <div id="content" class="attachment">
        <h1><a href="/ticket/436">Ticket #436</a>: New HealthCheck DB Table DML - Phase 10.sql</h1>
        <table id="info" summary="Description">
          <tbody>
            <tr>
              <th scope="col">File New HealthCheck DB Table DML - Phase 10.sql,
                <span title="386 bytes">386 bytes</span>
                (added by liuhaidl@…, <a class="timeline" href="/timeline?from=2014-06-09T04%3A04%3A42-04%3A00&amp;precision=second" title="2014-06-09T04:04:42-04:00 in Timeline">3 months</a> ago)</th>
            </tr>
            <tr>
              <td class="message searchable">
                
              </td>
            </tr>
          </tbody>
        </table>
        <div id="preview" class="searchable">
          
  <table class="code"><thead><tr><th class="lineno" title="Line numbers">Line</th><th class="content"> </th></tr></thead><tbody><tr><th id="L1"><a href="#L1">1</a></th><td>--HealthCheck and Monitoring Service Component - Phase 10</td></tr><tr><th id="L2"><a href="#L2">2</a></th><td>--Recon Queues Duplicate Data Monitoring And Cleanup Event Type</td></tr><tr><th id="L3"><a href="#L3">3</a></th><td>INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(14,'RECON_QUEUES_DUPLICATE_DATA_MONITORING_AND_CLEANUP','Recon Queues Duplicate Data Monitoring And Cleanup Event Type for Database Monitoring Event Group',3);</td></tr><tr><th id="L4"><a href="#L4">4</a></th><td></td></tr><tr><th id="L5"><a href="#L5">5</a></th><td>COMMIT;</td></tr><tr><th id="L6"><a href="#L6">6</a></th><td>TERMINATE;</td></tr></tbody></table>

        </div>
          <div class="buttons">
            <form method="get" action="">
              <div id="delete">
                <input type="hidden" name="action" value="delete" />
                <input type="submit" value="Delete attachment" />
              </div>
            </form>
          </div>
    </div>
    <div id="altlinks">
      <h3>Download in other formats:</h3>
      <ul>
        <li class="last first">
          <a rel="nofollow" href="/raw-attachment/ticket/436/New%20HealthCheck%20DB%20Table%20DML%20-%20Phase%2010.sql">Original Format</a>
        </li>
      </ul>
    </div>
    </div>
    <div id="footer" lang="en" xml:lang="en"><hr />
      <a id="tracpowered" href="http://trac.edgewall.org/"><img src="/chrome/common/trac_logo_mini.png" height="30" width="107" alt="Trac Powered" /></a>
      <p class="left">Powered by <a href="/about"><strong>Trac 0.12.5</strong></a><br />
        By <a href="http://www.edgewall.org/">Edgewall Software</a>.</p>
      <p class="right">Visit the Trac open source project at<br /><a href="http://trac.edgewall.org/">http://trac.edgewall.org/</a></p>
    </div>
  </body>
</html>