# dsw-reports

[![Gitter](https://img.shields.io/badge/chat-on%20telegram-blue.svg)](https://t.me/joinchat/FoZ4M0izfqpEvzDf1PKH3Q)

Addon for DeepSee Web which provides online reports and PDF emailing reports from InterSystems DeepSee dashboards

## Installing
1. Install last version [PhantomJS](http://phantomjs.org/download.html) 
2. Install last versions [MDX2JSON](https://github.com/intersystems-ru/Cache-MDX2JSON) and [DeepSeeWeb](https://github.com/intersystems-ru/DeepSeeWeb).
3. Import classes from repo (*src/cls/*)
4. Move folger **"reports"** from repo (*src/web/*) to DeepSeeWeb application directory.
5. Configure **DSW.Reports**:
   1. Open class DSW.Reports.Task and configure parameters.
   2. Set parameter **HEADLESS**. It's path to PhantomJS binary, or "phantomjs" command if binaries included to PATH.
   3. Set parameter **DSWAPPLICATION**. It's name of DeepSeeWeb application.
   4. Set parameter **SCRIPTPATH**. It's path to rasterize.js file. Default: 
   `{DSWApp}/reports/rasterize/rasterize.js`.
   5. Set parameter **HOSTNAME**. It's hostname of your server.
6. Configure SMTP server:  
**server** - your SMTP server hostname.  
**port** - port for outgoing messages on your SMTP server.  
**username** and **password** - your authentication data.  
**sender** - your email address.  
**SSLConfig** - *Optional*. Set name of your SSL Configuration.
`do ##class(DSW.Report.EmailSender).setConfig(server, port, username, password, sender, SSLConfig)`
7. Manage recipients: `do ##class(DSW.Report.EmailSender).addRecipient(email)` or 
`do ##class(DSW.Report.EmailSender).deleteRecipient(email)`.
8. Run report's task:  
**url** - link to your report.  
**reportname** - name of your report.  
`do ##class(DSW.Reports.Task).Run(url, reportname)`


## Run example
1. Import example from repo (*example/*). 
2. Run example's setup. `do ##class(RF.KHAB.Utils).Setup()`
3. Check example: `<yourhost:port>/dsw/reports/example/index.html`
4. Run report's task:
`do ##class(DSW.Reports.Task).Run("<yourhost:port>/dsw/reports/example/index.html", "example")`
