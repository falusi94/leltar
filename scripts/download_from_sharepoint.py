from sharepoint import SharePointSite
from urllib2 import BaseHandler, build_opener
import os


class CookieAuthHandler(BaseHandler):
    def __init__(self, cookies):
        self.cookies = cookies

    def http_request(self, request):
        for c in cookies:
            request.add_header('Cookie', c)
        return request
    https_request = http_request


server_url = "https://schonherzkollegium.sharepoint.com/"
site_url = server_url + "teams/SKA/Leltar/"
rtFa = ""
FedAuth = ""
auth_cookie = "rtFa=" + rtFa + "; FedAuth=" + FedAuth
cookies = [auth_cookie]
opener = build_opener(CookieAuthHandler(cookies))
site = SharePointSite(site_url, opener)

for sp_list in site.lists:
    print(sp_list.id, sp_list.meta['Title'])
c = 0
for row in site.lists['{b4719275-6428-437b-92c9-284f23a2fa26}'].rows:
    try:
        for a in row.attachments:
            name = a.url.split('/')[-1]
            fn = row.Title + '_' + name
            if not os.path.exists(fn):
                try:
                    fuckingrandomshit = a.open()
                    with open(fn, 'w') as outf:
                        outf.write(fuckingrandomshit.read())
                    fuckingrandomshit.close()
                except:
                    print('Fail %s' % a.Title)
            c += 1
    except:
        print('Fail')

print("Downloaded %d images" % c)
