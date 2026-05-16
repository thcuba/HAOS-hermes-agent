worker_processes 1;
pid /var/run/nginx.pid;
error_log stderr warn;

events {
    worker_connections 256;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    client_body_buffer_size 16m;
    client_max_body_size 0;

    log_format minimal '$remote_addr - $request_uri $status';
    access_log /dev/stdout minimal;

    upstream hermes_api {
        server 127.0.0.1:8642;
    }

    upstream hermes_dashboard {
        server 127.0.0.1:9119;
    }

    map $http_x_forwarded_prefix $dashboard_proxy_prefix {
        default "$http_x_forwarded_prefix/dashboard";
        "" "/dashboard";
    }

    # HA Ingress sends X-Ingress-Path; custom reverse proxies may send X-Forwarded-Prefix.
    map $http_x_ingress_path $dashboard_forwarded_prefix {
        default "$http_x_ingress_path/dashboard";
        "" $dashboard_proxy_prefix;
    }

    # ── Ingress (HA sidebar) ─────────────────────────────────────────
    server {
        listen %%INGRESS_PORT%%;
        server_name _;

        # API
        location /v1/ {
            proxy_pass http://hermes_api;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_buffering off;
            proxy_read_timeout 3600s;
            proxy_send_timeout 3600s;
        }

        # Dashboard
        location = / { return 302 /dashboard/; }
        location = /dashboard { return 302 /dashboard/; }

        location /dashboard/api/ {
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

        location = /health {
            access_log off;
            return 200 "OK\n";
            add_header Content-Type text/plain;
        }
    }

    %%INCLUDE_PORTS%%
}
