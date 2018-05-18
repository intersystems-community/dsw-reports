Class DSW.Report.Task [ Abstract ]
{

Parameter SLASH = {$case($system.Version.GetOS(),"Windows":"\",:"/")};

/*Configuration*/
/// Path to PhantomJS binary, or "phantomjs" command if binaries included to PATH.
Parameter HEADLESS = "phantomjs";

/// Name of DeepSeeWeb application.
Parameter DSWAPPLICATION = "/dsw/";

/// Path to rasterize.js file. Default "{DSWApp}/reports/rasterize/rasterize.js".
Parameter SCRIPTPATH = {$system.CSP.GetFileName(..#DSWAPPLICATION)_"reports"
						_..#SLASH_"rasterize"_..#SLASH_"rasterize.js"};

/// Hostname of your server.
Parameter HOSTNAME = "http://127.0.0.1:57777/";

ClassMethod Run(url, reportname) As %Status
{
	set sc = $$$OK
	
	set subject = reportname_$c(95)_$p($zd($h, 9), " ", 1)_$c(95)_$p($zd($h, 9), " ", 3)
	set filename = ..getDestinationDir()_subject_".pdf"
						
	set sc = ..generatePDFReport(url, filename)
	if ($$$ISERR(sc)) return sc
	
	set docURL = ..#HOSTNAME_$p($system.CSP.FilenameToUrls(filename), "/", 2, *)
	
	set sc = ##class(EmailSender).sendEmail(subject, docURL, filename)	 
	
	return sc
}

ClassMethod generatePDFReport(url, filename) As %Status
{
	set sc = $$$OK
	
	set OSCommand = ..#HEADLESS_" """_..#SCRIPTPATH_""" """_url_""" """_filename_""""
	set sc = ##class(%Net.Remote.Utility).RunCommandViaZF(OSCommand)

	return sc
}

ClassMethod getDestinationDir() As %String [ Private ]
{
	
	set destDir = ..getReportFolder()_"files"_..#SLASH
	if ('##class(%File).Exists(destDir)) {
		set sc = ##class(%File).CreateDirectoryChain(destDir)
	}
	
	return destDir
}

ClassMethod getReportFolder() [ CodeMode = expression, Private ]
{
$system.CSP.GetFileName(..#DSWAPPLICATION)_"reports"_..#SLASH
}

}

