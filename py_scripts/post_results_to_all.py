from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.header import Header
from email import encoders
from email.utils import parseaddr, formataddr
import smtplib
import getpass
import os

def get_report_dir():
    import time
    today_date = time.strftime('%Y-%m-%d', time.localtime(time.time()))
    username = getpass.getuser()
    today_report_path = '/home/%s/work/reports/%s' % (username, today_date)
    return today_report_path

def get_status_res():
    report_dir = get_report_dir()
    stat_file_path = '%s/status.txt' % report_dir
    with open(stat_file_path, 'r+') as f:
        res = f.read()
    return res

def msg_content_format():
    import time, re
    today_date = time.strftime('%Y-%m-%d', time.localtime(time.time()))
    res_str = get_status_res().strip()
    res_str_list = res_str.split('\n\n')
    body_msg = ''
    attach_file_list = []
    count = 0
    for line in res_str_list:
        if re.search('Failed', line):
	    count += 1
            body_msg += '<p><font color="red">%s</font></p>\n' % line
            line_list = re.split('\s', line)
            file_path = line_list[2] + ".txt"
            total_file_path = os.path.join(get_report_dir(), file_path)
            attach_file_list.append(total_file_path)
        else:
            body_msg += '<p>%s</p>\n' % line
    head_msg = '''<h1>Gens testing on %s </h1>''' % today_date
    tail_msg = '''\n<h2>Please checkout attached files to know why some unittests fail</h2>'''
    mail_msg = head_msg + body_msg + tail_msg
    return mail_msg, attach_file_list, count


def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr.encode('utf-8') if isinstance(addr, unicode) else addr))

from_addr = "jie.chen@simright.com"
password = "cj_3460219"
to_addr = ["zhangj@simright.com",
           "kang@simright.com",
           "julin@simright.com",
           "jie.chen@simright.com",
           "hsn@simright.com"]
#to_addr = "jie.chen@simright.com"
smtp_server = "smtp.mxhichina.com"

text_content = msg_content_format()[0]
count = msg_content_format()[2]
msg = MIMEMultipart()

msg.attach(MIMEText(text_content, 'html', 'utf-8'))

msg['From'] = _format_addr("Tester <%s> " % from_addr)
if isinstance(to_addr, list):
    all_addr = ",".join(to_addr)
    msg['To'] = all_addr
else:
    msg['To'] = to_addr

if count == 0:
    msg['Subject'] = Header("Results of Gens Unittest - all passed")
else:
    msg['Subject'] = Header("Results of Gens Unittest - %d failed" % count)

attach_file = msg_content_format()[1]
if len(attach_file) != 0:
    for f in attach_file:
        if os.path.isfile(f):
            fname = os.path.basename(f)
            att = MIMEText(open(f, 'rb').read(), 'base64', 'utf-8')
            att["Content-Type"] = 'application/octet-stream'
            att["Content-Disposition"] = 'attachment; filename="%s"' % fname
            msg.attach(att)

server = smtplib.SMTP(smtp_server, 25)
server.login(from_addr, password)
server.sendmail(from_addr, to_addr, msg.as_string())
server.quit()
