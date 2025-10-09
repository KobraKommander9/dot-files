#!/usr/bin/env fish

function pgbilling
    kpg $DEV_BILLING_DB_POD $DEV_BILLING_DB_NAME $DEV_BILLING_DB_USER
end
