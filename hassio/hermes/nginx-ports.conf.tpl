    # Direct dashboard API token guard.
    map_hash_bucket_size 128;
    map "$http_x_hermes_session_token|$http_authorization" $dashboard_token_ok {
        default 0;
        ~^%%DASHBOARD_TOKEN%%\| 1;
        ~^\|Bearer\ %%DASHBOARD_TOKEN%%$ 1;
    }

    # ── HTTP (direct LAN access) ─────────────────────────────────────
    server {
        listen %%HTTP_PORT%%;
        server_name _;

        # API_START
        location /v1/ {
            proxy_pass http://hermes_api;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_buffering off;
            proxy_read_timeout 3600s;
            proxy_send_timeout 3600s;
        }
        # API_END

        # DASHBOARD_START
        location = / { return 302 /dashboard/; }
        location = /dashboard { return 302 /dashboard/; }

        location /dashboard/api/ {
            if ($dashboard_token_ok = 0) {
                return 401;
            }
            proxy_pass http://hermes_dashboard/api/;
            proxy_http_version 1.1;
            proxy_set_header Host 127.0.0.1;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Prefix $dashboard_forwarded_prefix;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Authorization "Bearer %%DASHBOARD_TOKEN%%";
            proxy_set_header X-Hermes-Session-Token "%%DASHBOARD_TOKEN%%";
            proxy_buffering off;
            proxy_read_timeout 300s;
            proxy_send_timeout 300s;
        }
        location /dashboard/ {
            proxy_pass http://hermes_dashboard/;
            proxy_http_version 1.1;
            proxy_set_header Host 127.0.0.1;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Prefix $dashboard_forwarded_prefix;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Authorization "Bearer %%DASHBOARD_TOKEN%%";
            proxy_set_header X-Hermes-Session-Token "%%DASHBOARD_TOKEN%%";
            proxy_buffering off;
            proxy_read_timeout 300s;
            proxy_send_timeout 300s;
        }
        # DASHBOARD_END

        location = /health {
            access_log off;
            return 200 "OK\n";
            add_header Content-Type text/plain;
        }
    }
