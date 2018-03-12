from email.mime.text import MIMEText
msg = MIMEText('hello, send by Python...', 'plain', 'utf-8')


from_addr = "jie.chen@simright.com"
password = "cj_3460219"

smtp_server = "smtp.mxhichina.com"

to_addr = "woscj607@163.com"

import smtplib
server = smtplib.SMTP(smtp_server, 25)
# server.set_debuglevel(1)  **print some mutual information**
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()