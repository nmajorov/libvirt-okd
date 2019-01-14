#!/bin/env python

# test ldap search

#author nmajorov@redhat.com



import ldap



#do not check the certificates
ldap.set_option(ldap.OPT_X_TLS_REQUIRE_CERT,ldap.OPT_X_TLS_NEVER)

l = ldap.initialize("ldaps://ldap-ch.balgroupit.com/",trace_level=0)

l.simple_bind_s("l004580@balgroupit.com","SECRETPASSWORD")

basedn="OU=Users,OU=CIT-P,DC=balgroupit,DC=com"

filter="(&(objectClass=person)(sAMAccountName=B037127)(memberOf=CN=f-openshift-cluster-admin,OU=BCH,OU=CH,OU=Ressources-GRP,OU=Groups,OU=CIT-P,DC=balgroupit,DC=com))"

#filter="(&(objectClass=person)(sAMAccountName='B0*')(memberOf=OU=BCH,OU=CH,OU=Ressources-GRP,OU=Groups,OU=CIT-P,DC=balgroupit,DC=com))"

r=l.search_s(basedn,ldap.SCOPE_SUBTREE,filter,["cn","sAMAccountName"])



print("result ",repr(r))



#for dn, entry in r:

#   print("processing",repr(dn))
