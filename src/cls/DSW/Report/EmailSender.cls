Class DSW.Report.EmailSender [ Abstract ]
{

Parameter SLASH = {$case($system.Version.GetOS(),"Windows":"\",:"/")};

ClassMethod gln(dir = "config") [ CodeMode = expression, Private ]
{
"^DSW.Report.SMTP."_dir
}

ClassMethod setSMTPServer(server, port)
{
	set gln = ..gln("config")
	set @gln@("server") = server
	set @gln@("port") = port
}

ClassMethod setEmailSender(sender)
{
	set gln = ..gln("config")
	set @gln@("sender") = sender
}

ClassMethod setAuthConfiguration(username, password = "")
{
	set gln = ..gln("config")
	set @gln@("username") = username
	set @gln@("password") = password
}

ClassMethod setConfig(server, port, username, password, sender)
{
	do ..setSMTPServer(server, port)
	do ..setAuthConfiguration(username, password)
	do ..setEmailSender(sender)
}

ClassMethod addRecipient(recipient)
{
	set gln = ..gln("recipients")
	set tRicipient = $zcvt(recipient, "L")
	
	if ('$data(@gln@(tRicipient))) {
		set @gln@(tRicipient) = ""
		w "Recipient "_recipient_" was added.", !
	} else {
		w "Recipient "_recipient_" recently added.", !
	}
}

ClassMethod deleteRecipient(recipient)
{
	set gln = ..gln("recipients")
	set tRicipient = $zcvt(recipient, "L")
	
	if ($data(@gln@(tRicipient))) {
		k @gln@(tRicipient)
		w "Recipient "_recipient_" was deleted.", !
	} else {
		w "Recipient "_recipient_" dos not exist.", !
	}
}

ClassMethod sendEmail(mailSubject = "", mailText = "", attachPath = "") As %Status
{
	set sc = $$$OK
	set glnSMTP = ..gln("config")
	
	set sc = ..checkSMTPConfiguration(glnSMTP)
	return:$$$ISERR(sc) sc
	
	set Mailer = ##class(%Net.SMTP).%New()
    set Mailer.smtpserver = @glnSMTP@("server")
    set Mailer.port = @glnSMTP@("port")
    Set Mailer.SSLConfiguration = "EmailDefault"
    
    set Auth=##class(%Net.Authenticator).%New() ; use default authentication list
	set Auth.UserName=@glnSMTP@("username")
	set Auth.Password=@glnSMTP@("password")
	set Mailer.authenticator=Auth
    
    set Msg = ##class(%Net.MailMessage).%New()

    set Msg.From = @glnSMTP@("sender")
    set Msg.Sender = @glnSMTP@("sender")

	set glnRecipients = ..gln("recipients")
	set tRecipient = $order(@glnRecipients@(""))
	
	while (tRecipient '= "") {
    	do Msg.To.Insert(tRecipient)
    	set tRecipient = $order(@glnRecipients@(tRecipient))
	}
    
    set Msg.Subject = mailSubject
    do Msg.TextData.Write(mailText)
    
    if (attachPath '= "") {
	    set dirChain = $piece(attachPath,..#SLASH, 1, * - 1)_..#SLASH
	    set file = $piece(attachPath,..#SLASH, *)
	    
	    set sc = Msg.AttachFile(dirChain, file)
	    return:$$$ISERR(sc) sc
	}

    set sc = Mailer.Send(Msg)
    do Mailer.%Close()
    do Msg.%Close()
    
    return sc
}

ClassMethod checkSMTPConfiguration(configGlobal = {..gln("config")}) As %Status [ Private ]
{
	set sc = $$$OK
	
	if ('$data(@configGlobal@("server"))) || ('$data(@configGlobal@("port"))) {
		return $$$ERROR(5001, "Please set SMTP server or port to configuration")
	}
	
	if '$data(@configGlobal@("sender")) {
		return $$$ERROR(5001, "Please set Email Sender to configuration")
	}
	
	if ('$data(@configGlobal@("username"))) || ('$data(@configGlobal@("password"))) {
		return $$$ERROR(5001, "Please set Auth Configuration (username, password)")
	}
	
	return sc
}

}

