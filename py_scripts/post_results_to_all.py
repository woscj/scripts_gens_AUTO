from email.mime.text import MIMEText
from email.header import Header
from email import encoders
from email.utils import parseaddr, formataddr
import smtplib
import getpass

def get_res():
    import time
    today_date = time.strftime('%Y-%m-%d', time.localtime(time.time()))
    username = getpass.getuser()
    today_report_path = '/home/%s/work/reports/%s' %(username, today_date)
    stat_report_path = '%s/status.txt' % today_report_path
    with open(stat_report_path, 'r+') as f:
        res = f.read()
    return res

def msg_html_format():
    import time, re
    today_date = time.strftime('%Y-%m-%d', time.localtime(time.time()))
    res_str = get_res().strip()
    res_str_list = res_str.split('\n\n')
    body_msg = ''
    for line in res_str_list:
        if re.search('Failed', line):
            body_msg += '<p><font color="red">%s</font></p>\n' % line
        else:
            body_msg += '<p>%s</p>\n' % line
    head_msg = '''<h1>Gens testing on %s </h1>''' % today_date
    mail_msg = head_msg + body_msg
    return mail_msg

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr.encode('utf-8') if isinstance(addr, unicode) else addr))

from_addr = "jie.chen@simright.com"
password = "cj_3460219"
to_addr = ["shineyao0221@simright.com", "sunjingchao@simright.com", "zhangj@simright.com", "kang@simright.com"]
# to_addr = "jie.chen@simright.com"
smtp_server = "smtp.mxhichina.com"

msg = MIMEText(msg_html_format(), 'html', 'utf-8')

msg['From'] = _format_addr("Tester <%s> " % from_addr)
if isinstance(to_addr, list):
    all_addr = ",".join(to_addr)
    msg['To'] = all_addr
else:
    msg['To'] = to_addr
msg['Subject'] = Header("Results of Gens Unittest")


server = smtplib.SMTP(smtp_server, 25)
# server.set_debuglevel(1)  **print some mutual information**
server.login(from_addr, password)
server.sendmail(from_addr, to_addr, msg.as_string())
server.quit()