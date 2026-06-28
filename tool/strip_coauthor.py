import sys

msg = sys.stdin.read()
msg = msg.replace("Co-authored-by: Cursor <cursoragent@cursor.com>\n", "")
msg = msg.replace("Co-authored-by: Cursor <cursoragent@cursor.com>\r\n", "")
sys.stdout.write(msg)
